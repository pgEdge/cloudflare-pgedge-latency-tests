
.PHONY: ssh-lax
ssh-lax:
	gcloud compute ssh --zone us-west2-a --project $(GOOGLE_PROJECT) cfb-lax

.PHONY: deploy
deploy:
ifndef GOOGLE_PROJECT
	$(error GOOGLE_PROJECT is not set)
endif
	cd terraform && \
		terraform init && \
		terraform apply \
		-var "project_name=$(GOOGLE_PROJECT)" \
		-auto-approve
	cd workers/cfb-query-pgedge && wrangler deploy
	cd workers/cfb-query-d1 && wrangler deploy
	$(MAKE) capture-urls

.PHONY: capture-urls
capture-urls:
	$(shell cd workers/cfb-query-pgedge && wrangler deploy | grep https | xargs > ../../cfb-query-pgedge.url.txt)
	$(shell cd workers/cfb-query-d1 && wrangler deploy | grep https | xargs > ../../cfb-query-d1.url.txt)
	@echo "cfb-query-pgedge: $(shell cat cfb-query-pgedge.url.txt)"
	@echo "cfb-query-d1: $(shell cat cfb-query-d1.url.txt)"

QUERY_PGEDGE_URL ?= $(shell cat cfb-query-pgedge.url.txt)
QUERY_D1_URL ?= $(shell cat cfb-query-d1.url.txt)

.PHONY: deploy-measure-latency
deploy-measure-latency:
	GOOS=linux GOARCH=amd64 go build -o measure-latency ./cmd/measure-latency
	gcloud compute scp --zone us-west2-a measure-latency cfb-lax:~/
	gcloud compute scp --zone us-west3-a measure-latency cfb-slc:~/
	gcloud compute scp --zone us-south1-a measure-latency cfb-dfw:~/
	gcloud compute scp --zone us-east1-b measure-latency cfb-chs:~/
	gcloud compute scp --zone northamerica-northeast2-a measure-latency cfb-yyz:~/

MEASUREMENT_COUNT ?= 20
SSH ?= gcloud compute ssh

.PHONY: run-measure-latency
run-measure-latency:
	$(SSH) --zone us-west2-a cfb-lax --command "./measure-latency -url $(QUERY_PGEDGE_URL) -count $(MEASUREMENT_COUNT)"
	$(SSH) --zone us-west3-a cfb-slc --command "./measure-latency -url $(QUERY_PGEDGE_URL) -count $(MEASUREMENT_COUNT)"
	$(SSH) --zone us-south1-a cfb-dfw --command "./measure-latency -url $(QUERY_PGEDGE_URL) -count $(MEASUREMENT_COUNT)"
	$(SSH) --zone us-east1-b cfb-chs --command "./measure-latency -url $(QUERY_PGEDGE_URL) -count $(MEASUREMENT_COUNT)"
	$(SSH) --zone northamerica-northeast2-a cfb-yyz --command "./measure-latency -url $(QUERY_PGEDGE_URL) -count $(MEASUREMENT_COUNT)"
