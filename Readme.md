# netaut container

 Minimimal [ Python Alpine Linux](https://alpinelinux.org/) docker image for running [Ansible](https://www.ansible.com/) for Network Automation.

## Build Image

### Build from git repository

```
$ git clone https://github.com/opensource-tnbt/netaut.git && cd netaut

$ make build
```

The image will be tagged with the 1.0 , e.g. `spirent/netaut:1.0`

### Modifying Dockerfile before build

#### Add ansible user as sudoer.

Install sudo, by adding this line

RUN apk add sudo

Next, odify the line
```
RUN adduser -s /bin/ash -u 1000 -D -h /ansible ansible
```
to
```
RUN adduser -D ansible -h /ansible \
    && echo "ansible ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ansible \
    && chmod 0440 /etc/sudoers.d/ansible
```

Note: 

1. To run the container as root user, please refer to *Shell Access* section.
2. To make the default run as root user, modify the entrypoint.sh file - Replace line 15 with line 12. 


### Pull from Docker Hub

Not yet published to Dockerhub

## Run container

Run a playbook inside the container:

```
$ docker run -it --rm \
    spirent/netaut \
    ansible-playbook -i hosts playbook.yml
```

### Builtin test for `ansible --version`

```
$ docker run -it --rm spirent/netaut:1.0 version
ansible 2.10.10
  config file = None
  configured module search path = ['/ansible/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/local/lib/python3.9/site-packages/ansible
  executable location = /usr/local/bin/ansible
  python version = 3.9.5 (default, May  4 2021, 18:33:52) [GCC 10.2.1 20201203]

```

### Builtin test for `ansible -m setup all` (localhost)

```
$ docker run -it --rm spirent/netaut:1.0 setup
localhost | SUCCESS => {
    "ansible_facts": {
        "ansible_all_ipv4_addresses": [
            "172.17.0.2"
        ],
        "ansible_all_ipv6_addresses": [],
        "ansible_apparmor": {
            "status": "disabled"
        },
        "ansible_architecture": "x86_64",
        "ansible_bios_date": "12/01/2006",
        "ansible_bios_vendor": "innotek GmbH",
        "ansible_bios_version": "VirtualBox",
        "ansible_board_asset_tag": "NA",
        "ansible_board_name": "VirtualBox",

...
```

## Shell access

Shell access as user `ansible`

```
$ docker run -it --rm spirent/netaut:1.0
~/netaut $ whoami
ansible
```

Shell access as user `root`

```
$ docker run -it --rm spirent/netaut:1.0 makemeroot
/ansible/netaut # whoami
root
```

## Make

Makefile included for build, run, test, clean,...

```
$ make
build                          build container
build-no-cache                 build container without cache
build-ver                      build specific ansible version: make build-ver ALPINE_VERSION="3.9" ANSIBLE_VERSION="2.7.6"
clean                          remove images
help                           this help
history                        show docker history for container
inspect                        inspect container properties - pretty: 'make inspect | jq .' requires jq
logs                           show docker logs for container (ONLY possible while container is running)
run                            run container
test                           test container with builtin tests
```

