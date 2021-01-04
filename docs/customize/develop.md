# Develop

At the moment, customization to InvenioILS requires changes to configuration or code in a local environment.
This step will be improved in the future.

This documentation will guide you on how to setup your local development environment.

The installation process is composed of two parts: install and run the Invenio backend, and install and run the JavaScript frontend (Single Page Application).

### Prerequisites

Make sure that you have installed the prerequisites above. You will now need to install:

* Python 3, at the moment we are using Python 3.6.
* [virtualenv](https://virtualenv.pypa.io/en/stable/installation.html#via-pip)) and [virtualenvwrapper](https://virtualenvwrapper.readthedocs.io/en/latest/install.html).
* [NodeJS](https://nodejs.org/en/download/) latest LTS release.

## Install

### Install Invenio backend

In the project folder, create a new Python `virtualenv`:

```bash
cd <my directory e.g. myprojects>/invenioils/invenioils
mkvirtualenv invenioils
```

Start all dependent services using docker-compose (this will start PostgreSQL, Elasticsearch, RabbitMQ and Redis):

```bash
docker-compose up -d
```

Bootstrap the instance (this will install all Python dependencies and build all static assets):

```bash
(invenioils)$ ./scripts/bootstrap
```

Next, create database tables, search indexes, message queues and demo data:

```bash
(invenioils)$ ./scripts/setup
```

The previous step created a set of demo data that allows to try the product. The demo users are mentioned above.

Since the InvenioILS web server is running on a different HTTP port (`:5000`) of the UI web server (`:3000`), we will have to tune Invenio configuration to allow HTTP requests from different domain (CORS). To do that, we override the default configuration via the `invenio.cfg` file:

1. Navigate to your virtualenv, e.g. `~/.virtualenvs/invenioils/`
2. create the needed folders: `mkdir -p var/instance`
3. create a new file `invenio.cfg` with the following content:

```bash
CORS_SUPPORTS_CREDENTIALS=True
```

### Install UI frontend

Clone the project repository from GitHub: <https://github.com/inveniosoftware/react-invenio-app-ils>.

```bash
cd <my directory e.g. myprojects>/invenioils
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
cd <my directory e.g. myprojects>/invenioils/invenioils
docker-compose up
```

### Run backend web server

Start the Invenio backend web server (remember to activate the virtualenv with the command `workon`). In a new terminal run:

```bash
cd <my directory e.g. myprojects>/invenioils/invenioils
workon invenioils
(invenioils)$ ./scripts/server
```

Start the celery worker. In a new terminal run:

```bash
cd <my directory e.g. myprojects>/invenioils/invenioils
workon invenioils
(invenioils)$ celery worker -A invenio_app.celery -l INFO
```

### Run frontend web server

The user interface is a single page React application created using [create-react-app](https://facebook.github.io/create-react-app/).
 In a new terminal run:

```bash
cd <my directory e.g. myprojects>/invenioils/invenioilsui
npm start
```

Now visit https://127.0.0.1:3000 (accept the self-signed certificate warning if proposed). You should now see the InvenioILS website.

#### Develop React-invenio-app-ils as a npm linked library

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

## Recreate the demo data from scratch

You can recreate the demo data whenever you need. WARNING: this process will destroy any data or user that you have created or modified.

1. Make sure all services are up and running
2. Run again `./scripts/setup` in your virtualenv:

```bash
cd <my directory e.g. myprojects>/invenioils/invenioils
workon invenioils
(invenioils)$ ./scripts/setup
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

### Browser certificate warning

The development server does not provide a valid HTTPS certificate. When opening the webpage of InvenioILS the first time, the browser will show you a warning: this is normal and expected for a local development environment.

1. In your browser go to https://127.0.0.1:5000
2. You will see a warning about the invalid certificate: at this step, you will have to add the development certificate as trusted (`Accept` button or `Proceed to 127.0.0.1 (unsafe)` link). This process varies depending on the browser.
3. Reload the webpage if needed.
