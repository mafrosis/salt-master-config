ARG SALT_MASTER_VERSION=3005.1_2

FROM ghcr.io/cdalvaro/docker-salt-master:${SALT_MASTER_VERSION}

RUN pip install onepasswordconnectsdk==1.1.0
