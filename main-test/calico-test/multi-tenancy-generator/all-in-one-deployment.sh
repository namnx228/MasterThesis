#!/usr/bin/env bash

if (( $# > 0 )) 
then
  ./tenant-generator.sh $1
else
  ./tenant-generator.sh # By default: 2 tenants
fi

pushd .
cd ../vagrantK8s/
yes Y | ./run-test-from-sratch.sh
popd 

cd ../sidecar/perf-sidecar-injector/
make release


