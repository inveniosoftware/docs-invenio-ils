# Install

**Scope**

This guide covers how to set up an InvenioILS instance locally on your development machine.

## Prerequisites

Make sure that you have installed the prerequisites below:

- Python 3, at the moment we are using Python 3.9.
- [pipenv](https://pypi.org/project/pipenv/), e.g. via [`pip`](https://pip.pypa.io/en/stable/).
- [NodeJS](https://nodejs.org/en/download/) version 14.
- [InvenioCLI](https://pypi.org/project/invenio-cli/) tool (see [reference](./reference/cli.md))

## Quick start

Every time you want to run InvenioILS, you will need to:

1. have the Docker services up and running
2. have the InvenioILS backend development web server and celery workers running
3. have the InvenioILS UI development web server running


### 1. Scaffold project

Scaffold your InvenioILS instance.

```
invenio-cli init ils -c v4.5.0
```

You will be asked several questions. If in doubt, choose the default. For this tutorial we assume you left the project name as the default: `my-site`.


For more information about the scaffolding process, see the [scaffold reference](./reference/scaffold.md).

### 2. Start all dependent services using docker-compose
This will start PostgreSQL, Elasticsearch, RabbitMQ and Redis:

```console
cd my-site/
docker-compose up -d
```


### 3. Setup
This will install dependencies, builds assets, create demo static pages, seed the database with demo data and creates indexes in OpenSearch.

```console
./setup.sh
```

### 4. Run backend components

#### Run the backend server

```console
FLASK_ENV=development pipenv run invenio run --cert docker/backend/test.crt --key docker/backend/test.key
```

Now visit [https://127.0.0.1:5000](https://127.0.0.1:5000) (accept the self-signed certificate warning if proposed). You should now see the InvenioILS backend.

**Note** The server is using a self-signed SSL certificate, which we specify in the command above.
If this is not the desired behaviour, you can by-pass it with:

  1. Changing `REACT_APP_INVENIO_UI_URL` and `REACT_APP_INVENIO_REST_ENDPOINTS_BASE_URL` variables in `ui/.env` file to run on `http` instead of `https`.
  2. Running the server without specifying the certificate: `FLASK_ENV=development pipenv run invenio run`

#### Run the celery worker. 

In a new terminal.  
Make sure you are in the project folder (`my-site`) then run:

```bash
pipenv run celery -A invenio_app.celery worker -l INFO
```

### 5. Install UI dependencies
In a new terminal.  
Install the JavaScript dependencies:

```console
cd my-site/ui
npm install
```

### 6. Run frontend web server
```console
npm start
```

Now visit [https://127.0.0.1:3000](https://127.0.0.1:3000) (accept the self-signed certificate warning if proposed). You should now see the InvenioILS website.

### 7. Stop it
When you are done, you can stop your instance

To just stop the containers:
```bash
docker-compose stop
```
