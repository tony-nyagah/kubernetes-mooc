# Release an exercise: make <exercise-number> APP=<app-folder>
# e.g. make 1.1 APP=log-output
#
# Builds and pushes ghcr.io/tony-nyagah/<app>:<exercise>, commits any changes,
# tags the commit with the exercise number and creates a GitHub release.

IMAGE_PREFIX := ghcr.io/tony-nyagah
APPS := $(patsubst %/Dockerfile,%,$(wildcard */Dockerfile))

.PHONY: help
help:
	@echo "Usage: make <exercise-number> APP=<app-folder>"
	@echo "  e.g. make 1.1 APP=log-output"
	@echo ""
	@echo "Builds and pushes $(IMAGE_PREFIX)/<app>:<exercise>, commits any changes,"
	@echo "tags the commit with the exercise number and creates a GitHub release."
	@echo "If the exercise is already tagged, just prints its submission link."
	@echo ""
	@echo "Apps: $(APPS)"
	@echo ""
	@echo "make login   log Docker in to ghcr.io with your gh token"

.PHONY: login
login:
	gh auth token | docker login ghcr.io -u $$(gh api user -q .login) --password-stdin

# Already-tagged exercises skip straight to printing the submission link.
1.% 2.% 3.% 4.% 5.%:
	$(if $(shell git tag -l '$@'),@echo "Tag $@ already exists",$(release))
	@echo ""
	@echo "Submission link: $$(gh repo view --json url -q .url)/tree/$@"

define release
@test -n "$(APP)" || { echo "Usage: make $@ APP=<app-folder>"; exit 1; }
@test -d "$(APP)" || { echo "No such app folder: $(APP)"; exit 1; }
docker build -t $(IMAGE_PREFIX)/$(APP):$@ $(APP)
docker push $(IMAGE_PREFIX)/$(APP):$@
git add -A
git diff --cached --quiet || git commit -m "feat($(APP)): exercise $@"
git tag $@
git push origin HEAD
git push origin $@
gh release create $@ --title "$@" --notes "Exercise $@: $(IMAGE_PREFIX)/$(APP):$@"
endef
