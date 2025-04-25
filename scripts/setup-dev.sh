#!/bin/bash

set -e

echo "🔧 Verificando herramientas necesarias..."

# Check for kubectl
if ! command -v kubectl &> /dev/null; then
  echo "📦 Instalando kubectl..."
  curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  chmod +x kubectl
  sudo mv kubectl /usr/local/bin/
else
  echo "✅ kubectl ya está instalado"
fi

# Check for k3d
if ! command -v k3d &> /dev/null; then
  echo "📦 Instalando k3d..."
  curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
else
  echo "✅ k3d ya está instalado"
fi

# Check for kustomize
if ! command -v kustomize &> /dev/null; then
  echo "📦 Instalando kustomize..."
  curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash
  sudo mv kustomize /usr/local/bin/
else
  echo "✅ kustomize ya está instalado"
fi

# Create k3d cluster
if ! k3d cluster list | grep -q kube-argo-cluster; then
  echo "🚀 Creando cluster k3d..."
  k3d cluster create kube-argo-cluster \
    --registry-create k3d-localhost:5000 \
    -p "8081:80@loadbalancer" \
    --wait
else
  echo "✅ Cluster k3d ya existe"
fi

# Start registry
echo "📦 Levantando el registry local..."
docker compose up -d registry

echo "✅ Setup completo. Ejecutá ahora:"
echo "   ./scripts/simulate-pipeline.sh"
