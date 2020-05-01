#!/usr/bin/env bash

if (( $# > 0 )) 
then
  ./tenant-generator.sh $1
  pushd .
  cd ../vagrantK8s/
  yes Y | ./run-test-from-sratch.sh
  popd 
  
  cd ../sidecar/perf-sidecar-injector/
  make release
else
  echo "Require one paras: Number of tenants"
fi



