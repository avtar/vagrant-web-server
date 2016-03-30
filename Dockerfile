FROM inclusivedesign/centos

WORKDIR /etc/ansible/playbooks

COPY provisioning/* /etc/ansible/playbooks/

ENV INSTALL_DIR=/opt/web-server

ENV EXTRA_VARS_FILE=docker-vars.yml

COPY . $INSTALL_DIR

RUN ansible-playbook docker.yml --tags "install,configure"

COPY provisioning/start.sh /usr/local/bin/start.sh

RUN chmod 755 /usr/local/bin/start.sh

EXPOSE 8888

ENTRYPOINT ["/usr/local/bin/start.sh"]
