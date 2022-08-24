PREFIX ?= deleteme

include tmp.vars

init:
ifneq ($(env),)
	$(eval BUCKET := $(PREFIX)-$(env)-tf-state)
	@echo Using bucket $(BUCKET)
	-aws s3 mb s3://$(BUCKET)
	@echo Using key $(env)-tf-state.json
	terraform init -backend-config="bucket=$(BUCKET)" \
	               -backend-config="key=$(env)-tf-state.json" \
	               -lock=false -backend=true -force-copy -get=true -input=false
	echo "env=$(env)" > tmp.vars
	chmod 700 tmp.vars
else
	@echo "Please pass in the env variables, eg, make init env=stg"
endif

plan: tmp.vars
	@terraform plan --var-file="$(env).tfvars" -out tf.plan -lock=false

# apply: tf.plan
# 	terraform apply -lock=false tf.plan && \
# 	rm tf.plan

destroy: tmp.vars
	@terraform destroy --var-file="$(env).tfvars" -lock=false

.PHONY: init plan apply destroy
