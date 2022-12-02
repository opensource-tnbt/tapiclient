#######################################################
#   Docker container for OPNFV-TESTAPI
#######################################################
# Purpose: run opnfv-testapi for gathering test results
#
# Maintained by SerenaFeng
# Build:
#    $ docker build -t opnfv/testapi:tag .
#
# Execution:
#    $ docker run -dti -p 8001:8000 \
#      -e "base_url=http://10.63.243.17:8001" \
#      -e "mongodb_url=mongodb://10.63.243.17:27017/" \
#      opnfv/testapi:tag
#
# NOTE: providing swagger_url, mongodb_url is optional.
#       If not provided, it will use the default one
#       configured in config.ini
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
#

FROM ubuntu:18.04
MAINTAINER SerenaFeng <feng.xiaowei@zte.com.cn>
LABEL version="v1" description="OPNFV TestAPI Docker container"

ARG user=ubuntu
ARG group=ubuntu

RUN apt-get update && apt-get install -y \
    curl git gcc wget python-dev python-pip python-wheel python-setuptools \
    crudini libxslt-dev zlib1g-dev --no-install-recommends && \
  groupadd -r $group && useradd -ms /bin/bash $user -g $group && \
  git clone https://github.com/opensource-tnbt/releng-testresults \
    /home/ubuntu/releng-testresults && \
  pip install -r /home/ubuntu/releng-testresults/testapi/requirements.txt \
    -c /home/ubuntu/releng-testresults/testapi/upper-constraints.txt \
    -c https://raw.githubusercontent.com/openstack/requirements/stable/ussuri/upper-constraints.txt && \
  sed -i '152,152s/)/,\ verify=False)/g' \
    /usr/local/lib/python2.7/dist-packages/cas.py && \
  cd /home/ubuntu/releng-testresults/testapi/ && python setup.py install && \
  for i in /home/ubuntu/releng-testresults /etc/opnfv_testapi /usr/local/share/opnfv_testapi; do \
    mkdir -p $i && chown -R $user:$group $i && \
    find $i -type d |xargs chmod 777 && \
    find $i -type f |xargs chmod 666 ; done && \
  apt-get remove --purge -y python-dev libxslt-dev zlib1g-dev && \
  apt-get autoremove --purge -y && apt-get clean && rm -rf /var/lib/apt/lists/*
WORKDIR /home/ubuntu/releng-testresults/testapi
USER ubuntu
CMD ["bash", "docker/start-server.sh"]
