Seekret
=======
A Helm chart for Kubernetes

Current chart version is `1.0.5`

## License

[Apache 2.0](/helm/LICENSE.txt)

Copyright 2019, Tumblr, Inc.

## Pre-requisites

- kubectl
- Helm v3 configured 
- ACCESS_KEY, SECRET_KEY and BUCKET_NAME (supported buckets: GCS / S3 / Azure Blob)

## Deployment

### Deploy helm chart 

---
**NOTE**

Currently, the deployment is not supported to a **custom** namespace. For a workaround please contact us.

---

#### HTTP traffic
```bash
 helm repo add seekret-repo https://helm.seekret.io
 helm repo update
 helm install seekret-sniffer seekret-repo/seekret --set bucket.provider={PROVIDER} --set bucket.accessKey={ACCESS_KEY} --set bucket.secretKey={SECRET_KEY} --set bucket.name={BUCKET_NAME} --set bpfFilter="tcp port [PORT_NUMBER]" --set bucket.workspace={WORKSPACE}
```

#### HTTPS traffic
a. Create a K8s secret with your private and public key in your application k8s environment:

`kubectl create secret tls seekret-tls-proxy-certs --cert=<your-public-key-cert.crt> --key=<your-private-key.key> --namespace <namespace_of_API_gateway_pod>`
   
_The key is mounted by the proxy container and is used only to decrypt and re-encrypt the traffic._

b. 
```bash
 helm repo add seekret-repo https://helm.seekret.io
 helm repo update
 helm install seekret-sniffer seekret-repo/seekret --set bucket.provider={PROVIDER} --set bucket.accessKey={ACCESS_KEY} --set bucket.secretKey={SECRET_KEY} --set bucket.name={BUCKET_NAME} --set tlsProxy.enabled=true --set tlsProxy.targetPort={PORT_NUMBER} --set bucket.workspace={WORKSPACE}
```
_Usually the tlsProxy.targetPort should be 443_

### Add annotations to your k8s environment:

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

### Additional Optional Values

Those values can be configured during installation using ``` --set [ParamName]=[VALUE] (e.g: --set bucket.workspace=test) ```

#### Honorable mentions

- Adjust maxFileSize and rotationSeconds parameters if you deploy in an environment with a heavy traffic
- By default, underlying service name is extracted from pod's description via its `app` label. You can use a different label by changing the value of `serviceMarkerLabel` parameter 

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| name | string | `"seekret-sidecar-injector"` | App name |
| injector.annotationNamespace | string | `"injector.seekret.com"` | The annotation namespace |
| injector.imageName | string | `"tumblr/k8s-sidecar-injector:latest"` | The image of the injector |
| maxFileSize | int | `10` | Maximum pcap file size in MBs |
| rotationSeconds | int | `60` | Number of seconds between file rotations |
| serviceMarkerLabel | string | `app` | Kubernetes pod's metadata label for underlying service retrieval|
| bpfFilter | string | `"tcp and not tcp port 443"` | The bpf filter for the sniffer |
| networkPolicy.enabled | bool | `false` | Whether to add a network policy |
| bucket.name | string | `` | Bucket name for pcaps |
| bucket.workspace | string | `"default"` | The workspace in the Seekret app to send requests too. Must be an existing workspace |
| bucket.accessKey | string | `` | Access key for sniffer |
| bucket.secretKey | string | `` | Secret key for sniffer |
| bucket.provider | string | `gcs` | one of `gcs`, `s3`, `azure` |
| tlsProxy.enabled | bool | `false` | Whether the TLS proxy is enabled on the target pod |
| tlsProxy.adminPort | int | `9901` | The port for Envoy's admin interface |
| tlsProxy.certsSecretName | string | `"seekret-tls-proxy-certs"` | Name of the secret value with the certificates |
| tlsProxy.envoyImage | string | `"gcr.io/seekret/envoy-https-proxy:1"` | Image to use for the envoy pod |
| tlsProxy.initImage | string | `"gcr.io/seekret/https-proxy-init:1"` | Image to use for the init container |
| tlsProxy.targetAddress | string | `"localhost"` | Target address of the TLS proxy |
| tlsProxy.targetPort | int | `443` | Target port of the TLS proxy |
| tlsProxy.requestTimeout | string | `15s` | The timeout for a single request |
