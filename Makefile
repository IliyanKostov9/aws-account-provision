APP_NAME := vpn
APP_PATH := ./infra/apps/$(APP_NAME)
ENV_PATH := ../../env/prod/$(APP_NAME)/terraform.tfvars

.PHONY: tf-init
tf-init:
	terraform -chdir=$(APP_PATH) \
		init \
		-var-file=$(ENV_PATH) \
		-no-color \
		-reconfigure

.PHONY: tf-validate
tf-validate: ## Validate infa via Terraform
	terraform -chdir=$(APP_PATH) \
		validate \
		-no-color

.PHONY: tf-plan
tf-plan:
	terraform -chdir="$(APP_PATH)" plan \
		-var-file=$(ENV_PATH) \
		-no-color \
		-input=false

.PHONY: tf-apply
tf-apply:
	terraform -chdir=$(APP_PATH) \
		apply \
		-var-file=$(ENV_PATH) \
		-auto-approve \
		-input=false

.PHONY: tf-destroy
tf-destroy:
	terraform -chdir=$(APP_PATH)  destroy \
		-var-file=$(ENV_PATH) \
		-target=module.ec2_jenkins
