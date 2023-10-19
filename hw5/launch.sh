#!/bin/zsh

# Create namespace
kubectl apply -f manifest/00-namespace.yaml

# Deploy application
helm install otus-hw5 ./simple-app/.helm -n otus-hw5-ns

# Initialize istio
kubectl apply -f istio/ -n otus-hw5-ns