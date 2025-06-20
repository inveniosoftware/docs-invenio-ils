# Scaffold

## Initializing a project

Initializing a project is done with the [Invenio CLI](http://127.0.0.1:8000/reference/cli/)

``` bash
invenio-cli init ils -c <version>
```
It creates the necessary files and folders for your InvenioILS instance.


Hereby, ``<version>`` should be replaced with the version you want to install, e.g.:
``` bash
invenio-cli init ils -c v4.5.0
```
Available versions can be found [here](https://github.com/inveniosoftware/cookiecutter-invenio-ils/branches/all).



### Variables

The CLI requests the following variables:

- **Project name**: Title of your project with space allowed (project name for humans)
- **Project short name**: Hyphenated and lowercased title (project name for machines)
- **Project website**: URL where the project will be deployed
- **GitHub repository**: Repository in format `<owner>/<code repository>`
    - **Description**: Short description of project
- **Author name**: Your name or that of your organization
- **Author email**: Email for communication
- **Year**: The current year
- **Python version**: 3.7 (default), 3.7, 3.8, or 3.9.
    - **Database**: PostgreSQL.
    - **Elasticsearch version**: 7.
    - **Storage backend**: Local file system.

It also generates a test private key which is needed for SSL support in the development server.


## Project structure

An overview of the generated files and folders:

| Name | Description |
|---|---|
| ``docker`` | Example configuration for NGINX and uWSGI. Consists Dockerfiles for building backend and frontend docker images. |
| ``templates`` | Folder for your Jinja templates. |
| ``ui`` | Web assets (CSS, JavaScript, LESS, JSX templates) used in the Webpack build. |
| ``vocabularies`` | Folder for vocabularies (mappings, schemas, etc). |
| ``docker-compose.full.yml`` | Example of a full infrastructure stack (DO NOT use in production!) |
| ``docker-compose.yml`` | Backend services needed for local development. |
| ``docker-services.yml`` | Common services for the Docker Compose files. |
| ``invenio.cfg`` | The Invenio application configuration. |
| ``Pipfile`` | Python requirements installed via [pipenv](https://pipenv.pypa.io) |
| ``Pipfile.lock`` | Locked requirements (generated on first install). |


#### Notes and known issues

- You may be prompted with `You've downloaded /home/<username>/.cookiecutters/cookiecutter-invenio-ils before. Is it okay to delete and re-download it? [yes]:`. Press `[Enter]` in that case. This will download the latest cookiecutter template.

- Some OpenSSL versions display an error message when obtaining random numbers, but this has no incidence (as far as we can tell) on functionality. We are investigating a possible solution to raise less eyebrows for appearance sake.
