Seekret
=======
Docker deployment

## Requirements

 - Access to Storage Bucket 

## Installation

Edit the conf.env with the following values:

_if using minio container: (for buckets other than AWS S3)_
- MINIO_ACCESS_KEY      - Minio access key (for example seekXXX)
- MINIO_SECRET_KEY      - Minio secret key

_Bucket access parameters: (**or** use an IAM role **instead**)_ 
- AWS_ACCESS_KEY_ID     - access key for S3 bucket in AWS
- AWS_SECRET_KEY        - secret key as AWS generated

- BUCKET_NAME           - customer_name
- FOLDER_NAME           - pcaps/container_name/
- PREFIX                - relevant only for K8s deployment
- BPF_FILTER            - port number you want to sniff

## Run
### docker option

_use target container's network that you want to sniff on_

Run : `docker run -d --rm --net container:<container_name> --env-file ./conf.env  --log-driver json-file --log-opt max-size=10m --log-opt max-file=5 seekret/sniffer:1` 

### docker compose option
Run : `docker-compose --env-file ./conf.env up -d`

### side-by-side docker-compose option
If docker compose yaml already exists, run the command:
`docker-compose -f docker-compose-customer.yml -f docker-compose-seekret.yml run backup_db`
