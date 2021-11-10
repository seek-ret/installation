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
- STORAGE_PROVIDER      - one of `gcs`, `s3`, `azure`
- WORKSPACE             - The target workspace in the Seekret app to send the traffic to. 
- BUCKET_NAME           - name of the target bucket to send the pcaps
- FOLDER_NAME (_deprecated_) - name of the folder inside the bucket to store the pcaps. This argument is deprecated and the WORKSPACE argument should be used.
- BPF_FILTER (_optional_)           - port number and protocol type you want to sniff (e.g: tcp port 80)
- ROTATION_SECONDS (_optional_)     - time interval to rotate pcap files by the sniffer
- MAX_FILE_SIZE (_optional_)        - max size of the single pcap file 
- DUMP_DIR (_optional_)              - local directory to temporary store pcap files
- PREFIX (_optional_)                - prefix string to pcap file names  

## Run

_Replace **<container_name>** with the actual name of the target container_

Run : `docker run -d --rm --net container:<container_name> --env-file ./conf.env  --log-driver json-file --log-opt max-size=10m --log-opt max-file=5 gcr.io/seekret/sniffer:2` 

