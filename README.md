# Kubernetes MOOC

Solutions and notes from the [DevOps with Kubernetes](https://courses.mooc.fi/org/uh-cs/courses/devops-with-kubernetes-2026) course by the University of Helsinki (2026).

**Progress: 5 / 49 exercises**

## Cluster

Exercises run against a single-node **k3s** cluster on an Oracle Cloud Always Free ARM VM (4 OCPU / 24 GB) — not a local k3d cluster. It persists between sessions, so leftover state is real and part of the exercise.

```shell
export KUBECONFIG=~/.kube/oracle-k3s.yaml   # laptop, over Tailscale
kubectl get nodes
```

Images are published to GHCR as **public** packages, so the cluster pulls them without an `imagePullSecret`.

## Conventions

- One directory per app (`log-output/`, `todo-app/`), each with `Dockerfile`, `go.mod`, and `manifests/`.
- **Exercise number = git tag = image tag.** Tag `1.6` ↔ `ghcr.io/tony-nyagah/log-output:1.6`.
  Tags are written unpadded (`1.6`) where the course writes `1.06` — same exercise, and the `Makefile` pattern matches both.
- **One namespace per part**, so exercises don't collide with each other or with `default`:
  ```shell
  kubectl create namespace part1
  kubectl config set-context --current --namespace=part1
  ```
- **Notes per part** in `notes/part-01.md` — the concepts in my own words, kept for CKAD revision.

## Workflow per exercise

`make <exercise-number> APP=<app-folder>` (e.g. `make 1.6 APP=log-output`) runs the build, push, commit, tag and release steps below in one go.

```shell
# Build from the repo root, check it runs, then push to GHCR (log in once with `make login`)
docker build -t ghcr.io/tony-nyagah/log-output:<exercise-number> log-output
docker run --rm ghcr.io/tony-nyagah/log-output:<exercise-number>
docker push ghcr.io/tony-nyagah/log-output:<exercise-number>
```

```shell
# Deploy to Kubernetes (set the image tag in the manifest first)
kubectl apply -f log-output/manifests
```

```shell
# Commit, tag and push
git add -A
git commit -m "feat(log-output): exercise <exercise-number>"
git tag <exercise-number>
git push origin main --tags
```

```shell
# Optional: make a GitHub release from the tag
gh release create <exercise-number> --title "<exercise-number>" --notes "Exercise <exercise-number>"
```

To tag an older commit: `git tag <exercise-number> <commit-sha>`.

## Exercises

`[x]` = done and tagged (link goes to the tag). `[ ]` = not started.

### Part 1 — First deploy, debugging, networking, storage (13)

- [x] [1.01 Getting started](https://github.com/tony-nyagah/kubernetes-mooc/tree/1.1)
- [x] [1.02 Project v0.1](https://github.com/tony-nyagah/kubernetes-mooc/tree/1.2)
- [x] [1.03 Declarative approach](https://github.com/tony-nyagah/kubernetes-mooc/tree/1.3)
- [x] [1.04 Project v0.2](https://github.com/tony-nyagah/kubernetes-mooc/tree/1.4)
- [x] [1.05 Project v0.3](https://github.com/tony-nyagah/kubernetes-mooc/tree/1.5)
- [ ] 1.06 Project v0.4
- [ ] 1.07 External access with Ingress
- [ ] 1.08 Project v0.5
- [ ] 1.09 More services
- [ ] 1.10 Even more services
- [ ] 1.11 Persisting data
- [ ] 1.12 Project v0.6
- [ ] 1.13 Project v0.7

### Part 2 — Networking, configuration, StatefulSets, monitoring (10)

- [ ] 2.01 Connecting pods
- [ ] 2.02 Project v1.0
- [ ] 2.03 Keep them separated
- [ ] 2.04 Project v1.1
- [ ] 2.05 Secrets
- [ ] 2.06 Documentation and ConfigMaps
- [ ] 2.07 Stateful applications
- [ ] 2.08 Project v1.2
- [ ] 2.09 Daily todos
- [ ] 2.10 Project v1.3

### Part 3 — GKE, deployment pipeline, resource limits (10)

- [ ] 3.01 Pingpong GKE
- [ ] 3.02 Back to Ingress
- [ ] 3.03 Project v1.4
- [ ] 3.04 Project v1.4.1
- [ ] 3.05 Project v1.4.2
- [ ] 3.06 DBaaS vs DIY
- [ ] 3.07 Backup
- [ ] 3.08 Project v1.5
- [ ] 3.09 Resource limits
- [ ] 3.10 Project v1.6

### Part 4 — Probes, Prometheus, messaging, GitOps (8)

- [ ] 4.01 Readiness Probe
- [ ] 4.02 Project v1.7
- [ ] 4.03 Prometheus
- [ ] 4.04 Project v1.8
- [ ] 4.05 Project v1.9
- [ ] 4.06 Project v2.0
- [ ] 4.07 GitOps the Project
- [ ] 4.08 GitOps the Project

### Part 5 — CRDs, service mesh, serverless (8)

- [ ] 5.01 DIY CRD & Controller
- [ ] 5.02 Project, the Service Mesh Edition
- [ ] 5.03 Learn from external material
- [ ] 5.04 Wikipedia with init and sidecar
- [ ] 5.05 Platform comparison
- [ ] 5.06 Trying Serverless
- [ ] 5.07 Deploy to Serverless
- [ ] 5.08 Landscape

## CKAD mapping

This course is the fundamentals layer for CKAD prep, not exam drilling.

- **Parts 1–2** carry most of the exam's core: pod design, configuration (ConfigMaps/Secrets), services and networking, StatefulSets and Jobs, and observability.
- **Part 3** is GKE-specific and needs a Google Cloud account — low CKAD value, skimmable.
- **Part 4's** update strategies map to the Deployment domain; GitOps and messaging are broader DevOps.
- **Part 5** is beyond CKAD (CKA territory).

Deliberately supplemented elsewhere: RBAC, NetworkPolicy, Helm, Kustomize, SecurityContext, multi-container/init patterns, resource limits and quotas, probe tuning.
