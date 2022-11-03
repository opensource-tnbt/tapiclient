ARG ALPINE_VERSION=3.9-alpine
FROM python:${ALPINE_VERSION}

LABEL maintainer="Thomas and Inti"
ARG ANSIBLE_VERSION="2.10.0"

COPY ./entrypoint.sh /usr/local/bin

RUN set -euxo pipefail ;\
    sed -i 's/http\:\/\/dl-cdn.alpinelinux.org/https\:\/\/alpine.global.ssl.fastly.net/g' /etc/apk/repositories ;\
    apk add --no-cache --update --virtual .build-deps g++ python3-dev build-base libffi-dev openssl-dev ;\
    apk add --no-cache --update rust cargo python3 ca-certificates openssh-client sshpass dumb-init su-exec ;\
    apk add --no-cache --update sudo make iputils openssh openrc ;\
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi ;\
    echo "**** install pip ****" ;\
    python3 -m ensurepip ;\
    rm -r /usr/lib/python*/ensurepip ;\
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi ;\
    pip3 install --no-cache --upgrade pip ;\
    pip3 install --no-cache --upgrade paramiko setuptools wheel ansible==${ANSIBLE_VERSION} ;\
    apk del --no-cache --purge .build-deps ;\
    rm -rf /var/cache/apk/* ;\
    rm -rf /root/.cache ;\
    mkdir -p /etc/ansible/ ;\
    /bin/echo -e "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts ;\
    ssh-keygen -q -t ed25519 -N '' -f /root/.ssh/id_ed25519 ;\
    mkdir -p ~/.ssh && echo "Host *" > ~/.ssh/config && echo " StrictHostKeyChecking no" >> ~/.ssh/config && echo " KexAlgorithms +diffie-hellman-group" >> ~/.ssh/config ;\
    chmod +x /usr/local/bin/entrypoint.sh ;\
    rc-update add sshd ;\
    ssh-keygen -A
    
#RUN adduser -s /bin/ash -u 1000 -D -h /ansible ansible
RUN adduser -D ansible -h /ansible \
    && echo "ansible ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ansible \
    && chmod 0440 /etc/sudoers.d/ansible \
    && echo "ansible:ansible" | chpasswd

WORKDIR /ansible
COPY netaut netaut/
WORKDIR /ansible/netaut

RUN ansible-galaxy collection install cisco.ios
RUN ansible-galaxy collection install junipernetworks.junos

EXPOSE 22

RUN mkdir -p /run/openrc \
    && touch /run/openrc/softlevel

VOLUME ["/sys/fs/cgroup"]


ENTRYPOINT ["/usr/bin/dumb-init","--","entrypoint.sh"]
CMD ["sleep", "infinity"]
