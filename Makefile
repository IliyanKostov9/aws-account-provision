APP_NAME := dummy
TF_MAIN_PATH := ./infra/apps/12_months_free/$(APP_NAME)
TF_ENV_PROD_PATH := ../../../env/prod/12_months_free/$(APP_NAME)/env.tfvars

.phony: tf-init
tf-init:
	terraform -chdir="$(TF_MAIN_PATH)" init \
		-var-file="$(TF_ENV_PROD_PATH)" \
		-no-color

.phony: tf-plan
tf-plan:
	terraform -chdir="$(TF_MAIN_PATH)" plan \
		-var-file="$(TF_ENV_PROD_PATH)" \
		-no-color -input=false

.phony: tf-apply
tf-apply:
	terraform -chdir="$(TF_MAIN_PATH)" apply \
		-var-file="$(TF_ENV_PROD_PATH)" \
		-auto-approve \
		-input=false

