#!/usr/bin/env bash
REPLICAS_LIST=(2 5 10 15 20 25 30 35 40)
today=$(date +%d.%m-%T)
if [[ ${USER} == "test1"  ]]
then
  secure="insecure"
else
  secure="secure"
fi
result_file="./result/${secure}-${today}"
for i in ${REPLICAS_LIST[@]}
do
  echo $i >> ${result_file} # Number of replicas
  ./run30Times.sh $i >> ${result_file}
  # printf "\0\0" >> ${result_file}
  echo -e "\n\n">> ${result_file}
done
