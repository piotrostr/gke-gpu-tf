# gke-tf

## Disclaimer

This is not production software and it is not affiliated with Google. I wrote
it for educational purposes, not as part of my employment.

## Setup

Setup requires terraform with Google Cloud credentials. This cluster runs GPUs
and exceeds the primary GCP quotas so the example won't work for new accounts.

The `api/` directory contains two sample APIs of which images have been built
and made public. The only command thing required to start the provision all of
the resources and populate the cluster is

```sh
terraform apply
```

(to skip the "type yes to agree" part, include `--auto-approve` flag)

During the provisioning, after **the cluster and GPU node pool** are created,
get the credentials using

```sh
gcloud container clusters get-credentials cluster \
  --region=us-central1-a
```

Having authenticated into `kubectl`, the nvidia-drivers need to be installed.
This can be done using the utility script from the root of the repo:

```sh
./install-nvidia-drivers.sh
```

Note that this step has to be completed during the provisioning, as otherwise
the node will not have any available GPUs and the pods won't get scheduled,
thus leaving the deployment of `gpu_api` stuck in the state as below.

```log
kubernetes_deployment.gpu_api: Still creating... [XXmXXs elapsed]
```

As soon as the drivers are installed the pods get scheduled.

In order to verify the GPUs are available:

```sh
kubectl describe nodes | grep nvidia.com/gpu
```

should return the number of requests/limits for GPU units.

The entire provisioning might take about 5-10 minutes as the resources involve
an autopilot GKE cluster, NVIDIA A100 GPU node-pool and a HTTP Global Load
Balancer. Terraform creates everything in sync, so the creation can be lengthy
at times.

## License

MIT
