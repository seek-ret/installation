#!/bin/sh

CURRENT_DIR=$(dirname $(realpath $0))
SEEKRET_IS_RUNNING=0
TEST_ENV_IS_RUNNING=0
NAMESPACE=${NAMESPACE:-"cdtests"}

cleanup() {
  if [ $TEST_ENV_IS_RUNNING -eq 1 ]; then
		run kubectl delete deployment hello-node -n $NAMESPACE
	fi
	if [ $SEEKRET_IS_RUNNING -eq 1 ]; then
		run helm uninstall seekret -n $NAMESPACE
	fi

  if [ $1 -ne 0 ]; then
    echo "Failed."
  else
    echo "Success"
  fi
	exit $1
}

cleanupOnError()
{
  if [ $1 -ne 0 ]; then
    cleanup $1
  fi
}

run()
{
  if [ $OUTPUT -eq 0 ]; then
    $@ > /dev/null 2>&1
  else
    $@
  fi
}

if [ -z $1 ] || [ -z $2 ] || [ -z $3 ]; then
	echo "usage: $(basename $0) <access key> <secret key> <bucket name> [-v optional]"
	exit 1
fi

OUTPUT=0

if [ ! -z $4 ] && [ "$4" = "-v" ]; then
  OUTPUT=1
fi

ACCESS_KEY=$1
SECRET_ACCESS_KEY=$2
BUCKET_NAME=$3
echo "Creating seekret's helm sniffer setup"
run helm install seekret ${CURRENT_DIR}/../helm/seekret/ --set s3.accessKey=${ACCESS_KEY} --set s3.secretKey=${SECRET_ACCESS_KEY} --set s3.bucketName=${BUCKET_NAME}
cleanupOnError $?
run kubectl wait --for=condition=available --timeout=60s deployment/seekret-sidecar-injector -n seekret-injector
cleanupOnError $?
SEEKRET_IS_RUNNING=1
echo "Seekret is up and running"

sleep 5

echo "Creating test node"
kubectl create namespace $NAMESPACE
run kubectl apply -f test-deployment.yaml -n $NAMESPACE
cleanupOnError $?
run kubectl wait --for=condition=available --timeout=60s deployment/hello-node -n $NAMESPACE
cleanupOnError $?
POD=$(kubectl get pods -l app=hello -o custom-columns=:metadata.name -n $NAMESPACE | awk NF)
run kubectl wait --for=condition=Ready pod/"$POD" -n $NAMESPACE
cleanupOnError $?
TEST_ENV_IS_RUNNING=1
echo "Test node is up and running"

run kubectl get all -n seekret-injector
echo "\n\n"
run kubectl get all -n $NAMESPACE

timeout=60
while test $timeout -gt 0; do
  run gsutil ls gs://$BUCKET_NAME/logs/"$POD"_ack.txt
  res=$?
  if [ $res -eq 0 ]; then
    break
  fi
  sleep 1
  timeout=$(expr $timeout - 1)
done

test $timeout -gt 0
cleanup $?
