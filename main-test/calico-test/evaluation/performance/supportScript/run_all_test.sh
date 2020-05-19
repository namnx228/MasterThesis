#!/usr/bin/env bash
NUMTURN=5
runSpecificExperienment(){
  pushd .
    cd ../$1
    ./exp1_vari_tenants.sh test1 && ./exp1_vari_tenants.sh test2
  popd
}
for i in $(seq 1 ${NUMTURN})
do
  runSpecificExperienment exp1
  runSpecificExperienment exp2
  runSpecificExperienment exp6
  runSpecificExperienment exp7
  runSpecificExperienment exp8
  runSpecificExperienment exp9
  # ../exp1/exp1_vari_tenants.sh test1 && ../exp1/exp1_vari_tenants.sh test2
  # ../exp2/exp1_vari_tenants.sh test1 && ../exp2/exp1_vari_tenants.sh test2
  # ../exp6/exp1_vari_tenants.sh test1 && ../exp6/exp1_vari_tenants.sh test2
  # ../exp7/exp1_vari_tenants.sh test1 && ../exp7/exp1_vari_tenants.sh test2
  # ../exp8/exp1_vari_tenants.sh test1 && ../exp8/exp1_vari_tenants.sh test2
  # ../exp9/exp1_vari_tenants.sh test1 && ../exp9/exp1_vari_tenants.sh test2
done
