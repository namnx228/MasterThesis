#!/bin/bash 
#To take from the admin-cluster config (to modify) 
set -ex 
certificate_data=$(python ../certificate_yaml/get-certificate.py) 
server=$(python ../certificate_yaml/get-server.py) #The default path for Kubernetes CA

ca_path="/tmp/pki"
#The default name for the Kubernetes cluster
cluster_name="kubernetes"


create_user() {
	#Create the user
	printf "User creation\n"
	if [ -d /home/$user ]
        then
          sudo userdel $user -r
          sudo adduser $user
        else
          sudo adduser $user
        fi

        
        # Create file name directory
        sudo mkdir $filename -p
	#Create private Key for the user

	printf "Private Key creation\n"
	sudo openssl genrsa -out $filename.key 2048

	#Create the CSR
	printf "\nCSR Creation\n"
	if [ $group == "None" ]; then
		sudo openssl req -new -key $filename.key -out $filename.csr -subj "/CN=$user" 
	else
		sudo openssl req -new -key $filename.key -out $filename.csr -subj "/CN=$user/O=$group"
	fi 

	#Sign the CSR 
	printf "\nCertificate Creation\n"
	sudo openssl x509 -req -in $filename.csr -CA $ca_path/ca.crt -CAkey $ca_path/ca.key -CAcreateserial -out $filename.crt -days $days

	#Create the .certs and mv the cert file in it
	printf "\nCreate .certs directory and move the certificates in it\n" 
	sudo mkdir $user_home/.certs && sudo mv $filename.* $user_home/.certs

	#Create the credentials inside kubernetes
	printf "\nCredentials creation\n"
        mkdir /tmp/$user -p
        sudo cp $user_home/.certs/$user.crt /tmp/$user && sudo chown $USER:$USER /tmp/$user/$user.crt
        sudo cp $user_home/.certs/$user.key /tmp/$user && sudo chown $USER:$USER /tmp/$user/$user.key
        # docker cp /tmp/$user/$user.crt ${cluster_name}-control-plane-1:/tmp/
        # docker cp /tmp/$user/$user.key ${cluster_name}-control-plane-1:/tmp/

	#kubectl config set-credentials $user --client-certificate=/tmp/$user/$user.crt  --client-key=/tmp/$user/$user.key
	kubectl config set-credentials $user --client-certificate=$user_home/.certs/$user.crt  --client-key=$user_home/.certs/$user.key


	#Create the context for the user
	printf "\nContext Creation\n"
	kubectl config set-context $user-context --cluster=$cluster_name --user=$user 

        # if [[ $user == "test1" ]]
        # then
	  # kubectl config set-context $user-context --cluster=$cluster_name --user=$user --namespace=ns1
        # else
	  # kubectl config set-context $user-context --cluster=$cluster_name --user=$user --namespace=ns2
        # fi

	#Edit the config file
	printf "\nConfig file edition\n"
	sudo mkdir $user_home/.kube
        if [ -f /tmp/config ]
        then
          sudo rm -f /tmp/config
        fi
	cat <<-EOF > /tmp/config 
	apiVersion: v1
	clusters:
	- cluster:
	    certificate-authority-data: $certificate_data
	    server: $server
	  name: $cluster_name
	contexts:
	- context:
	    cluster: $cluster_name
	    user: $user
	  name: $user-context
	current-context: $user-context
	kind: Config
	preferences: {}
	users:
	- name: $user
	  user:
            client-certificate-data: $(sudo cat $user_home/.certs/$user.crt | base64 -w 0)
            client-key-data: $(sudo cat $user_home/.certs/$user.key | base64 -w 0)
	EOF
        sudo cp /tmp/config $user_home/.kube/config
	
	#Change the the ownership of the directory and all the files
	printf "\nOwnership update\n"
        echo "export DATASTORE_TYPE=kubernetes" | sudo tee $user_home/.bashrc -a
        echo "export KUBECONFIG=$user_home/.kube/config" | sudo tee  $user_home/.bashrc -a
        echo 'source <(kubectl completion bash)' | sudo tee $user_home/.bashrc -a
        echo "alias kubectl=\"kubectl -n $user \"" | sudo tee $user_home/.bashrc -a
	sudo chown -R $user:$user $user_home
}


usage() { printf "Usage: \n   Mandatory: User. \n   Optionals: Days (360 by default) and Group. \n   [-u user] [-g group] [-d days]\n" 1>&2; exit 1; }

while getopts ":u:g:d:" o; do
    case "${o}" in
        u)
            user=${OPTARG}
            ;;
        g)
            group=${OPTARG}
            ;;
        d)
            days=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

#User is mandatory
if [ -z "${user}" ] ; then
    usage
fi

#Default Value for Group
if [ -z "${group}" ] ; then
	group="None"
fi

#VDefault Value for $days
if [ -z "${days}" ] ; then
	days=360
fi

#Set up variables
user_home="/home/$user"
filename=$user_home/$user

#Execute the function
create_user


