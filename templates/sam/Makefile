AWS_PROFILE := admin-lz

.PHONY: deploy
deploy:
	sam build
	sam deploy --profile $(AWS_PROFILE) --force-upload

.PHONY: destroy
destroy:
	sam delete --profile $(AWS_PROFILE)

