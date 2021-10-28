#! /bin/bash

ACCESS_KEY=$(/opt/elasticbeanstalk/bin/get-config environment -k ACCESS_KEY)
SECRET_ACCESS_KEY=$(/opt/elasticbeanstalk/bin/get-config environment -k SECRET_ACCESS_KEY)
STORAGE_PROVIDER=$(/opt/elasticbeanstalk/bin/get-config environment -k STORAGE_PROVIDER)
BUCKET_NAME=$(/opt/elasticbeanstalk/bin/get-config environment -k BUCKET_NAME)
FOLDER_NAME=$(/opt/elasticbeanstalk/bin/get-config environment -k FOLDER_NAME)
BPF_FILTER=$(/opt/elasticbeanstalk/bin/get-config environment -k BPF_FILTER)

sudo systemctl restart docker
sudo docker run -d --rm --net host -e ACCESS_KEY="${ACCESS_KEY}" -e SECRET_ACCESS_KEY="${SECRET_ACCESS_KEY}" \
  -e FOLDER_NAME="${FOLDER_NAME}" -e BUCKET_NAME="${BUCKET_NAME}" -e STORAGE_PROVIDER="${STORAGE_PROVIDER}" \
  -e BPF_FILTER="${BPF_FILTER}" --log-driver json-file --log-opt max-size=10m --log-opt max-file=5 seekret/sniffer:2
