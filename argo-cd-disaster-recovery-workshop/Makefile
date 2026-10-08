# Workshop shortcuts. Run `make help` to list them.
NAME ?= primary

.PHONY: help configure cluster install-argocd ui disaster bootstrap status reset

help: ## List targets
	@grep -E '^[a-z-]+:.*##' $(MAKEFILE_LIST) | awk -F':.*## ' '{printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2}'

configure: ## Point gitops/ at your fork, commit and push
	@scripts/configure-repo.sh

cluster: ## Create a kind cluster (NAME=primary|dr)
	@scripts/cluster.sh $(NAME)

install-argocd: ## ClickOps: install a plain Argo CD with kubectl
	@scripts/install-argocd.sh

ui: ## Show the UI address and admin password, and log in the CLI
	@scripts/ui.sh

disaster: ## Destroy a cluster (NAME=primary|dr)
	@scripts/disaster.sh $(NAME)

bootstrap: ## GitOps: install Argo CD and the root app from Git
	@scripts/bootstrap.sh

status: ## Show clusters and what Argo CD manages
	@scripts/status.sh

reset: ## Delete all workshop clusters
	@scripts/reset.sh
