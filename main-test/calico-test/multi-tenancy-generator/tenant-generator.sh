#! /usr/bin/env bash
set -e
# set -x
# Get list of file 
# Xu ly tung file:
# Get cai dir cua no
# Thay the cai {i} = $i
# Tao 1 file moi voi ten filename-$i.yml and print new content to.
if (( $# > 0 ))
then
  NUMOFTENANTS=$1
else
  NUMOFTENANTS=2
fi
filelist=" \
  ../namespace/namespace.format \
  ../role-binding/role-binding.format \
  ../role/role.format \
  ../pool/pools.format \
"
for file in ${filelist}
do
  
  directory=$(dirname ${file})
  fileWithoutExtension="${file%.*}"
  fileWithoutPath=$(basename ${file})
  pushd .
  cd ${directory}
  ls |  grep -v $fileWithoutPath | xargs rm

  for i in $(seq 1 ${NUMOFTENANTS})
  do
    # cau lenh thay the + sinh file 
    sed -e "s|\${i}|${i}|g" ${fileWithoutPath} > ${fileWithoutExtension}-${i}.yml
  done

  popd
done

#------------------------------------
# Only Generate one file
file="../sidecar/perf-sidecar-injector/deployment/configmap.format"
fileWithoutExtension="${file%.*}"
sed -e "s|\${i}|${NUMOFTENANTS}|g" ${file} > ${fileWithoutExtension}.yml

