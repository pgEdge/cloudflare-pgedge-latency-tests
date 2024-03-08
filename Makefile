
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
	cd workers/query-pgedge && wrangler deploy
	$(MAKE) capture-url

.PHONY: capture-url
capture-url:
	$(shell cd workers/query-pgedge && wrangler deploy | grep https | xargs > ../../worker.url.txt)
	@echo "query-pgedge url: $(shell cat worker.url.txt)"

WORKER_URL ?= $(shell cat worker.url.txt)

.PHONY: deploy-measure-latency
deploy-measure-latency:
	GOOS=linux GOARCH=amd64 go build -o measure-latency ./cmd/measure-latency
	gcloud compute scp --zone us-west2-a measure-latency cfb-lax:~/
	gcloud compute scp --zone us-west3-a measure-latency cfb-slc:~/
	gcloud compute scp --zone us-south1-a measure-latency cfb-dfw:~/
	gcloud compute scp --zone us-east1-b measure-latency cfb-chs:~/
	gcloud compute scp --zone northamerica-northeast2-a measure-latency cfb-yyz:~/
	gcloud compute scp --zone europe-west2-a measure-latency cfb-lhr:~/

MEASUREMENT_COUNT ?= 30
SSH ?= gcloud compute ssh

.PHONY: run-measure-latency
run-measure-latency:
	@echo "-----"
	$(SSH) --zone us-west2-a cfb-lax --command "./measure-latency -url $(WORKER_URL) -count $(MEASUREMENT_COUNT)"
	@echo "-----"
	$(SSH) --zone us-west3-a cfb-slc --command "./measure-latency -url $(WORKER_URL) -count $(MEASUREMENT_COUNT)"
	@echo "-----"
	$(SSH) --zone us-south1-a cfb-dfw --command "./measure-latency -url $(WORKER_URL) -count $(MEASUREMENT_COUNT)"
	@echo "-----"
	$(SSH) --zone us-east1-b cfb-chs --command "./measure-latency -url $(WORKER_URL) -count $(MEASUREMENT_COUNT)"
	@echo "-----"
	$(SSH) --zone northamerica-northeast2-a cfb-yyz --command "./measure-latency -url $(WORKER_URL) -count $(MEASUREMENT_COUNT)"
	@echo "-----"
	$(SSH) --zone europe-west2-a cfb-lhr --command "./measure-latency -url $(WORKER_URL) -count $(MEASUREMENT_COUNT)"
