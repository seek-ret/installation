Seekret
=======
Docker deployment  
Sniffer docker will passively sniff target container traffic and move the pcaps to the remote bucket.
Supported buckets: S3 or GCS

The machine must be configured to have an IAM Role access or provide ACCESS_KEY and SECRET_KEY via the configuration to the docker  

## Installation

Edit the conf.env with the following values:

_Bucket access parameters: (**or** use an IAM role **instead** - with AWS S3 buckets only)_ 
- ACCESS_KEY            - HMAC key for target bucket
- SECRET_ACCESS_KEY     - secret key for target bucket
- S3_URL                - endpoint-url (_must be configured to https://storage.googleapis.com if the bucket is a GCS bucket_) 
- REGION                - to provide default region for the target bucket (_optional_)

- BUCKET_NAME           - name of the target bucket to send the pcaps
- FOLDER_NAME           - name of the folder inside the bucket to store the pcaps
- BPF_FILTER            - port number and protocol type you want to sniff (e.g: tcp port 80)
- ROTATION_SECONDS      - time interval to rotate pcap files by the sniffer (_optional_)
- MAX_FILE_SIZE         - max size of the single pcap file (_optional_)
- DUMP_DIR              - local directory to temporary store pcap files (_optional_)
- PREFIX                - prefix string to pcap file names (_optional_) 

## Run

_Replace **<container_name>** with the actual name of the target container_

Run : `docker run -d --rm --net container:<container_name> --env-file ./conf.env  --log-driver json-file --log-opt max-size=10m --log-opt max-file=5 gcr.io/seekret/sniffer:2` 

