ARG SALT_MASTER_VERSION

FROM ghcr.io/cdalvaro/docker-salt-master:${SALT_MASTER_VERSION}

RUN pip install onepasswordconnectsdk==1.3.0
