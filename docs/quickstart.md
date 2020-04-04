# Quickstart

TODO

## Install

First, create a `virtualenv <https://virtualenv.pypa.io/en/stable/installation/>`_
using `virtualenvwrapper <https://virtualenvwrapper.readthedocs.io/en/latest/install.html>`_
in order to sandbox our Python environment for development:

```console
    $ mkvirtualenv my-site
```

Start all dependent services using docker-compose (this will start PostgreSQL, Elasticsearch, RabbitMQ and Redis):

```console
    $ docker-compose up -d
```

.. note::

    Make sure you have `enough virtual memory
    <https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html#docker-cli-run-prod-mode>`_
    for Elasticsearch in Docker:

    .. code-block:: shell

        # Linux
        $ sysctl -w vm.max_map_count=262144

        # macOS
        $ screen ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/tty
        <enter>
        linut00001:~# sysctl -w vm.max_map_count=262144


Next, bootstrap the instance (this will install all Python dependencies and
build all static assets):

```console
    $ ./scripts/bootstrap
```

Next, create database tables, search indexes and message queues:

```console
    $ ./scripts/setup
```

## Run

Start the webserver:

```console
    $ ./scripts/server
```

Start the a background worker:

```console
    $ celery worker -A invenio_app.celery -l INFO
```

Start a Python shell:

```console
    $ ./scripts/console
```

TODO: add UI

## Testing

Run the test suite via the provided script:

```console

    $ ./run-tests.sh

## Developers documentation

You can build the documentation with:

```console

    $ python setup.py build_sphinx

## Development

### UI

The user interface is a standalone React application created using [create-react-app](https://facebook.github.io/create-react-app/).
The easiest development setup consists in starting separately Invenio, for REST APIs, and the React app using the
create-react-app webserver.

First of all, you have to create your own personal access token, to be able to GET or POST data to the API:

* start the backend server:

    ```console

        $ ./scripts/server

* start the ui server:

    ```console

        $ cd ./ui && npm start

* If you run invenio in an port other than `5000` you need to run the below commands:

    ```console

        $ echo 'REACT_APP_BACKEND_DEV_BASE_URL=https://localhost:<your-new-port>' > ./invenio_app_ils/ui/.env.development
        $ echo 'REACT_APP_BACKEND_DEV_BASE_URL=https://localhost:<your-new-port>' > ./invenio_app_ils/ui/.env.test


* | since the React app is server under a different port (normally, :3000), you
  | need to configure Invenio to allow requests from different domains. In your
  | virtual environment navigate to ``~/.virtualenvs/ils/var/instance``, if there
  | is no file ``invenio.cfg`` create one and add the following configuration,
  | which will override the existing configuration we have in ``config.py``

    .. code-block:: python

        CORS_SEND_WILDCARD = False
        CORS_SUPPORTS_CREDENTIALS = True

## Vocabularies

Vocabularies are indexed using Elasticsearch and can be indexed from a JSON
source file. To manage vocabularies use the ``ils vocabulary`` CLI.

Some pre-defined vocabulary generators are available. To generate a JSON file
with a list of languages or countries use:

    ```console

        ils vocabulary generate languages -o languages.json
        ils vocabulary generate countries -o countries.json

To add vocabularies from a JSON file use the ``index`` command:

    ```console

        ils vocabulary index json [file1.json, file2.json, ...]

To add custom vocabularies or modify the text or data of an existing vocabulary
use the same ``index`` command as above.

If you change the ``key`` attribute of a vocabulary or if you remove a vocabulary
you also need to remove it from Elasticsearch. Use the ``delete`` command to
remove a vocabulary:

    ```console

        ils vocabulary delete country  # remove all countries
        ils vocabulary delete country --key CH  # remove only Switzerland

Example vocabularies are available in ``invenio_app_ils/vocabularies/data``.

Vocabulary-specific configuration is available in ``config.py`` and ``invenioConfig.js``.

## Demo data

TODO
