# Quickstart

The installation process is composed of two parts: install and run Invenio backend, and install and run JS frontend (Single Page Application).
At the moment, InvenioILS is still under development. The following quickstart guide is to run InvenioILS in a development environment.

## Install

### Prerequisites

In your computer, you will need:

* GIT to clone the repository
* Python 3, at the moment we are using Python 3.6
* [virtualenv](https://virtualenv.pypa.io/en/stable/installation.html#via-pip)) and [virtualenvwrapper](https://virtualenvwrapper.readthedocs.io/en/latest/install.html)
* [Docker](https://docs.docker.com/get-docker/) and [docker-compose](https://docs.docker.com/compose/install/)
* [NodeJS](https://nodejs.org/en/download/) latest LTS release

### Install Invenio backend

Clone the project repository from GitHub <https://github.com/inveniosoftware/invenio-app-ils>.

```bash
cd <my directory e.g. myprojects>/invenioils
git clone https://github.com/inveniosoftware/invenio-app-ils invenioils
cd invenioils
```

Create a new Python `virtualenv`:

```bash
mkvirtualenv invenioils
```

Start all dependent services using docker-compose (this will start PostgreSQL, Elasticsearch, RabbitMQ and Redis):

```bash
docker-compose up -d
```

> Make sure you have [enough virtual memory](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html#docker-cli-run-prod-mode) for Elasticsearch in Docker.

Bootstrap the instance (this will install all Python dependencies and build all static assets):

```bash
(invenioils)$ ./scripts/bootstrap
```

Next, create database tables, search indexes, message queues and demo data:

```bash
(invenioils)$ ./scripts/setup
```

The previous step created a set of demo data that allows to try the product.
You can find the list of demo users in the homepage of InvenioILS when you run it. Otherwise, here the list:

| user      | email             | psw    | notes                                                  |
| --------- | ----------------- | ------ | ------------------------------------------------------ |
| admin     | admin@test.ch     | 123456 | super admin user, can access also to /admin            |
| librarian | librarian@test.ch | 123456 | user with "librarian" rights, can access to backoffice |
| patron1   | patron1@test.ch   | 123456 | a patron user, cannot access to backoffice             |
| patron2   | patron2@test.ch   | 123456 | a patron user, cannot access to backoffice             |
| patron3   | patron3@test.ch   | 123456 | a patron user, cannot access to backoffice             |
| patron4   | patron4@test.ch   | 123456 | a patron user, cannot access to backoffice             |

Since the InvenioILS web server is running on a different HTTP port (`:5000`) of the UI web server (`:3000`), we will have to tune Invenio configuration
to allow HTTP requests from different domain (CORS). To do that, we override the default configuration via the `invenio.cfg` file:

1. Navigate to your virtualenv, e.g. `~/.virtualenvs/invenioils/`
2. create the needed folders: `mkdir -p var/instance`
3. create a new file `invenio.cfg` with the following content:

```bash
CORS_SUPPORTS_CREDENTIALS=True
```

### Install UI frontend

Clone the project repository from GitHub: <https://github.com/inveniosoftware/react-invenio-app-ils>.

```bash
cd <my directory e.g. myprojects>
git clone https://github.com/inveniosoftware/react-invenio-app-ils invenioilsui
cd invenioilsui
```

Then, install the JavaScript dependencies.

```bash
npm install
```

## Run

Every time you want to run InvenioILS, you will need to:

1. have the Docker services up and running
2. have the InvenioILS backend development web server and celery workers running
3. have the InvenioILS UI development web server running

### Run docker

In a new terminal run:

```bash
cd <my directory e.g. myprojects>/invenioils
docker-compose up
```

### Run backend web server

Start the Invenio backend web server (remember to activate the virtualenv with the command `workon`). In a new terminal run:

```bash
cd <my directory e.g. myprojects>/invenioils
workon invenioils
(invenioils)$ ./scripts/server
```

Start the celery worker. In a new terminal run:

```bash
cd <my directory e.g. myprojects>/invenioils
workon invenioils
(invenioils)$ celery worker -A invenio_app.celery -l INFO
```

### Run frontend web server

The user interface is a single page React application created using [create-react-app](https://facebook.github.io/create-react-app/).
 In a new terminal run:

```bash
cd <my directory e.g. myprojects>/invenioilsui
npm start
```

Now visit https://127.0.0.1:3000. You should now see the InvenioILS website.

## Recreate the demo data from scratch

You can recreate the demo data whenever you need. WARNING: this process will destroy any data or user that you have created or modified.

1. Make sure all services are up and running
2. Run again `./scripts/server` in your virtualenv:

```bash
cd <my directory e.g. myprojects>/invenioils
workon invenioils
(invenioils)$ ./scripts/setup
```

## Advanced topics

### Vocabularies

Vocabularies are indexed using Elasticsearch and can be indexed from a JSON
source file. To manage vocabularies use the `ils vocabulary` CLI.

Some pre-defined vocabulary generators are available. To generate a JSON file
with a list of languages or countries use:

```bash
ils vocabulary generate languages -o languages.json
ils vocabulary generate countries -o countries.json
```

To add vocabularies from a JSON file use the `index` command:

```bash
ils vocabulary index json [file1.json, file2.json, ...]
```

To add custom vocabularies or modify the text or data of an existing vocabulary
use the same `index` command as above.

If you change the `key` attribute of a vocabulary or if you remove a vocabulary
you also need to remove it from Elasticsearch. Use the `delete` command to
remove a vocabulary:

```bash
ils vocabulary delete country  # remove all countries
ils vocabulary delete country --key CH  # remove only Switzerland
```

Example vocabularies are available in `invenio_app_ils/vocabularies/data`.

Vocabulary-specific configuration is available in `config.py` and `invenioConfig.js`.

### Develop React-invenio-app-ils as a npm linked library

1. Setup react-invenio-app-ils ready for development

```bash
cd <react-invenio-app-ils dir>
npm install
npm run build
```

2. Link the distribution (the scripts are already provided in package.json)
   and refresh on changes - it will build your dist folder

```bash
cd <react-invenio-app-ils dir>
npm link
npm run watch
```

3. Go to your app, where you specified react-invenio-app-ils as your dependency and link the locally developed react-invenio-app-il

```bash
cd <my-react-app>
npm install
npm link @inveniosoftware/react-invenio-app-ils
```

## Troubleshooting FAQ

### UI network errors

If you are seeing in your application UI errors:

```bash
Something went wrong
Network Error
```

You can find out more about the error by checking the console in your browser's developer tools.

Verify if:

1. The backend server is running correctly (the console showing no exceptions)
2. You have followed the installation guide
3. the CORS policy is disabled for your local instance (not for any production environments!), see documentation above
4. your browser has the exception for the https temporary certificate of the local instance, see documentation below

#### Adding the certificate to the browser exceptions

1. In your browser go to https://127.0.0.1:5000
2. You will see a warning about the certificate. You need to proceed to the website and agree for adding the certificate to the exceptions
3. Reload your UI
