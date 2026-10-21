# Kubernetes MOOC

Solutions to: https://courses.mooc.fi/org/uh-cs/courses/devops-with-kubernetes-2026

## Workflow per exercise

Use the exercise number as both the git tag and the image tag (git tag `1.1` ↔ `ghcr.io/tony-nyagah/log-output:1.1`).

`make <exercise-number> APP=<app-folder>` (e.g. `make 1.1 APP=log-output`) runs the build, push, commit, tag and release steps below in one go.

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

- [1.1](https://github.com/tony-nyagah/kubernetes-mooc/tree/1.1)
- [1.2](https://github.com/tony-nyagah/kubernetes-mooc/tree/1.2)
- [1.3](https://github.com/tony-nyagah/kubernetes-mooc/tree/1.3)
