# Services commands

Commands for services management.

The services management commands intends to bring up a minimal infrastructure environment for **development purposes**.

| Command | Description                                | Supported |
| :------ | :----------------------------------------- | :-------: |
| destroy | Destroy development services.              |  v0.19.0  |
| stop    | Stop local services.                       |  v0.19.0  |

The services management commands uses Docker-Compose behind the scenes, and specifically relies on the `docker-compose.yml` file. The `containers` commands instead relies on the `docker-compose.full.yml` file.

## **`services destroy`**

Destroy development services and any data in them.

## **`services stop`**

Stop containerized services.

The command does not destroy any data in the services.
