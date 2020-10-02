seekret
=======
A Helm chart for Kubernetes

Current chart version is `0.2.0`

## Installation

Install this chart using:

```bash
 cd helm/seekret
 helm dependency update
 helm install seekret --namespace seekret --create-namespace .
```

The command deploys MinIO on the Kubernetes cluster in the default configuration. The [configuration](#Chart Values) section lists the parameters that can be configured during installation.
To enable the sniffer on a deployment, add the following annotation:
injector.seekret.com/request: sniffer

## Chart Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://minio.github.io/charts | minio | 5.0.32 |

## Chart Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| name | string | `"seekret-sidecar-injector"` | App name |
| injector.annotaionNamespace | string | `"injector.seekret.com"` | The annotation namespace |
| injector.imageName | string | `"tumblr/k8s-sidecar-injector:latest"` | The image of the injector |
| maxFileSize | int | `100` | Maximum pcap file size in MBs |
| rotationSeconds | int | `1800` | Number of seconds between file rotations |
| bpfFilter | string | `"not tcp port 9000"` | The filter for the injected pod |
| s3.folderName | string | `"pcaps"` | Folder for dumps inside bucket |
| minio.replicas| int | `2` | Number of minio replicas |
| minio.accessKey | string | `"seekret"` | Access key for minio |
| minio.secretKey | string | `"seekret123"` | Sekret key for minio |
| minio.gcsgateway.enabled | bool | `true` |  Whether minio should be a proxy to GCS s3 |
| minio.gcsgateway.gcsKeyJson | string | `nil` | The json credentials for the GCS bucket |
| minio.gcsgateway.projectId | string | `nil` | The projectId of the GCS bucket |
| minio.persistence.size | string | `"10Gi"` | Minio storage size |
| minio.resources.requests.memory | string | `"2Gi"` | Minio requested memory |
| minio.s3gateway.accessKey | string | `""` | Access key for remote AWS s3 |
| minio.s3gateway.enabled | bool | `false` | Whether minio should be a proxy to another AWS s3 |
| minio.s3gateway.replicas | int | `2` | Number of replicas for gateway |
| minio.s3gateway.secretKey | string | `""` | Secret key for remote AWS s3  |
| minio.s3gateway.serviceEndpoint | string | `""` | Remote endpoint for AWS s3 gateway |
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
