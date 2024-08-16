init:
	terraform init
plan:
	terraform plan -var-file=fixtures.us-east-2.tfvars
apply:
	terraform apply -var-file=fixtures.us-east-2.tfvars
destroy:
	terraform destroy -var-file=fixtures.us-east-2.tfvars