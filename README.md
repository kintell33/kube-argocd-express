# kube-argo-express

Mini proyecto Express + ArgoCD + Kustomize + Kubernetes local

---

## 🔧 Requisitos

### Docker

### Docker Compose

### kubectl

- Install

```
curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
```

- Test

```
kubectl version --client
kubectl get nodes
```

### Kustomize (`brew install kustomize` o `choco install kustomize`)

- Install

```
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash
sudo mv kustomize /usr/local/bin
```

- Test

```
kustomize version
```

### k3d

- Install

```
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
k3d version
```

- Test

```
k3d cluster create test
kubectl get nodes
k3d cluster delete test
```

## 🚀 ¿Cómo levantar todo localmente?

1. Levantá el registry local y la app:

   ```bash
   docker-compose up -d registry
   ```

2. Buildear la imagen de la app

```
npm run docker:build
```

3. Tagear y pushear la imagen de la app

```
npm run docker:tag
npm run docker:push
```

4. Iniciar el cluster

```
npm run k3d:cluster:delete
npm run k3d:cluster:up
```

5. Aplicart manifiestos con kustomize

```
kubectl apply -k k8s/overlays/local
```

6. Validar pods
```
kubectl get pods
kubectl describe pod kube-argo-express-xxxxxxx
```

> El status tiene que ser running y no pending

7. Forward ports
```
kubectl port-forward svc/kube-argo-express 8080:8080
```

> Si el pod no esta corriendo, validar de la siguiente manera

Obtener eventos
```
kubectl get events --sort-by=.metadata.creationTimestamp
```