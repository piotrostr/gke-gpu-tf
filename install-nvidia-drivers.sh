#!/bin/bash

kubectl apply \
  -f https://raw.githubusercontent.com/GoogleCloudPlatform/container-engine-accelerators/master/cmd/nvidia_gpu/device-plugin.yaml

# The command below is only needed in case of using MIG GPU-partitioning
kubectl apply \
  -f https://raw.githubusercontent.com/GoogleCloudPlatform/container-engine-accelerators/master/nvidia-driver-installer/cos/daemonset-nvidia-mig.yaml
