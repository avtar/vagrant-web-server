#!/bin/sh -e

ansible-playbook docker.yml --tags "deploy" && \
nginx -t -c /etc/nginx/nginx.conf && \
nginx -c /etc/nginx/nginx.conf
