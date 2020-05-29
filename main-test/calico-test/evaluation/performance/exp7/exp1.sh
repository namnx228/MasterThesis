#!/usr/bin/env bash
set -ex
# REPLICAS_LIST=(2 5 10 15 20 25 30 35 40)
REPLICAS_LIST=(1)
today=$(date +%d.%m-%T)
if (( $# < 2 ))
then
  echo "more input, please"
  exit 1
fi
user=${1:-"test1"}
testname=$2
pushd .
  cd ../../../multi-tenancy-generator/
  # ./all-in-one-deployment.sh 2 Not in use because I dont wnat to call docker push
  ./tenant-generator.sh 2
  yes Y | ./interact-with-k8s.sh
  kubectl label namespace test1 sidecar-injector=disabled --overwrite # Ensure that test1 is in insecure situation 
popd
if [[ ${user} == "test1"  ]]
then
  secure="insecure"
else
  secure="secure"
fi
result_file="./result/${secure}/${testname}"
mkdir ./result/${secure} -p
for i in ${REPLICAS_LIST[@]}
do
  # echo $i >> ${result_file} # Number of replicas
  sudo -u ${user} -H ./run30Times.sh $i > ${result_file}
  # printf "\0\0" >> ${result_file}
  # echo -e "------------------------------------\n">> ${result_file}
done
