#!/usr/bin/env bash
# Checks the Argo CD UI is reachable, logs in the CLI and prints the admin password.
source "$(dirname "$0")/lib.sh"
require_cluster
wait_for_ui
cli_login
