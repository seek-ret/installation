Seekret
=======
Docker deployment  
Sniffer docker will passively sniff target container traffic and move the pcaps to the remote bucket.
Supported buckets: S3.

## Self-hosted Bucket Setup

**The machine must be configured to have an IAM Role access or provide ACCESS_KEY and SECRET_ACCESS_KEY via the configuration to the docker**

## Installation

Edit the awscli.env with the following values:

_Bucket access parameters: (**or** use an IAM role **instead** - with AWS S3 buckets only)_ 
- ACCESS_KEY            - Access Key ID for target S3 bucket, if not provided assuming aws role.
- SECRET_ACCESS_KEY     - Access Secret Key for target S3 bucket, if not provided assuming aws role.
- WORKSPACE             - The target workspace in the Seekret app to send the traffic to. 
- BUCKET_NAME           - name of the target bucket to send the pcaps
- BPF_FILTER (_optional_)           - port number and protocol type you want to sniff (e.g: tcp port 80)
- ROTATION_SECONDS (_optional_)     - time interval to rotate pcap files by the sniffer _(default 60 seconds)_
- MAX_FILE_SIZE (_optional_)        - max size of the single pcap file in megabytes _(default 10 MB)_
- DUMP_DIR (_optional_)             - local directory to temporary store pcap files
- PREFIX (_optional_)               - prefix string to pcap file names  
- SERVICE_NAME (_optional_)         - The service name to which the traffic belongs

## Run

_Replace **<container_name>** with the actual name of the target container_

Run : `docker run -d --net container:<container_name> --env-file ./awscli.env  --log-driver json-file --log-opt max-size=10m --log-opt max-file=5 gcr.io/seekret/sniffer:2-aws` 

