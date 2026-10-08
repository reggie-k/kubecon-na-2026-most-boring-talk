# Lab 5: Wrap-up

## What you saw

| | ClickOps | GitOps |
| --- | --- | --- |
| Source of truth | The cluster's etcd | Git |
| Recovery runbook | "Remember everything" | `kubectl apply -k` + `kubectl apply -f` |
| Audit trail | None | `git log` |
| Drift from manual changes | Silent and permanent | Reverted by self-heal |
| Recovery time | Depends on how much you remember | Minutes |

## What Git does not save you from

GitOps recovers your *desired state*. Plan for these separately:

- **Secrets.** Repository credentials, cluster credentials, SSO client secrets and the admin password are not in Git, and they should not be in plain text there. Use a tool such as External Secrets Operator or Sealed Secrets, so secrets are either pulled from a secret manager or stored encrypted in Git.
- **External clusters.** If Argo CD deploys to other clusters, their connection secrets must be recreated too. Declare them as secrets managed by the same tooling.
- **Application data.** Argo CD recreates Deployments, not the data in your PersistentVolumes or databases. Use a backup tool such as Velero, or your database's own backups.
- **Imperative leftovers.** Anything created outside Git, such as a quick `kubectl apply` from a laptop, is lost. Self-heal and pruning help you find these early.
- **The bootstrap itself.** Keep the two bootstrap commands in a runbook, and test them regularly by doing what you did today.

## Good practices

- Manage Argo CD with Argo CD (`gitops/apps/argocd.yaml`), so upgrades and settings changes go through pull requests.
- Pin the Argo CD version in Git, as `gitops/argocd/kustomization.yaml` does.
- Use `argocd admin export` as an extra backup, not as your recovery plan.
- Do not add a cascading-delete finalizer to the root app. Deleting it by mistake would then delete every app it manages.
- Rehearse disaster recovery: a game day like this one is the only way to know the runbook works.

## Clean up

```bash
make reset
```

Then stop or delete your Codespace from <https://github.com/codespaces>.
