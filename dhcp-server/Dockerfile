FROM debian:trixie AS buildkea
WORKDIR /build
RUN apt-get update && apt-get install -y \
    curl \
    supervisor \
    gettext-base \
    bison \
    libssl3t64  \
    default-libmysqlclient-dev \
    flex \
    libboost-all-dev \
    libboost-numpy-dev \
    liblog4cplus-dev \
    libpq-dev \
    libssl-dev \
    meson \
    po-debconf \
    postgresql-server-dev-all \
    procps \
    pkgconf \
    python3 \
    python3-sphinxcontrib.applehelp \
    wget \
    python3-sphinx-rtd-theme
RUN wget https://patch-diff.githubusercontent.com/raw/isc-projects/kea/pull/134.patch
RUN wget https://github.com/isc-projects/kea/archive/refs/tags/Kea-3.0.3.tar.gz \
    && tar -xvf Kea-3.0.3.tar.gz
# i hate you for ragebaiting the name github
WORKDIR /build/kea-Kea-3.0.3
# Add Infiniband Support
RUN patch -Np1 -i ../134.patch
WORKDIR /build/kea-Kea-3.0.3/build
RUN meson setup ..             \
      --prefix=/usr        \
      --sysconfdir=/etc    \
      --localstatedir=/var \
      --buildtype=release  \
      -D crypto=openssl    \
      -D runstatedir=/run
RUN ninja && DESTDIR=/build/kea ninja install 





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
    liblog4cplus-2.0.5t64 \
    gettext-base \
    libboost-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
COPY --from=buildkea /build/kea/usr /usr/
COPY --from=buildkea /build/kea/etc/kea /etc/kea
RUN ldconfig

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

