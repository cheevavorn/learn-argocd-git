#!/bin/bash
set -e

echo "=== ติดตั้ง ArgoCD ==="

# สร้าง namespace
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -

# ติดตั้ง ArgoCD จาก official manifest
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo ""
echo "=== รอ ArgoCD pods พร้อม ==="
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd

echo ""
echo "=== ดึง initial admin password ==="
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d && echo ""

echo ""
echo "=== เปิด port-forward ใน terminal อื่น ==="
echo "kubectl port-forward svc/argocd-server -n argocd 8080:443"
echo "แล้วเปิด https://localhost:8080  (admin / password ด้านบน)"
