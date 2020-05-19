#!/usr/bin/env bash
NUMTURN=5
for i in $(seq 1 ${NUMTURN})
do
  ../exp1/exp1_vari_tenants.sh test1 && ../exp1/exp1_vari_tenants.sh test2
  ../exp2/exp1_vari_tenants.sh test1 && ../exp2/exp1_vari_tenants.sh test2
  ../exp6/exp1_vari_tenants.sh test1 && ../exp6/exp1_vari_tenants.sh test2
  ../exp7/exp1_vari_tenants.sh test1 && ../exp7/exp1_vari_tenants.sh test2
  ../exp8/exp1_vari_tenants.sh test1 && ../exp8/exp1_vari_tenants.sh test2
  ../exp9/exp1_vari_tenants.sh test1 && ../exp9/exp1_vari_tenants.sh test2
done
