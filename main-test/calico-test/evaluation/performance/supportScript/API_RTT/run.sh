#!/usr/bin/env bash
NUMOFREQ=1000
for i in $(seq 1 $NUMOFREQ)
do
  curl -w '@curl-format' $1:$2 && sleep 7200
done
