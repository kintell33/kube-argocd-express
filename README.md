# kube-argo-express

Mini proyecto de ejemplo usando **Express.js**, **Kubernetes**, **ArgoCD** y **Kustomize** para desplegar una aplicación de manera automatizada siguiendo prácticas de GitOps.

---

## 🔧 Requisitos

Antes de empezar, asegurate de tener las siguientes herramientas instaladas:

### 🐳 Docker

Motor de contenedores para build y run de imágenes localmente.

- [Instalar Docker](https://docs.docker.com/get-docker/)

### 🐙 Docker Compose

Orquestador de servicios en Docker mediante archivos `docker-compose.yml`.

- Generalmente viene incluido con Docker Desktop.

### ☸️ kubectl

Cliente de línea de comandos para interactuar con Kubernetes clusters.

- **Instalación:**

  ```bash
  curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  chmod +x kubectl
  sudo mv kubectl /usr/local/bin/
  ```

- **Test:**

  ```bash
  kubectl version --client
  kubectl get nodes
  ```

### 🛠️ Kustomize

Herramienta para gestionar configuraciones de Kubernetes de forma declarativa y flexible.

- **Instalación:**

  ```bash
  curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash
  sudo mv kustomize /usr/local/bin
  ```

- **Test:**

  ```bash
  kustomize version
  ```

### 🌐 k3d

Herramienta para correr clusters de Kubernetes (K3s) dentro de Docker de forma liviana y rápida.

- **Instalación:**

  ```bash
  curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
  k3d version
  ```

- **Test:**

  ```bash
  k3d cluster create test
  kubectl get nodes
  k3d cluster delete test
  ```

---

## 🚀 ¿Cómo levantar todo localmente?

### 1. Levantar el registry local:

```bash
docker-compose up -d registry
```

---

### 2. Buildear la imagen de la app:

```bash
npm run docker:build
```

---

### 3. Taggear y pushear la imagen:

```bash
npm run docker:tag
npm run docker:push
```

---

### 4. Iniciar el cluster de Kubernetes (k3d):

```bash
npm run k3d:cluster:delete
npm run k3d:cluster:up
```

---

### 5. Aplicar manifiestos con Kustomize:

```bash
kubectl apply -k k8s/overlays/local
```

---

### 6. Validar que los pods estén corriendo:

```bash
kubectl get pods
kubectl describe pod kube-argo-express-xxxxxxx
```

> ✅ El status debe ser `Running`.  
> ❗ Si el pod no está corriendo, revisar eventos:

```bash
kubectl get events --sort-by=.metadata.creationTimestamp
```

---

### 7. Forwardear puertos para acceder localmente:

```bash
kubectl port-forward svc/kube-argo-express 8080:8080
```

---

### 8. Instalar ArgoCD en el cluster:

Crear el namespace:

```bash
kubectl create namespace argocd
```

Aplicar el manifiesto de instalación:

```bash
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Validar instalación:

```bash
kubectl get pods -n argocd -w
```

---

### 9. Acceder al dashboard de ArgoCD:

Forwardear ArgoCD server:

```bash
kubectl port-forward svc/argocd-server -n argocd 8083:443
```

Acceder a: [https://localhost:8083/](https://localhost:8083/)

---

### 10. Login en ArgoCD:

Usuario: `admin`  
Password:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

---

### 11. Aplicar configuración para manejar CD desde ArgoCD:

```bash
kubectl apply -f application.yaml -n argocd
```

> ⚡ **Importante:** El `application.yaml` debe apuntar correctamente al repo GitHub y al path de manifiestos (`k8s/overlays/local`).  
> Si cambias el branch o el path, actualizalo.

---

### 12. Limpieza de recursos creados (opcional):

Borrar la aplicación de ArgoCD:

```bash
kubectl delete application kube-argo-express -n argocd
```

Borrar el cluster de k3d:

```bash
k3d cluster delete argo-local
```
