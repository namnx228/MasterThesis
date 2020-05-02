#!/usr/bin/env bash
set -ex
if (( $# > 0 )) 
then
  ./tenant-generator.sh $1
  yes Y | ./interact-with-k8s.sh
  cd ../sidecar/perf-sidecar-injector/sidecar-container/
  make release || true
else
  echo "Require one paras: Number of tenants"
fi



