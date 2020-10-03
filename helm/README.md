seekret
=======
A Helm chart for Kubernetes

Current chart version is `0.3.0`

## Installation

Install this chart using:

```bash
 cd helm/seekret
 helm dependency update
 helm install seekret --namespace seekret --create-namespace .
```

The [configuration](#Chart Values) section lists the parameters that can be configured during installation.
To enable the sniffer on a deployment, add the following annotation:
injector.seekret.com/request: sniffer

## Chart Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| name | string | `"seekret-sidecar-injector"` | App name |
| injector.annotationNamespace | string | `"injector.seekret.com"` | The annotation namespace |
| injector.imageName | string | `"tumblr/k8s-sidecar-injector:latest"` | The image of the injector |
| maxFileSize | int | `100` | Maximum pcap file size in MBs |
| maxFiles | int | `1` | Maximum pcap files to store locally before moving to bucket |
| rotationSeconds | int | `1800` | Number of seconds between file rotations |
| bpfFilter | string | `"not tcp port 9000"` | The filter for the injected pod |
| s3.bucketName | string | `"seekret"` | Bucket name for pcaps |
| s3.folderName | string | `"pcaps"` | Folder for pcaps inside bucket |
| s3.accessKey | string | `"seekret"` | Access key for sniffer |
| s3.secretKey | string | `"seekret123"` | Secret key for sniffer |
| s3.s3_url | string | `"https://storage.googleapis.com"` | endpoint_url to allow accessing different buckets |
| s3.region | string | `"us-central1"` | Default region of the target bucket |
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
