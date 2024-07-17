# Develop

This documentation will guide you on how to setup your local development environment.

The installation process is composed of two parts: install and run the Invenio backend, and install and run the JavaScript frontend (Single Page Application).

### Prerequisites

Make sure that you have installed the prerequisites below:

- Python 3, at the moment we are using Python 3.9.
- [pipenv](https://pypi.org/project/pipenv/), e.g. via [`pip`](https://pip.pypa.io/en/stable/).
- [NodeJS](https://nodejs.org/en/download/) version 14.
- [InvenioCLI](https://pypi.org/project/invenio-cli/) tool (see [reference](../reference/cli.md))

## Quick start

Every time you want to run InvenioILS, you will need to:

1. have the Docker services up and running
2. have the InvenioILS backend development web server and celery workers running
3. have the InvenioILS UI development web server running


### [1. Scaffold project](../reference/scaffold.md)

Scaffold your InvenioILS instance. Replace `<version>` with the version you want to install:

```
invenio-cli init ils -c v4.0.0
```

You will be asked several questions. If in doubt, choose the default.

### 2. Start all dependent services using docker-compose
This will start PostgreSQL, Elasticsearch, RabbitMQ and Redis:

```console
cd my-site/
docker-compose up -d
```

### 3. Build, setup and run backend part
```console
./setup.sh
```

Run the backend server:

```console
FLASK_ENV=development pipenv run invenio run --cert docker/backend/test.crt --key docker/backend/test.key
```
**Note** The server is using a self-signed SSL certificate, which we specify in the command above.
If this is not the desired behaviour, you can by-pass it by:

  1. Changing `REACT_APP_INVENIO_UI_URL` and `REACT_APP_INVENIO_REST_ENDPOINTS_BASE_URL` variables in `ui/.env` file to run on `http` instead of `https`.
  2. Running the server without specifying the certificate: `FLASK_ENV=development pipenv run invenio run`


In a new terminal, start the celery worker. Make sure you are in the project folder (`my-site`) then run:

```bash
pipenv run celery -A invenio_app.celery worker -l INFO
```

### 4. Install UI dependencies
Open a separate command line and install the JavaScript dependencies:

```console
cd my-site/ui
npm install
```

### 5. Run frontend web server
```console
npm start
```

Now visit [https://127.0.0.1:3000](https://127.0.0.1:3000) (accept the self-signed certificate warning if proposed). You should now see the InvenioILS website.

### 6. Stop it
When you are done, you can stop your instance and optionally destroy the containers:

To just stop the containers:
```bash
docker-compose stop
```
