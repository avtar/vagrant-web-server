FROM inclusivedesign/centos

COPY provisioning/*.yml /etc/ansible/playbooks/

COPY provisioning/start.sh /usr/local/bin/start.sh

COPY www /srv/www

WORKDIR /etc/ansible/playbooks

RUN ansible-galaxy install -fr requirements.yml && \
    ansible-playbook docker.yml --tags "install,configure" && \
    chmod 755 /usr/local/bin/start.sh

EXPOSE 8888

ENTRYPOINT ["/usr/local/bin/start.sh"]
