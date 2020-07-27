# Quickstart

TODO

## Install

The installation process is composed of two parts: install and run Invenio backend, and install and run JS frontend (Single Page Application).
At the moment, InvenioILS is still under development. The following quickstart guide is to run InvenioILS in a development environment.

### Invenio backend

Clone the project repository from GitHub: <https://github.com/inveniosoftware/invenio-app-ils>.

First, create a [virtualenv](https://virtualenv.pypa.io/en/stable/installation/) using [virtualenvwrapper](https://virtualenvwrapper.readthedocs.io/en/latest/install.html)
in order to sandbox our Python environment for development:

```bash
mkvirtualenv my-site
```

Start all dependent services using docker-compose (this will start PostgreSQL, Elasticsearch, RabbitMQ and Redis):

```bash
docker-compose up -d
```

!!! warning
Make sure you have [enough virtual memory](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html#docker-cli-run-prod-mode) for Elasticsearch in Docker.

Bootstrap the instance (this will install all Python dependencies and build all static assets):

```bash
./scripts/bootstrap
```

Next, create database tables, search indexes, message queues and demo data:

```bash
./scripts/setup
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

Navigate to your virtualenv, e.g. `~/.virtualenvs/invappils/var/instance`, and create a new file `invenio.cfg`:

```python
CORS_SEND_WILDCARD = False
CORS_SUPPORTS_CREDENTIALS = True
```

If you re-run the `setup` script and re-generate the demo data, you will have to update this value.

!!! note
Do not forget to restart the InvenioILS backend webserver if already running.

<http://localhost:3000/backoffice/locations>

#### Enable CSRF for development

If you have enabled the csrf check during development, you need to follow one of the below steps in order to be able to make it work:

1. Start the UI application [react-invenio-app-ils](https://github.com/inveniosoftware/react-invenio-app-ils) app with the command `npm run start:secure`. This will run the react application over `https` and the csrf cookie will be set corectly.

2. In case you run the UI application over `http` then you will need to add in the [config.py](https://github.com/inveniosoftware/invenio-app-ils/blob/master/invenio_app_ils/config.py) file of invenio-app-ils the following:

```bash
    CSRF_FORCE_SECURE_REFERRER = False
    SESSION_COOKIE_SECURE = False
```

### UI frontend

Clone the project repository from GitHub: <https://github.com/inveniosoftware/react-invenio-app-ils>.
Then, install the `npm` dependencies.

```bash
npm install
```

## Run

The easiest way to run and develop is to run separately Invenio, for REST APIs, and the UI app using the npm web development server.

### Invenio backend

Start the Invenio backend web server (remember to have the virtualenv activated):

```bash
cd invenio-app-ils
./scripts/server
```

Start the celery worker:

```bash
celery worker -A invenio_app.celery -l INFO
```

### UI

The user interface is a single page React application created using [create-react-app](https://facebook.github.io/create-react-app/).

```bash
cd react-invenio-app-ils
npm start
```

## Testing

Run the backend tests, run:

```bash
./run-tests.sh
```

For the frontend tests:

```bash
cd ui
npm test
```

## Developers documentation

You can build the documentation with:

```bash
python setup.py build_sphinx
```

## Vocabularies

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

## Develop React-invenio-app-ils as a npm linked library

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
3. the CORS policy is disabled for your local instance (not for any production environments!): [check backend installation tutorial](###Invenio backend)
4. your browser has the exception for the https temporary certificate of the local instance.

#### Adding the certificate to the browser exceptions:

1. In your browser go to:
   `localhost:5000/`
2. You will see a warning about the certificate. You need to proceed to the website and agree for adding the certificate to the exceptions
3. Reload your UI.

## Demo data

TODO
