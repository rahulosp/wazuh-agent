FROM ubuntu:jammy

LABEL maintainer "rahulosp"
LABEL version "4.7.0-1"
LABEL description "Wazuh Agent"
ARG AGENT_VERSION="4.7.0-1"

COPY entrypoint.sh ossec.conf /

RUN apt-get update && apt-get -y install \
    procps curl apt-transport-https gnupg2 inotify-tools python3-docker

RUN curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | apt-key add - && \
    echo "deb https://packages.wazuh.com/4.x/apt/ stable main" | tee /etc/apt/sources.list.d/wazuh.list && \
    apt-get update && \
    apt-get install -y wazuh-agent=${AGENT_VERSION}

RUN mv /ossec.conf /var/ossec/etc/ && rm -rf /var/lib/apt/lists/*

RUN chmod 755 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
