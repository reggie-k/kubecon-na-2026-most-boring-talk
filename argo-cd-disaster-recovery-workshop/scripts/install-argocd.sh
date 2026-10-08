#!/usr/bin/env bash
# Plain Argo CD install with Helm and default settings, the way most people start.
# Used in the ClickOps part of the workshop.
source "$(dirname "$0")/lib.sh"
require_cluster

info "Installing Argo CD ${ARGOCD_VERSION} with Helm (chart ${ARGOCD_CHART_VERSION})"
# Serve the UI over plain HTTP so port forwarding works without TLS warnings.
helm_install_argocd --set 'configs.params.server\.insecure=true'

wait_for_argocd
start_port_forward
cli_login
