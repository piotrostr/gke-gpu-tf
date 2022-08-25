#!/bin/bash

gcloud container clusters create tesla-t4-cluster \
  --accelerator type=nvidia-tesla-t4,count=1 \
  --zone us-central1-a \
  --machine-type n1-standard-4

gcloud container clusters get-credentials tesla-t4-cluster \
  --zone us-central1-a

kubectl apply \
  -f https://raw.githubusercontent.com/GoogleCloudPlatform/container-engine-accelerators/master/nvidia-driver-installer/cos/daemonset-preloaded-latest.yaml

kubectl apply -f gpu-consuming-pod.yaml

