## Prerequisites

The steps listed in this article require an existing local installation of InvenioRDM v12.

!!! warning "Backup"

    Always backup your database, statistics indices and files before you try to perform an upgrade.

!!! info "Older Versions"
    If your InvenioRDM installation is older than v12, you must first upgrade to v12 before proceeding with the steps in this guide.

## Upgrade Steps

Make sure you have the latest `invenio-cli` installed. For InvenioILS v5,
it should be v1.9.0+.

```bash
$ invenio-cli --version
invenio-cli, version 1.9.0
```

!!! info "Virtual environments"

    In case you are not inside a virtual environment, make sure that you prefix each `invenio`
    command with `pipenv run`.

### Upgrade InvenioILS

#### Requirements
Python 3.9 or 3.11 or 3.12 is required to run InvenioILS v13.

!!! info "Python 3.9 end-of-life"
    Official support for Python 3.9 will end on October 31, 2025.
    See the [official Python version status page](https://devguide.python.org/versions/) for more information.
    Future releases of InvenioRDM will require a more recent Python version.

The minimum required OpenSearch version is now **v2.12**. See [below](#opensearch-version) on how to upgrade older versions.


#### Upgrade

##### Step 1

- create a new virtual environment
- activate your new virtual environment
- install `invenio-cli` by running `pip install invenio-cli`
##### Step 2

Update the `<my-site>/Pipfile` by changing the `version` of `invenio-app-ils` to `~=5.0.0` and removing the unnecessary `postgresql` extra
(it is already installed by default and will trigger a warning if left in the file):

```diff
[packages]
---invenio-app-ils = {extras = [..., "postgresql"], version = "~4.4.0"}
+++invenio-app-ils = {extras = [...], version = "~=5.0.0"}
```

If you're using [Sentry](https://sentry.io) (tool for monitoring or error tracking), update the dependency in `<my-site>/Pipfile` to:

```diff
---invenio-logging = {extras = ["sentry_sdk"], version = "~=2.0"}
+++sentry-sdk = {extras = ["flask"], version = ">=1.0.0,<2.0.0"}
```

##### Step 3

Update the `Pipfile.lock` file:

```bash
invenio-cli packages lock
```

##### Step 4
Add the following env variable to your instance:
```
INVENIO_SITE_API_URL: '<your site URL>/api'
```

##### Step 5

Install InvenioILS v5:

```bash
invenio-cli install
```

### Activate the virtual environment

Before running any `invenio` commands, activate your virtual environment shell:

```bash
$ invenio-cli shell
Launching subshell in virtual environment...
source <path to virtualenvs>/bin/activate
```

This step ensures that all subsequent commands use the correct Python environment and installed dependencies.

!!! note
    If you are upgrading in an environment that does not use a Python virtualenv, you can skip this step.

### Database migration

Prepare the `userprofiles_userprofile` DB table data for seamless migration (the table will be moved to invenio_accounts). 


!!! warning "SQL QUERIES"

    Apply this change only if your `username` column of `userprofiles_userprofile` table was not populated initially.

```sql
UPDATE userprofiles_userprofile SET username = (SELECT up.displayname FROM userprofiles_userprofile up WHERE up.user_id = userprofiles_userprofile.user_id) WHERE username is null;
```

Escape apostrophes in the users' names:

```sql
UPDATE userprofiles_userprofile SET full_name = REPLACE(full_name, '''', '''''') WHERE full_name LIKE '%''%';
```

Execute the database migration:

```bash
invenio alembic stamp 145402e8523a
invenio alembic upgrade
```

