#!/usr/bin/env bash
# Plain Argo CD install, the way most people start: one kubectl apply from the docs.
# Used in the ClickOps part of the workshop.
source "$(dirname "$0")/lib.sh"
require_cluster

info "Installing Argo CD ${ARGOCD_VERSION} with kubectl apply"
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argocd --server-side --force-conflicts \
  -f "https://raw.githubusercontent.com/argoproj/argo-cd/${ARGOCD_VERSION}/manifests/install.yaml"

# Serve the UI over plain HTTP so the Codespaces port forward works without TLS warnings.
kubectl -n argocd patch configmap argocd-cmd-params-cm --type merge -p '{"data":{"server.insecure":"true"}}'
kubectl -n argocd rollout restart deploy/argocd-server

wait_for_argocd
start_port_forward
cli_login
