SHELL := /bin/bash
current_dir := $(shell pwd)

# Environment directories
prod_env := infrastructure/environments/prod
test_env := infrastructure/environments/test
dev_env := infrastructure/environments/dev

# Module directories
module_dir := terraform-aws-guestbook
examples_dir := $(module_dir)/examples

# Initialize terraform in a directory
define init_terraform
	cd $(1) && terraform init
endef

# Apply terraform in a directory
define apply_terraform
	cd $(1) && terraform apply $(2)
endef

# Test targets
.PHONY: test
test: init-test
	cd infrastructure/test && \
		go test -v -run TestInfrastructure -timeout 15m

.PHONY: init-test
init-test:
	$(call init_terraform,$(test_env))

# Development environment
.PHONY: dev
dev: init-dev
	$(call apply_terraform,$(dev_env),-auto-approve)

.PHONY: init-dev
init-dev:
	$(call init_terraform,$(dev_env))

.PHONY: dev-down
dev-down: init-dev
	cd $(dev_env) && terraform destroy -auto-approve

# Production environment
.PHONY: prod
prod: init-prod
	$(call apply_terraform,$(prod_env))

.PHONY: init-prod
init-prod:
	$(call init_terraform,$(prod_env))

.PHONY: prod-down
prod-down: init-prod
	cd $(prod_env) && terraform destroy

# Example deployments
.PHONY: example-complete
example-complete:
	$(call init_terraform,$(examples_dir)/complete)
	$(call apply_terraform,$(examples_dir)/complete)

.PHONY: example-with-dns
example-with-dns:
	$(call init_terraform,$(examples_dir)/with-dns)
	$(call apply_terraform,$(examples_dir)/with-dns)

.PHONY: example-without-dns
example-without-dns:
	$(call init_terraform,$(examples_dir)/without-dns)
	$(call apply_terraform,$(examples_dir)/without-dns)

# Module tasks
.PHONY: fmt
fmt:
	cd $(module_dir) && terraform fmt -recursive

.PHONY: validate
validate:
	cd $(module_dir) && terraform validate

.PHONY: docs
docs:
	cd $(module_dir) && terraform-docs markdown . > README.md