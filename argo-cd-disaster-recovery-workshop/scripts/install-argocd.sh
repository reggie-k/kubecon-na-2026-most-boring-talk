#!/usr/bin/env bash
# Plain Argo CD install with Helm and default settings, the way most people start.
# Used in the ClickOps part of the workshop.
source "$(dirname "$0")/lib.sh"
require_cluster

info "Installing Argo CD ${ARGOCD_VERSION} with Helm (chart ${ARGOCD_CHART_VERSION})"
helm_install_argocd -f "${ROOT_DIR}/scripts/clickops-values.yaml"

wait_for_argocd
wait_for_ui
cli_login
