Seekret
=======
A Helm chart for Kubernetes

Current chart version is `0.3.2`

## License

[Apache 2.0](/helm/LICENSE.txt)

Copyright 2019, Tumblr, Inc.

## Pre-requisites

- kubectl
- Helm v3 configured

## Deployment
### HTTP traffic

1. Deploy helm chart 

```bash
 helm repo add seekret-repo 
 helm install seekret-sniffer seekret-repo/seekret --set s3.accessKey={ACCESS_KEY} --set s3.secretKey={SECRET_KEY} --set s3.bucketName={BUCKET_NAME}" --set bpfFilter="tcp port [PORT_NUMBER]"
```

2. Add annotations to your k8s environment:

`annotations: injector.seekret.com/request: sniffer`

Example:
```
apiVersion: apps/v1 # This is the K8S API version introduced in Kubernetes 1.9.0
kind: Deployment
metadata:
    name: test-deployment
spec:
  template:
    metadata:
      labels:
        app: test-deployment
      annotations:
        injector.seekret.com/request: sniffer
    spec:
      containers:
      - name: test
        image: test 
        imagePullPolicy: Never
```

### HTTPS traffic

1. Create a K8s secret with your private and public key in your application k8s environment:
`kubectl create secret generic seekret-tls-proxy-certs --from-file=<your-public-key-cert.pem> --from-file=<your-private-key.pem> --namespace <namespace_of_API_gateway_pod>`

_The key is mounted by the proxy container and is used only to decrypt and re-encrypt the traffic._

2. Deploy helm chart

```bash
 helm repo add seekret-repo 
 helm install seekret-sniffer seekret-repo/seekret --set s3.accessKey={ACCESS_KEY} --set s3.secretKey={SECRET_KEY} --set s3.bucketName={BUCKET_NAME}" --set bpfFilter="tcp port 9080" --set tlsProxy.enabled=true --set tlsProxy.targetPort=443 
```

3. Add annotations to your k8s environment:

`annotations: injector.seekret.com/request: sniffer`

Example:
```
apiVersion: apps/v1 # This is the K8S API version introduced in Kubernetes 1.9.0
kind: Deployment
metadata:
    name: test-deployment
spec:
  template:
    metadata:
      labels:
        app: test-deployment
      annotations:
        injector.seekret.com/request: sniffer
    spec:
      containers:
      - name: test
        image: test 
        imagePullPolicy: Never
```

## Additional Optional Values

Those values can be configured during installation using ``` --set [ParamName]=[VALUE] (e.g: --set s3.folderName=test/capture) ```

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| name | string | `"seekret-sidecar-injector"` | App name |
| injector.annotationNamespace | string | `"injector.seekret.com"` | The annotation namespace |
| injector.imageName | string | `"tumblr/k8s-sidecar-injector:latest"` | The image of the injector |
| maxFileSize | int | `100` | Maximum pcap file size in MBs |
| rotationSeconds | int | `1200` | Number of seconds between file rotations |
| bpfFilter | string | `"tcp and not tcp port 443"` | The bpf filter for the sniffer |
| s3.bucketName | string | `` | Bucket name for pcaps |
| s3.folderName | string | `"default/captures"` | Folder for pcaps inside bucket |
| s3.keyAuth | bool | `true` | if true, using HMAC key authentication, otherwise AWS role-based IAM access assumed |
| s3.accessKey | string | `` | Access key for sniffer |
| s3.secretKey | string | `` | Secret key for sniffer |
| s3.s3_url | string | `"https://storage.googleapis.com"` | endpoint_url to allow accessing different buckets |
| s3.region | string | `"us-east1"` | Default region of the target bucket |
| httpProxyClient.enabled | bool | `false` | Whether to deploy Seekret's HTTP Proxy |
| httpProxyClient.image | string | `"seekret/http-proxy-client:1"` | Docker image of the HTTP Proxy client |
| httpProxyClient.target | string | `nil` | Target URL for the proxy. The value must include a schema ("http://") |
| httpProxyClient.pullIntervalInSeconds | float | `10` | Seconds between each requests batch |
| httpProxyClient.gcs.projectName | string | `nil` | Name of the GCP project where the requests are stored |
| httpProxyClient.gcs.bucketName | string | `nil` | Name of the GCS bucket where the requests are stored |
| httpProxyClient.credsFile | string | `"/seekret/gcscreds.json"` | Path in which to store the GCS credentials file |
| gcsCredentials.name | string | `"seekret-gcscreds"` | Name of the secret with the GCS credentials |
| gcsCredentials.creds | string | `nil` | The content of the GCS credentials file |
| tlsProxy.enabled | bool | `false` | Whether the TLS proxy is enabled on the target pod |
| tlsProxy.adminPort | int | `9901` | The port for Envoy's admin interface |
| tlsProxy.certsSecretName | string | `"seekret-tls-proxy-certs"` | Name of the secret value with the certificates |
| tlsProxy.envoyImage | string | `"seekret/envoy-https-proxy:1"` | Image to use for the envoy pod |
| tlsProxy.initImage | string | `"seekret/https-proxy-init:1"` | Image to use for the init container |
| tlsProxy.targetAddress | string | `"localhost"` | Target address of the TLS proxy |
| tlsProxy.targetPort | int | `443` | Target port of the TLS proxy |
