#!/usr/bin/env bash
# (Re)starts the port forward to the Argo CD UI and logs in the CLI.
source "$(dirname "$0")/lib.sh"
require_cluster
start_port_forward
cli_login
