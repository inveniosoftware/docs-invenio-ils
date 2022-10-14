# CLI reference

**Summary**

The following document is a reference guide to the commands provided by the
Invenio-CLI tool.

**Note:** The guide describes the functionality of invenio-cli that is used for working with InvenioILS instances.

**Intended audience**

This guide is intended for system administrators and developers of InvenioILS.

## Overview

Following is an overview of the root-level commands in Invenio-CLI:

| Command              | Description                                                                                   | Supported |
| :------------------- | :-------------------------------------------------------------------------------------------- | :-------: |
| `check-requirements` | Checks the system fulfills the pre-requirements.                                              |  v0.19.0  |
| `init`               | Initializes the application according to the chosen flavour (Currently only RDM is available) |  v0.19.0  |
| `install`            | Installs the project locally.                                                                 |  v0.19.0  |
| `services`           | Commands for services management.                                                             |  v0.19.0  |


## General commands

### **`check-requirements`**

Checks the minimal system requirements are met.

**Options**

- `-d`, `--development` Check also development requirements (defaults to not checking development requirements).

### **`destroy`**

Removes all associated resources (containers, images, volumes, Python virtual environment).

All data in services are lost.

### **`init`**

Initializes the application skeleton for the chosen flavour. Currently only `rdm` flavour is supported and it is the default value.

**Options**

- `-t`, `--template` `TEXT` Path or git URL to the Cookiecutter template.
- `-c`, `--checkout` `TEXT` Branch, tag or commit to checkout if `--template` is a git URL.

### **`install`**

Installs the project locally.

Installs Python dependencies, creates an instance directory, symlinks the `invenio.cfg`, templates, static files, assets, and finally builds front-end assets.

A python virtual environment is created if does not already exists.

**Options**

- `--pre` If specified, allows the installation of alpha releases
- `-p`, `--production` / `-d`, `--development` Production mode copies statics/assets. Development mode symlinks statics/assets (default).


## Services commands

Commands for services management.

The services management commands intends to bring up a minimal infrastructure environment for **development purposes**.

| Command | Description                                | Supported |
| :------ | :----------------------------------------- | :-------: |
| destroy | Destroy development services.              |  v0.19.0  |
| stop    | Stop local services.                       |  v0.19.0  |

The services management commands uses Docker-Compose behind the scenes, and specifically relies on the `docker-compose.yml` file. The `containers` commands instead relies on the `docker-compose.full.yml` file.

### **`services destroy`**

Destroy development services and any data in them.

### **`services stop`**

Stop containerized services.

The command does not destroy any data in the services.
