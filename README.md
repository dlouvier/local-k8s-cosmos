# Local Kubernetes Cluster for Cosmos SDK

This repository provides basic examples for provisioning a local Kubernetes K3s cluster using Docker and K3d.

The cluster includes Cosmos SDK, which is initialized locally with a local test net that can be queried via the SDK.

It is designed to run easily in a [CI pipeline](.github/workflows/job.yml), as the cluster takes less than a minute to start, demonstrating how it can be provisioned simply and effectively.

## Requirements

- **Docker**
- **K3d**

  Install with the following command

  ```bash
  wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
  ```

- **kubectl** (Client version > v1.29.6)
- **grpcurl** (Needed to run `make test`)

## Requirements

- Docker
- K3D

  `wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash`

  [Installation steps](https://k3d.io/v5.6.3/#releases)

- Kubectl (client version > v1.29.6)
- grpcurl (to be able to run `make test`)

## Steps

1. Provision the Cluster

   This command will create the cluster and install Cosmos SDK, Prometheus, and Grafana using a manifest file.

   ```bash
   make provision
   ```

1. Run Tests

   After a few minutes, execute:

   ```bash
   make test
   ```

   This will perform a simple test that runs gRPC requests to the Cosmos SDK.

1. Access to Grafana

   To get the Grafana URL and credentials, use:
   ```bash
   make grafana
   ```

1. Clean Up
   To delete the cluster and local Docker containers, run:

   ```bash
   make clean
   ```

## Possible improvements

### Cosmos SDK

I did not find any Helm chart for the Cosmos SDK. Developing one could be a valuable contribution to the community.

### Expose gRPC via Ingress:

I encountered issues with gRPC and the K3d Load Balancer and Ingress (Traefik). It seems to support only secured gRPC and not plain text. For simplicity, I used port-forwarding for the test. Further investigation is needed to expose gRPC over Ingress properly.
