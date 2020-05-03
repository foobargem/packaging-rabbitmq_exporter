# build rabbitmq_exporter
FROM golang:1.14.1-alpine as builder

RUN apk --no-cache add git ca-certificates
RUN mkdir /work

WORKDIR /work
RUN git clone -b v1.0.0-RC7 https://github.com/kbudde/rabbitmq_exporter.git

WORKDIR /work/rabbitmq_exporter
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o rabbitmq_exporter .


# rpmbuild
FROM centos:7.4.1708

RUN yum -y install rpm-build git tar gzip
RUN mkdir /root/src /root/rabbitmq_exporter-2020.1
RUN mkdir -p /root/rpmbuild/{SOURCES,SPECS}

WORKDIR /root/rabbitmq_exporter-2020.1
COPY --from=builder /work/rabbitmq_exporter/rabbitmq_exporter .

WORKDIR /root/src
RUN git clone https://github.com/foobargem/packaging-rabbitmq_exporter.git

WORKDIR /root/src/packaging-rabbitmq_exporter
RUN cp rpm/config.json /root/rabbitmq_exporter-2020.1/
RUN cp rpm/rabbitmq_exporter.service /root/rabbitmq_exporter-2020.1/
RUN cp rpm/rabbitmq_exporter.spec /root/rpmbuild/SPECS/

WORKDIR /root
RUN tar cvzf /root/rpmbuild/SOURCES/rabbitmq_exporter-2020.1.tar.gz rabbitmq_exporter-2020.1/

WORKDIR /root/rpmbuild
RUN rpmbuild -ba SPECS/rabbitmq-exporter.spec
