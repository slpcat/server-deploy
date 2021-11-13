#!/bin/bash
set -ex

docker pull slpcat/log-pilot:0.9.7-filebeat-7.15.0
docker pull busybox:latest
docker pull registry.ap-northeast-1.aliyuncs.com/log-service/logtail:latest
docker pull rancher/fleet-agent:v0.3.3
docker pull registry.ap-northeast-1.aliyuncs.com/acs/node-problem-detector:v0.6.3-29-71bd5f8
docker pull docker.elastic.co/kibana/kibana:7.9.3
docker pull quay.io/brancz/kube-rbac-proxy:v0.6.0
docker pull slpcat/kube-state-metrics:v1.9.7
docker pull slpcat/node-exporter:v0.18.1
