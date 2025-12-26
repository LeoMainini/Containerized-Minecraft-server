# Containerized Minecraft server 🐋🧱

This project automates creating a Minecraft server using a simple, reproducible, and transportable Docker container.

The configuration was built around the requirements for the PaperMC server software. Another runnable type can be used, but YMMV.

## Requirements

### Docker Engine

* [Install guide](https://docs.docker.com/engine/install/)

### PaperMC server download URL

* [Copy from the download button here](https://papermc.io/downloads/paper)

## How-to

The `docker-compose.yml` leaves some configuration to the end user. The only required inputs are:

* `OUT_PORT`
* `SERVER_JAR_URL`
* `DEDICATED_RAM`

All other inputs are optional and are only present as a simple way to edit values without diving into the `server.properties` file.

1. Set the URL, output port, and dedicated RAM in `docker-compose.yaml`
2. Start the server with `docker compose up -d` from the base folder

   * To attach to the server console, run `docker attach <container_name>`
   * To detach, press `CTRL+P+Q` inside the terminal window
3. Stop the server with `docker compose down`

## Nice to knows

### Persist more folders from container

The persistent data for the server will be mounted in `./volumes/server`. Any data inside the server runnable folder will be persisted.

If other folders need to be persisted, add another entry to the `volumes` section in `docker-compose.yaml`, like so:

```yaml
- type: bind
  source: <HOST PATH>
  target: <PATH IN CONTAINER>
```

Example for world backups:

```yaml
- type: bind
  source: /volumes/backups
  target: /world_backups
```

### Rebuild image with changes to Dockerfile

If there are changes in the Dockerfile, dependencies, Java version, etc., the image needs to be rebuilt for them to take effect:

```bash
docker compose up --build
```

Any data being persisted will not be deleted when rebuilding the image, for this you must manually delete the persisted folders.
