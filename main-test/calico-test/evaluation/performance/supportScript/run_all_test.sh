#!/usr/bin/env bash
NUMTURN=10
runSpecificExperienment(){
  experienmentName=$1
  testname=$2
  pushd .
    cd ../${experienmentName}
    ./exp1.sh test1 ${testname} && ./exp1.sh test2 ${testname}
  popd
}
for i in $(seq 1 ${NUMTURN})
do
  runSpecificExperienment exp1 $i
  runSpecificExperienment exp2 $i
  runSpecificExperienment exp6 $i
  runSpecificExperienment exp7 $i
  runSpecificExperienment exp8 $i
  runSpecificExperienment exp9 $i
  # ../exp1/exp1_vari_tenants.sh test1 && ../exp1/exp1_vari_tenants.sh test2
  # ../exp2/exp1_vari_tenants.sh test1 && ../exp2/exp1_vari_tenants.sh test2
  # ../exp6/exp1_vari_tenants.sh test1 && ../exp6/exp1_vari_tenants.sh test2
  # ../exp7/exp1_vari_tenants.sh test1 && ../exp7/exp1_vari_tenants.sh test2
  # ../exp8/exp1_vari_tenants.sh test1 && ../exp8/exp1_vari_tenants.sh test2
  # ../exp9/exp1_vari_tenants.sh test1 && ../exp9/exp1_vari_tenants.sh test2
done
