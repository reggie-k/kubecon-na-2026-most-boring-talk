# Lab 1: Life with ClickOps

You will set up Argo CD the way many teams start: install it from the docs, then click and type.

## 1. Create a cluster and install Argo CD

```bash
make cluster NAME=primary
make install-argocd
```

The second command prints the admin password and logs the `argocd` CLI in. Open the **PORTS** tab in VS Code and open the forwarded address for port **8080**. Log in as `admin`.

> [!TIP]
> If the UI stops responding, run `make ui` to restart the port forward.

## 2. Create an app in the UI

1. Select **+ New App**.
2. Fill in:

   | Field | Value |
   | --- | --- |
   | Application Name | `guestbook` |
   | Project Name | `default` |
   | Sync Policy | `Automatic` |
   | Auto-Create Namespace | checked |
   | Repository URL | `https://github.com/argoproj/argocd-example-apps.git` |
   | Revision | `HEAD` |
   | Path | `guestbook` |
   | Cluster URL | `https://kubernetes.default.svc` |
   | Namespace | `guestbook` |

3. Select **Create**, then watch the app become **Synced** and **Healthy**.

## 3. Create two apps with the CLI

Create a Helm app with manual sync, then sync it by hand:

```bash
argocd app create helm-guestbook \
  --repo https://github.com/argoproj/argocd-example-apps.git \
  --path helm-guestbook \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace helm-guestbook \
  --sync-option CreateNamespace=true

argocd app sync helm-guestbook
```

Create a Kustomize app with automatic sync:

```bash
argocd app create kustomize-guestbook \
  --repo https://github.com/argoproj/argocd-example-apps.git \
  --path kustomize-guestbook \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace kustomize-guestbook \
  --sync-option CreateNamespace=true \
  --sync-policy automated
```

Check your three apps:

```bash
argocd app list
argocd app get helm-guestbook
kubectl get deploy -A | grep guestbook
```

## 4. Look around

Explore your apps in the UI for a few minutes. Open each one and look at its details, sync policy and resources.

Then ask yourself: where is the definition of these three apps stored? Only in this cluster.

Next: [Lab 2: Disaster #1](02-clickops-disaster.md)
