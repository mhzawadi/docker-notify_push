# Client Push

![GitHub Workflow Status](https://img.shields.io/github/workflow/status/mhzawadi/docker-notify_push/build%20our%20image%20for%20latest?label=Docker%20Latest)
![Docker Pulls](https://img.shields.io/docker/pulls/mhzawadi/notify_push)

Update notifications for nextcloud clients

## About

This app attempts to solve the issue where Nextcloud clients have to periodically check the server if any files have
been changed. In order to keep sync snappy, clients wants to check for updates often, which increases the load on the
server.

With many clients all checking for updates a large portion of the server load can consist of just these update checks.

By providing a way for the server to send update notifications to the clients, the need for the clients to make these
checks can be greatly reduced.

Update notifications are provided on a "best effort" basis, updates might happen without a notification being send and a
notification can be send even if no update has actually happened. Clients are advised to still perform periodic checks
for updates on their own, although these can be run on a much lower frequency.

## Requirements

This app requires a redis server to be setup and for nextcloud to be configured to use the redis server.

## Docker run

You can use this with both a standalone docker host or a docker swarm, see below for both.

```
docker run --rm -it -p 7867:7867 mhzawadi/notify_push
```

````
version: '3.5'

# docker stack deploy --compose-file this-file.yml

configs:
  nextcloud_config.php:
    external: true

volumes:
  nextcloud:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: '/path/to/your/data/'

services:
  redis:
    image: redis
    ports:
      - "6379:6379"
    deploy:
      mode: replicated
      replicas: 1
      placement:
        constraints: [node.role == worker]
      labels:
        - traefik.enable=false
  notify_push:
    image: mhzawadi/notify_push
    ports:
      - "7867:7867"
    deploy:
      mode: replicated
      replicas: 1
      placement:
        constraints: [node.role == worker]
      labels:
        - traefik.enable=false
    configs:
      - source: nextcloud_config.php
        target: /etc/nc_config.php
        uid: "0"
        gid: "0"
        mode: 0444
    volumes:
      - nextcloud:/data
```
