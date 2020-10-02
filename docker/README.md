Seekret
=======
Docker deployment (just the sniffer docker without minio). 
Sniffer docker will passively sniff target container traffic and move the pcaps to S3 bucket.

The machine must be configured to have an IAM Role access or provide ACCESS_KEY and SECRET_KEY via configuration to the docker  

## Requirements

 - Access to **S3** Storage Bucket 
 - Target container should have **HTTP** traffic

## Installation

Edit the conf.env with the following values:

_Bucket access parameters: (**or** use an IAM role **instead**)_ 
- AWS_ACCESS_KEY_ID     - access key for S3 bucket in AWS
- AWS_SECRET_KEY        - secret key as AWS generated

- BUCKET_NAME           - customer_name
- FOLDER_NAME           - pcaps/container_name
- PREFIX                - relevant only for K8s deployment
- BPF_FILTER            - port number you want to sniff

## Run

_change **<container_name>** to the actual name of the target container_

Run : `docker run -d --rm --net container:<container_name> --env-file ./conf.env  --log-driver json-file --log-opt max-size=10m --log-opt max-file=5 seekret/sniffer:1` 

