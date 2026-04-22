#  Terraform Infrastructure & gitops  Pipeline for node app

This repository provides a **modular Terraform setup** for provisioning infrastructure along with a **CI pipeline** for automation, validation, and deployment.

---

## 📌 Overview

The project is designed to:

* Provision infrastructure using **Terraform modules**
* Follow **Infrastructure as Code (IaC)** best practices
* Automate workflows using **CI/CD pipelines (git ops)**
* Monitoring with new relic

---

## 🏗️ Terraform Module Structure

The repository follows a **modular architecture**, making it reusable, scalable, and maintainable.

### 📂 Project Structure

```
.
├── modules/
│   ├── network/
│   ├── gke/

│
├── .github/workflows/
│   └── ci.yml
│
└── README.md
```

---

## 🔧 Terraform Modules

Each module is self-contained and includes:

* `main.tf` → Core resources
* `variables.tf` → Input variables
* `outputs.tf` → Outputs for reuse\

  How to Use

  ### 1. Initialize Terraform

  ```
  terraform init
  ```

  ### 2. Validate Configuration

  ```
  terraform validate
  ```

  ### 3. Plan Deployment

  ```
  terraform plan
  ```

  ### 4. Apply Changes

  ```
  terraform apply
  ```

  ##

---

## ⚙️ CI Pipeline (GitHub Actions)

This repository uses a **Docker-based CI pipeline** that builds, scans (lint), pushes images, and updates the GitOps repo used by ArgoCD.

### 📌 Pipeline Features

* Checkout source code
* Generate short commit SHA for tagging
* Run **ESLint** for code quality
* Build Docker image using Buildx
* Push image to Docker Hub (latest + versioned tag)
* Update ArgoCD repository with new image tag (GitOps flow)

---

## 🔄 CI Workflow

```yaml
name: Docker CI

on:
  push:
    branches: [ "main", "master" ]

jobs:
  build-and-push:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      # Generate short SHA
      - name: Extract metadata
        id: meta
        run: echo "SHORT_SHA=${GITHUB_SHA::7}" >> $GITHUB_OUTPUT

      # Linting
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 18

      - name: Install dependencies
        run: npm install

      - name: Run ESLint
        run: npm run lint

      # Docker login
      - name: Login to Docker Hub
        uses: docker/login-action@v4
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      # Buildx
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v4

      # Build & Push
      - name: Build and Push Docker Image
        uses: docker/build-push-action@v7
        with:
          context: .
          push: true
          tags: |
            ${{ secrets.DOCKER_USERNAME }}/node-hello:latest
            ${{ secrets.DOCKER_USERNAME }}/node-hello:${{ steps.meta.outputs.SHORT_SHA }}

      # Update ArgoCD repo
      - name: Update ArgoCD repo with new image tag
        run: |
          SHORT_SHA=${{ steps.meta.outputs.SHORT_SHA }}

          git config --global user.name "github-actions"
          git config --global user.email "actions@github.com"

          git clone https://x-access-token:${{ secrets.ARGOCD_REPO_TOKEN }}@github.com/M-Samii/node-hello-argocd.git
          cd node-hello-argocd

          sed -i "s|image: .*|image: ${{ secrets.DOCKER_USERNAME }}/node-hello:${SHORT_SHA}|g" k8s/deployment.yaml

          git add k8s/deployment.yaml
          git commit -m "Update image tag to ${SHORT_SHA}" || echo "No changes"
          git push
```

---

### 🧠 What This CI Does

This pipeline implements a **full CI + GitOps workflow**:

1. **Code Quality Check**
   Runs ESLint to ensure clean and consistent code before building.

2. **Docker Build & Versioning**
   Builds the application image and tags it with:

   * `latest`
   * short commit SHA (e.g., `a1b2c3d`)

3. **Push to Docker Hub**
   Publishes the image so it can be pulled by Kubernetes.

4. **GitOps Update (ArgoCD)**

   * Clones the ArgoCD repo
   * Updates the Kubernetes deployment image tag
   * Pushes the change

5. **Automatic Deployment via ArgoCD**
   ArgoCD detects the repo change and **syncs the new version to the cluster automatically**.

👉 Result: Every push to `main` triggers a full build → push → deploy cycle.

##

##

```bash
 GitOps with ArgoCD (Required Before New Relic)
```

Deploy **ArgoCD** to manage applications in a GitOps workflow before installing New Relic.

### ⚙️ Install ArgoCD via Helm

```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

kubectl create namespace argocd

helm install argocd argo/argo-cd -n argocd
```

### 📦 Deploy Your Application via ArgoCD

```bash
kubectl apply -f application.yaml
```

> Ensure your `application.yaml` points to the correct repo, path, and destination cluster/namespace.

---

## 📊 Monitoring with New Relic

This project supports integrating **New Relic** for application and infrastructure monitoring.

### 🔑 Prerequisites

* New Relic account
* New Relic License Key

---

### ⚙️ Add New Relic to Your Infrastructure

#### 1. Store License Key as Secret

Add your New Relic license key to:

* **GitHub Secrets** (for CI/CD)

  * github tokrn for argo
  * Dockerhub token

---

#### 2. Install New Relic Agent (Example: Node.js App)

```bash
npm install newrelic
```

Create a `newrelic.js` file:

```js
exports.config = {
  app_name: ['my-app'],
  license_key: process.env.NEW_RELIC_LICENSE_KEY,
  logging: {
    level: 'info'
  }
}
```

Then require it at the top of your app:

```js
require('newrelic');
```

---

#### 3. Kubernetes / GKE Integration

You can deploy New Relic using Helm:

```bash
helm repo add newrelic https://helm-charts.newrelic.com
helm repo update
```

##### 🔹 Using values.yaml (Recommended)

Create a `values.yaml` file:

```yaml
global:
  licenseKey: YOUR_NEW_RELIC_LICENSE_KEY
  cluster: your-cluster-name

kubeEvents:
  enabled: true

logging:
  enabled: true
```

Then deploy using:

```bash
helm upgrade --install newrelic-bundle newrelic/nri-bundle \
  -f values.yaml
```

This approach allows better configuration management and version control compared to inline `--set` flags.

##### 🔹 Quick Install (Inline)

````bash
helm install newrelic-bundle newrelic/nri-bundle \
  --set global.licenseKey=$NEW_RELIC_LICENSE_KEY \
  --set global.cluster=your-cluster-name
```bash
helm repo add newrelic https://helm-charts.newrelic.com
helm repo update

helm install newrelic-bundle newrelic/nri-bundle \
  --set global.licenseKey=$NEW_RELIC_LICENSE_KEY \
  --set global.cluster=your-cluster-name
````

---

#### 4. Terraform Integration (Optional)

You can manage New Relic resources using Terraform:

```hcl
provider "newrelic" {
  account_id = var.newrelic_account_id
  api_key    = var.newrelic_api_key
  region     = "US"
}
```

Example: Create alert policy

```hcl
resource "newrelic_alert_policy" "example" {
  name = "High CPU Usage"
}
```

---

### 📈 What You Get

* Application performance monitoring (APM)
* Infrastructure metrics (CPU, memory, network)
* Logs and distributed tracing
*

---

## 💡 Summary

This repository demonstrates:

* Clean Terraform module design
* Scalable infrastructure setup
* Automated CI pipeline for reliability and consistency

---

