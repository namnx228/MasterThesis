#!/usr/bin/env bash
set -ex
if (( $# < 1  ))
then
  echo "Request the number of tenants"
  exit 1
fi
REPLICAS_LIST=(2 40)
NUM_OF_TENANTS_LIST=(2 4 8 16 32 64 128 1024)
today=$(date +%d.%m-%T)

user=${1:-"test1"}
if [[ ${user} == "test1"  ]]
then
  secure="insecure"
else
  secure="secure"
fi
result_file="./result_vari_tenants/${secure}-${today}"
for j in ${NUM_OF_TENANTS_LIST[@]}
do
  pushd .
    cd ../../../multi-tenancy-generator/
    ./all-in-one-deployment.sh $j
    kubectl label namespace test1 sidecar-injector=disabled --overwrite # Ensure that test1 is in insecure situation 
  popd

  echo $j >> ${result_file}

  for i in ${REPLICAS_LIST[@]}
  do
    echo $i >> ${result_file} # Number of replicas
    sudo -u ${user} -H ./run30Times.sh $i >> ${result_file}
    # printf "\0\0" >> ${result_file}
  done

  echo -e "---------------------------\n">> ${result_file}
done
