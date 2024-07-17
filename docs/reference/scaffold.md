# Scaffold

Now that you have Invenio-CLI [installed](cli.md), we will use it to scaffold a new instance of InvenioILS.

## Initialize project

First, we need to create the project - the necessary files and folders for your InvenioILS instance.

The CLI will require the following data:

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

It will also generate a test private key which is needed for SSL support in the development server.

Let's do it! Pressing `[Enter]` selects the option in brackets `[]`.

``` bash
invenio-cli init ils -c <version>
```

Where ``<version>`` should be replaced with the version you want to install, e.g.:
``` bash
invenio-cli init ils -c v4.0.0
```

``` console
Initializing ILS application...
Running cookiecutter...


project_name [My Site]:
project_shortname [my-site]:
project_site [my-site.com]:
github_repo [my-site/my-site]:
description [My Site InvenioILS Instance]:
author_name [CERN]:
author_email [info@my-site.com]:
year [2022]:
Select python_version:
1 - 3.7
2 - 3.8
3 - 3.9
Choose from 1, 2, 3 [1]:
Select database:
1 - postgresql
Choose from 1 [1]:
Select search:
1 - elasticsearch7
Choose from 1 [1]: 
Select file_storage:
1 - local
Choose from 1 [1]:
Select development_tools:
1 - yes
2 - no
Choose from 1, 2 [1]:
-------------------------------------------------------------------------------

Generating SSL certificate and private key for testing....
Generating a 4096 bit RSA private key
......................................................................................++
.............................................++
writing new private key to 'docker/backend/test.key'
-----
Generating a 4096 bit RSA private key
............................................................................................................................................................................................++
........++
writing new private key to 'docker/frontend/test.key'
-----
-------------------------------------------------------------------------------
```

## Project structure

You can now inspect the generated project structure:

```
cd my-site
ls -a1
```

```console
.
..
.DS_Store
Pipfile
README.md
docker
docker-compose.full.yml
docker-compose.yml
docker-services.yml
invenio.cfg
setup.sh
templates
translations
ui
vocabularies
```

Following is an overview of the generated files and folders:

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
