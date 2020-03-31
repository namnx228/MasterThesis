# -*- mode: ruby -*-
# vi: set ft=ruby :

IMAGE_NAME = "bento/ubuntu-16.04"
N = 2

Vagrant.configure("2") do |config|

    config.ssh.insert_key = false

    config.vm.provider "virtualbox" do |v|
        v.memory = 1024
        v.cpus = 2
    end
      config.vm.synced_folder "./data", "/vagrant_data" # Mycode

    config.vm.define "k8s-master" do |master|
        master.vm.box = IMAGE_NAME
        master.vm.network "private_network", ip: "192.168.50.10"
        master.vm.hostname = "k8s-master"
        master.vm.provision "ansible" do |ansible|
            ansible.playbook = "kubernetes-setup/master-playbook.yml"
            ansible.extra_vars = {
                node_ip: "192.168.50.10",
            }
        end

        # My code
        config.vm.synced_folder "./data", "/vagrant_data"
        

        master.vm.provision "shell", privileged: false, inline: <<-SHELL
          sudo cp -r /etc/kubernetes/pki /vagrant_data/
          sudo cp /home/vagrant/.kube/config /vagrant_data
        SHELL
    end

    (1..N).each do |i|
        config.vm.define "node-#{i}" do |node|
            node.vm.box = IMAGE_NAME
            node.vm.network "private_network", ip: "192.168.50.#{i + 10}"
            node.vm.hostname = "node-#{i}"
            node.vm.provision "ansible" do |ansible|
                ansible.playbook = "kubernetes-setup/node-playbook.yml"
                ansible.extra_vars = {
                    node_ip: "192.168.50.#{i + 10}",
                }
            end
        end
    end

    config.vm.define "tenants-machine" do |tenant|
        # CHange to 1 core
        config.vm.provider "virtualbox" do |v|
            v.memory = 1024
            v.cpus = 2
        end

        config.ssh.forward_agent = true

        tenant.vm.box = IMAGE_NAME
        tenant.vm.network "private_network", ip: "192.168.50.#{N + 1 + 10}"
        tenant.vm.hostname = "tenant-machine"   
        # tenant.vm.provision "file", source: "~/workspace/MasterThesis/", destination: "$HOME/MasterThesis"
        # tenant.vm.provision "file", source: "~/.ssh/id_rsa_github_tenant", destination: "$HOME/.ssh/"
        # tenant.vm.provision "file", source: "~/.gitconfig", destination: "$HOME/"
        # tenant.vm.provision "file", source: "./other/config", destination: "$HOME/.ssh/"
        ########################################################################################################3
        #Another solution
        # system("cp ~/workspace/MasterThesis data/ -r")

        tenant.vm.provision "shell", privileged: false, inline: <<-SHELL
          
          sudo apt-get update && sudo apt-get install -y apt-transport-https
          curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
          echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
          sudo apt-get update
          sudo apt-get install -y kubectl python-pip bash-completion
          curl -O -L  https://github.com/projectcalico/calicoctl/releases/download/v3.13.1/calicoctl
          chmod +x calicoctl
          sudo mv calicoctl /usr/bin/

          export LC_ALL=C
          sudo pip install  pyyaml
          echo "export DATASTORE_TYPE=kubernetes" | sudo tee ~/.bashrc -a
          echo "export KUBECONFIG=$HOME/.kube/config" | sudo tee ~/.bashrc -a
          export DATASTORE_TYPE=kubernetes
          export KUBECONFIG=$HOME/.kube/config #Phai them cai nay moi calicoctl moi co config
          echo "source <(kubectl completion bash)" | tee ~/.bashrc -a

          # echo 'source <(kubectl completion bash)' | sudo tee $user_home/.bashrc -a # Why co cau lenh nay ?

          mkdir /home/vagrant/.kube/ -p
          cp /vagrant_data/pki /tmp/pki -r
          cp  /vagrant_data/config /home/vagrant/.kube/ 
          echo "$(ssh-keyscan github.com)" >> $HOME/.ssh/known_hosts
          git clone git@github.com:namnx228/MasterThesis.git 
          cd MasterThesis
          git checkout -b latest origin/latest
          cd $HOME/MasterThesis/main-test/calico-test/vagrantK8s/
          chmod u+x run-test-from-sratch.sh
          yes Y | ./run-test-from-sratch.sh

          SHELL
    end

end
