Setup for Seekret Deployment with Amazon VPC Traffic Mirroring.

**Table of Contents**
1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Deployment](#deployment)
   1. [Sample Service](#sample-service)
   2. [Target Instance](#target-instance)
   3. [VPC Mirroring](#vpc-mirroring)
4. [Analyzing and Capturing Mirrored Traffic](#analyzing-and-capturing-mirrored-traffic)
5. [Additional Features](#additional-features)
   1. [HTTPS Listener for Sample Service
](#https-listener-for-sample-service)
   2. [Mirror Filters for Application Load Balancers
](#mirror-filters-for-application-load-balancers)
6. [Cleanup](#cleanup)
7. [Sources, References & Additional Material](#sources-references-&-additional-material)

## Introduction

This repository contains a setup for Seekret's sniffer deployed along Amazon VPC Traffic Mirroring.

Amazon VPC Traffic Mirroring allows you to mirror network traffic from an Elastic Network Interface (ENI) to another ENI (or a Network Load Balancer). See [AWS Documentation](https://docs.aws.amazon.com/vpc/latest/mirroring/what-is-traffic-mirroring.html) for additional information.

**Note**: Amazon VPC Traffic Mirroring supports ENIs of instances running on top of the AWS Nitro System (e.g. t3, m5, c5 and r5 instances). You cannot mirror traffic from an ENI that is attached to a non-Nitro instance.

The repository contains the following components (or CloudFormation stacks):

* `vpc-mirroring-target-instance` - EC2 instance with Seekret's sniffer.
* `vpc-mirroring` - Amazon VPC Traffic Mirroring configuration.

## Prerequisites

The setup in this repository has the following requirements:

* AWS CLI with admin-level credentials (needs to be able to deploy IAM roles).

Also, the `Makefile` is optimized for deployments made on `us-east-1` region (but should work with other regions as well).

## Deployment

### Target Instance

Deploy the target instance stack by running

You'll need to provide parameter values for the next parameters

```
CustomerVpcId - VPC Id where your ALB resides
SourceVpcIpv4Cidr - VPC IPv4 CIDR
CustomerSubnetId - Subnet of the availability zone of the ALB
```

```bash
aws --profile default --region us-east-1 cloudformation deploy --stack-name seekret-sniffer \ 
--tags Deployment=seekret-target-sniffer --template-file templates/vpc-mirroring-target-instance.yaml --capabilities CAPABILITY_NAMED_IAM \ 
--parameter-overrides CustomerVpcId=<VPC_ID> SourceVpcIpv4Cidr=<VPC_Cidr> CustomerSubnetId=<Subnet_ID>
```

Once complete, you can use AWS Systems Manager Session Manager (SSM) to access the EC2 instance that receives the mirrored network traffic.

### VPC Mirroring

You'll need to provide parameter values for the next parameters

* Find the ID of the ENI you would like to monitor and enter it to the `Default` field of `SourceEni` parameter.
* Find the ID of the ENI of the target instance and enter it into the `Default` field of `TargetEni` parameter.

```
SourceEni - ID of the ENI you would like to monitor (ALB's eni)
TargetEni - ID of the ENI of the target instance (Seekret sniffer)
SourceVpcIpv4Cidr - VPC IPv4 CIDR
```

```bash
aws --profile default --region us-east-1 cloudformation deploy --stack-name seekret-vpc-mirroring \ 
--tags Deployment=seekret-vpc-traffic-mirroring --template-file templates/vpc-mirroring.yaml --capabilities CAPABILITY_NAMED_IAM \ 
--parameter-overrides SourceEni=<Source_Eni_ID> TargetEni=<Targer_Eni_ID> SourceVpcIpv4Cidr=<VPC_Cidr>
```

## Additional Features

### Mirror Filters for Application Load Balancers

Amazon VPC Traffic Mirroring can mirror traffic from ENIs of some Application Load Balancers (ALB). Amazon VPC Traffic Mirroring only supports instances that are built on the AWS Nitro System. You can mirror the traffic of an ALB if it uses a supported instance. ALBs are more likely to support mirroring on newer regions (like `eu-north-1`) that do not have non-Nitro based previous generation instances available. If the ALB is not using a supported instance, you cannot mirror its traffic.

For supported ALBs, the VPC Mirroring template includes two mirror filters to mirror a portion of the ALB network traffic:

* `MirrorAlbClientTraffic` - Mirrors all ingress and egress traffic between clients and the ALB. Traffic between the ALB and targets is not mirrored.
* `MirrorAlbTargetTraffic` - Mirrors all ingress and egress traffic between the ALB and its targets. Traffic between clients and the ALB is not mirrored.

**Note**: The filters work best with `internet-facing` ALBs. They do not capture traffic for `internal` ALBs correctly if the clients and the targets are in the same VPC. If you wish to use the filters for this scenario, you'll need to make the `DestinationCidrBlock` and `SourceCidrBlock` that refer the VPC CIDR to be more specific (i.e. to only match clients or targets in different subnets).

## Cleanup

Execute the following commands to clean up AWS resources:

```
make delete-vpc-mirroring-target-instance
make delete-vpc-mirroring
```

## Sources, References & Additional Material

* [AWS Documentation](https://docs.aws.amazon.com/vpc/latest/mirroring/what-is-traffic-mirroring.html), AWS
