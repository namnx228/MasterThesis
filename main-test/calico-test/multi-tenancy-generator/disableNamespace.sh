NUMOFDISABLEDTENANTS=${1:-1}
for i in $(seq 1 $NUMOFDISABLEDTENANTS)
do
  kubectl label namespace test${i} sidecar-injector=disabled --overwrite
done

