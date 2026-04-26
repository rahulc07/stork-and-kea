# Docker Compose/Dockerfiles for Stork + Kea

This sets up a Kea 3.0 with the Stork management UI for DHCP. By default it will use the hosts network so use the host interface names.

# Infiniband Support
Thus set of containers has been patched with PR 134 from the ISC Kea GitHub, this allows for transparent IPoIB support.

# Pre-Reqs
Set a static IP on the interface you want to have DHCP on, this is needed so that we can loopback on our own subnet.

# Running
1. Copy dotenv-template to .env
2. Edit .env with your options, host ip should be a static IP for your host (not 127.0.0.1 or localhost)
3.
```
docker compose up -d
```

# Configuring
Go to localhost:8087 to get to stork, the default username/password is admin/admin, it will prompt you to change your password.

Once that is complete click on the Yellow Banner to allow the Kea server to connect to stork.
