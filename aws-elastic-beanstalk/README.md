Seekret
=======
An AWS elastic beanstalk deployment options.

## Pre-requisites

- Elastic beanstalk deployment over Amazon linux v2
- Docker based beanstalk deployment.
- ACCESS_KEY, SECRET_KEY and BUCKET_NAME (supported buckets: GCS / S3 / Azure Blob)

## Notes

- Currently, **not** supported on multi-container option
- That deployment should be done for each target container you want to capture its traffic.
- We do recommend adding the setup to be part of the `eb deploy` procedure of your CD automation.

## Deployment

### Add elastic beanstalk hook files

Seekret is using hook files to deploy our sniffer on your machine.
1. [.ebextensions/options.config](options.config)
   1. Installs docker
      1. This step is optional and will be done if and only if docker does not exist on the machine (according to the section `Specifying versions` [here](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/customize-containers-ec2.html#linux-packages))
   2. Pulls seekret's [sniffer script](https://raw.githubusercontent.com/seek-ret/installation/master/aws-elastic-beanstalk/run.sh)
   3. Assigns run permissions to the sniffer script
2. [.platform/hooks/postdeploy/001_run_seekret_sniffer.sh](001_run_seekret_sniffer.sh)
   1. Runs our sniffer in non-blocking-mode
   
Add the files to your source code or to your zip file of the deployment in the marked locations.

### Add the environment variables to the beanstalk environment variables
1. [How to set environment variables in beanstalk environment](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/environments-cfg-softwaresettings.html#environments-cfg-softwaresettings-console)
2. Set the following environment variables:
   1. Required
      1. ACCESS_KEY - The access key to the bucket.
      2. SECRET_ACCESS_KEY - The secret key to the bucket.
      3. BUCKET_NAME - The bucket name.
      4. STORAGE_PROVIDER - Choose one of the following `gcs` or `aws` or `azure`.
      5. WORKSPACE - Set to `default`.
      6. BPF_FILTER - Set the filter for the traffic.
     
![elastic-beanstalk](https://user-images.githubusercontent.com/17148247/139697438-20c6d424-8972-4827-975a-37e42cec6532.png)

