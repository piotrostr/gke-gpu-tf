#!/bin/bash

# Note: this command will create a new nvidia-tesla-t4 per each node
gcloud container clusters create tesla-t4-cluster \
  --accelerator type=nvidia-tesla-t4,count=1 \
  --autoprovisioning-scopes=https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring,https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/compute \
  --zone us-central1-a \
  --machine-type n1-standard-4

gcloud container clusters get-credentials tesla-t4-cluster \
  --zone us-central1-a

kubectl apply \
  -f https://raw.githubusercontent.com/GoogleCloudPlatform/container-engine-accelerators/master/nvidia-driver-installer/cos/daemonset-preloaded-latest.yaml

kubectl apply -f gpu-consuming-pod.yaml
