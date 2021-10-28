Seekret
=======
An AWS elastic beanstalk deployment options.

## Pre-requisites

- Elastic beanstalk deployment over Amazon linux v2
- Docker based beanstalk deployment.
- ACCESS_KEY, SECRET_KEY and BUCKET_NAME (supported buckets: GCS / S3 / Azure Blob)

## Deployment

### Add elastic beanstalk hook files

Seekret is using hook files to deploy our sniffer on your machine.
1. [.ebextensions/options.config](options.config)
   1. installs docker
   2. pull seekret [sniffer script](https://raw.githubusercontent.com/seek-ret/installation/master/aws-elastic-beanstalk/run.sh)
   3. assign run permissions to the sniffer script
2. [.platform/hooks/postdeploy/001_run_seekret_sniffer.sh](001_run_seekret_sniffer.sh)
   1. Run in non-blocking mode our sniffer
   
Add the files to your source code or to your zip file of the deployment in the marked locations.

### Add the environment variables to the beanstalk environment variables
1. [How to set environment variables in beanstalk environment](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/environments-cfg-softwaresettings.html#environments-cfg-softwaresettings-console)
2. Set the following environment variables:
   1. Required
      1. ACCESS_KEY - The access key to the bucket.
      2. SECRET_ACCESS_KEY - The secret key to the bucket.
      3. BUCKET_NAME - The bucket name.
      4. STORAGE_PROVIDER - Choose one of the following `gcs` or `aws` or `azure`.
      5. FOLDER_NAME - Set to `default`.
      6. BPF_FILTER - Set the filter for the traffic.
