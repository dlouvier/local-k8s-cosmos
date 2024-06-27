K3D_PROJECT_PATH := $(shell pwd)

default: help

help:
	@echo 'make help - prints this help'
	@echo 'make provision - creates a new k3s cluster (k3s-local) with Cosmos SDK, provision a local Test Net and Prometheus & Grafana'
	@echo 'make clean - deletes the k3s cluster (k3s-local)'
	@echo 'make test - creates a port-forward to cosmos-sdk service and try to use the describe method with grpcurl'

provision:
	@echo 'Provisining cluster...'
	@K3D_PROJECT_PATH="$(K3D_PROJECT_PATH)" k3d cluster create -c k3d.yml
	@until kubectl get pod -n default -l app=cosmos-sdk --field-selector=status.phase!=Terminating 2>/dev/null | grep -q '^'; do \
	    echo "Pod not created yet, waiting..."; \
	    sleep 2; \
	done
	@sleep 10
	@echo 'Cluster provisioned!'

clean:
	@k3d cluster delete k3s-local

grafana:
	@echo 'The grafana instance URL is: http://grafana-7f000001.nip.io/'
	@echo 'The user/password is: admin/admin'
	@echo 'Data starts populating after 5/10min the whole cluster is running.'

test:
	@echo "Starting port-forwarding..."
	@kubectl port-forward service/cosmos-sdk 9090:9090 -n default > /dev/null & echo $$! > port-forward.pid
	@sleep 5
	@grpcurl -plaintext 127.0.0.1:9090 describe cosmos.bank.v1beta1.Query
	@echo "Cleaning up port-forwarding..."
	@if [ -f port-forward.pid ]; then kill `cat port-forward.pid`; rm port-forward.pid; fi