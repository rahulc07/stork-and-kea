FROM debian:trixie-slim
ENV DEBIAN_FRONTEND=noninteractive
ENV INTERFACES="*"
ENV STORK_SERVER_URL="http://127.0.0.1:8080"
ENV STORK_AGENT_PORT="8080"
ENV STORK_AGENT_LISTEN_STORK_ONLY="true"


VOLUME ["/etc/kea", "/var/lib/kea"]
WORKDIR .
RUN apt-get update && apt-get install -y \
    curl \
    supervisor \
    && curl -1sLf 'https://dl.cloudsmith.io/public/isc/kea-2-6/setup.deb.sh' | bash \
    && curl -1sLf 'https://dl.cloudsmith.io/public/isc/stork/setup.deb.sh' | bash \
    && apt-get update && apt-get install -y \
    gettext-base \
    kea \
    isc-stork-agent \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
# Kea basic setup
RUN mkdir -p /etc/kea-distribution
COPY ./default-confs/* /etc/kea-distribution/
RUN mkdir -p /var/run/kea /var/run/supervisord

# Supervisor Config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# DHCP, Kea ctrl, stork agent
EXPOSE 67/udp 8000 8080

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

