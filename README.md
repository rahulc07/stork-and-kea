# Docker Compose/Dockerfiles for Stork + Kea

This sets up a Kea 3.0 with the Stork managemnet UI for DHCP. By default it will use the hosts network so use the host interface names.

# Running
1. Copy dotenv-template to .env
2. Edit .env with your options, host ip should be a static IP for your host (not 127.0.0.1 or localhost)
3.
```
docker compose up -d
```

Go to 0.0.0.0:8087 to setup
