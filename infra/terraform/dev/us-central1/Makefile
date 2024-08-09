.PHONY: infra-up infra-destroy

infra-up:
	terraform -chdir=db/ apply
	terraform -chdir=gke/ apply
	gcloud container clusters get-credentials zksync-dev-01 --region us-central1 --project zksync-413615
	terraform -chdir=k8s_resources/ apply -auto-approve

infra-destroy:
	terraform -chdir=k8s_resources/ destroy -auto-approve
	terraform -chdir=gke/ destroy -auto-approve
	terraform -chdir=db/ destroy -auto-approve
