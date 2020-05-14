#!/usr/bin/env bash
REPLICAS_LIST=(2 5 10 15 20 25 30 35 40)
today=$(date +%d.%m-%T)
result_file="./result/${today}"
for i in ${REPLICAS_LIST[@]}
do
  echo $i >> ${result_file} # Number of replicas
  ./run30Times.sh $i >> ${result_file}
  printf "\0\0" >> ${result_file}
done
