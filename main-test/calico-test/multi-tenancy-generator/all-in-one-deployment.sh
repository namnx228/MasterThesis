#!/usr/bin/env bash

if (( $# > 0 )) 
then
  ./tenant-generator.sh $1
  yes Y | ./interact-with-k8s.sh
  cd ../sidecar/perf-sidecar-injector/sidecar-container/
  make release
else
  echo "Require one paras: Number of tenants"
fi



