#!/bin/bash
gcloud compute instances create reddit-full-test\
  --image-family reddit-full \
  --machine-type=g1-small \
  --zone=europe-west1-d
