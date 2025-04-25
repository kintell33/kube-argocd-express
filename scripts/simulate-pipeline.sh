#!/bin/bash

set -e

APP_NAME="kube-argo-express"
IMAGE="localhost:5000/${APP_NAME}:latest"

echo "🛠️  1. Build Docker image..."
docker build -t $IMAGE ./src

echo "📦  2. Push image to local registry..."
docker push $IMAGE

echo "🧩  3. Apply Kustomize overlay (local)..."
kubectl apply -k k8s/overlays/local

echo "✅  Done. Check with:"
echo "    kubectl get pods"
echo "    kubectl get svc"
