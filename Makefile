image = rabbitmq_exporter:latest
cwd = $(shell pwd)

help:   ## show help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

build:  ## build docker image
	docker build -t $(image) .

rpm:    ## copy rpm file from container
rpm: build
	mkdir -p $(cwd)/output
	docker run --rm --mount src=$(cwd)/output,target=/output,type=bind $(image) \
		cp -arp /root/rpmbuild/RPMS/x86_64/rabbitmq_exporter-2020.1-1.el7.centos.x86_64.rpm /output/

clean:
	rm -rf output
	docker image prune
