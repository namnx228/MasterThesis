#!/usr/bin/env bash
set -ex
shopt -s expand_aliases
alias kubectl="kubectl -n ${USER}"
SERVER_POD="iperf-server"
CLIENT_DEPLOYMENT="iperf-client"
SERVICE="iperf-service"
TESTING_TIME=2
REPLICAS_PARAS=${1:-1} # Now: 1


#---------------------------------------
checkClientDeploymentAvailable (){
  kubectl get deployments.apps ${CLIENT_DEPLOYMENT} -o jsonpath="{.status.replicas}"
}

checkServerPodAvailable (){
  kubectl get pod ${SERVER_POD} | grep Running -c
}

loopUntilAvailabe()
{
  while true 
  do
    isServerAvailable=$(checkServerPodAvailable)
    if (( ${isServerAvailable} !=  0 ))
    then
      break
    fi
  done
  # sleep 5 # Make sure that server and service are ready before client deployment
  deployClient > /dev/null
  while true 
  do 
    isClientAvailable=$(checkClientDeploymentAvailable)

    if [[ ${isClientAvailable} == $REPLICAS ]] 
    then
      sleep $(python -c "print $TESTING_TIME + 2 + 2") # Test time + 2 + (more time to ensure) 2
      server_log=$(kubectl logs ${SERVER_POD} ${SERVER_POD} | grep "SUM" | grep "sec" )
      if [[ ${server_log} != ""  ]]
      then
        echo $(echo ${server_log} | awk '{print $7}')
        break
      else
        deployClient > /dev/null
      fi
    fi
  done
}

checkClientTerminated (){
  kubectl get deployments.apps ${CLIENT_DEPLOYMENT}  2> /dev/null
}

loopUntilCLientTerminated(){
  while true
  do
    if [[ $(checkClientTerminated) == "" ]]
    then
      break
    fi
  done
}

deployClient(){
  kubectl delete deployment ${CLIENT_DEPLOYMENT}  > /dev/null || true
  loopUntilCLientTerminated > /dev/null
  cat <<SHELL | kubectl apply -f - > /dev/null  # Deploy client 
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: ${CLIENT_DEPLOYMENT}
      labels:
        app: ${CLIENT_DEPLOYMENT}
    spec:
      replicas: ${REPLICAS}
      selector:
        matchLabels:
          app: ${CLIENT_DEPLOYMENT}
      template:
        metadata:
          labels:
            app: ${CLIENT_DEPLOYMENT}
        spec:
          containers:
          - name: ${CLIENT_DEPLOYMENT}
            image: namnx228/k8s-multitenancy-iperf-amd64
            command:
              - bash
              - "-c"
              - "iperf -c ${SERVICE} -t ${TESTING_TIME} -p 5000 -f m -P 100 && sleep 3600"
            imagePullPolicy: IfNotPresent
SHELL
}
#----------------------------------------
# FUnction: input: number of pods
runTestOneTime() {
  # Delete old thing
  # Deploy new thing: Only one client
  # sleep 3 to wait for connection done
  # Collect result: How ?

  REPLICAS=${1:-1} # Now: 1
  kubectl delete pod ${SERVER_POD}  > /dev/null || true
  kubectl delete svc ${SERVICE}  > /dev/null || true
  cat <<SHELL | kubectl apply -f - > /dev/null # Deploy server pod
    apiVersion: v1
    kind: Pod
    metadata:
      name: ${SERVER_POD}
      labels:
        app: ${SERVER_POD}
    spec:
      containers:
      - name: ${SERVER_POD}
        image: namnx228/k8s-multitenancy-iperf-amd64
        command:
          - bash
        args:
          - "-c"
          - "iperf -s -p 5000 -f m"
        ports:
          - containerPort: 5000
        imagePullPolicy: IfNotPresent
      restartPolicy: Always
SHELL

  cat <<SHELL | kubectl apply -f - > /dev/null # Deploy server service
    apiVersion: v1
    kind: Service
    metadata:
      name: ${SERVICE}
    spec:
      selector:
        app: ${SERVER_POD}
      ports:
        - protocol: TCP
          port: 5000
          targetPort: 5000
SHELL

  # deployClient # Deploy in the loopUntilAvailable
  sleep 3 # Wait until server deployment is done
  echo $(loopUntilAvailabe)
}

run30Time(){
  let sum=0 || true
  let thisTime=0 || true
  for i in $(seq 1 31)
  do
    if (( $i == 1 ))
    then
      continue
    fi
    thisTime=$(runTestOneTime ${REPLICAS_PARAS})
    sum=$(python -c "print ${sum} + ${thisTime}")
  done
  kubectl delete deployment ${DEPLOYMENT_NAME}  > /dev/null || true
  result=$(python -c "print ${sum} / 30.0")
  echo ${result} "MBit/sec"
}

run30Time