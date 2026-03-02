FROM debian:trixie-slim
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y curl gnupg2 \
    && curl -1sLf 'https://dl.cloudsmith.io/public/isc/stork/setup.deb.sh' | bash \
    && apt-get update && apt-get install -y isc-stork-server \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Stork Server default port
EXPOSE 8080

# Start the server (pointing to environment variables for DB)
CMD ["/usr/bin/stork-server"]
