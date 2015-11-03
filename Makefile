# account info
USERNAME = $(shell swarm user)
TOKEN = $(shell cat ~/.swarm/token)
ENV = $(shell swarm env)

# service info
SERVICE = sample
REGISTRY = docker.io
REGISTRY_USERNAME = kordinator
IMAGE = $(REGISTRY)/$(REGISTRY_USERNAME)/$(SERVICE)
DOMAIN = sample-$(USERNAME).gigantic.io
PORT = 5000
DEV_DOMAIN = $(shell boot2docker ip):$(PORT)

clean:
	rm -f swarm-api.json swarm.json

config: clean
	@ ./config.sh '$(SERVICE)' '$(IMAGE)' '$(DOMAIN)' '$(PORT)'
	@echo "##########################################################"
	@echo "Definition files written..."
	@echo "Check swarm-api.json into your repo before deployment..."
	@echo "##########################################################"

build: config
	docker build -t $(IMAGE) .

run: build
	@echo "##########################################################"
	@echo "View the service at: http://$(DEV_DOMAIN)"
	@echo "##########################################################"
	
	docker run --name=sample --rm -ti \
		-p $(PORT):$(PORT) \
		$(IMAGE)

push: build
	docker push $(IMAGE)

pull:
	docker pull $(IMAGE)

deploy: push
	swarm up
	@echo "#####################################################################"
	@echo "View the service at: http://$(DOMAIN)/hello/$(USERNAME)"
	@echo "#####################################################################"
