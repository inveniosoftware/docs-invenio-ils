# Configuration Variables

This document provides a comprehensive list and explanation of the configuration variables available in the `invenio-app-ils` backend. These variables can be set in the configuration file(s) to customize the behavior of your Invenio ILS application.

## REST Configurations

### `ILS_RECORDS_REST_ENDPOINTS`

REST endpoints for various record types.

```python
ILS_RECORDS_REST_ENDPOINTS = {
    'books': {
        'pid_type': 'bookid',
        'path': '/books',
        'default_media_type': 'application/json',
    },
    'members': {
        'pid_type': 'memberid',
        'path': '/members',
        'default_media_type': 'application/json',
    },
}
```

### `ILS_MAILS_TEMPLATES`

Paths to email templates used for various notifications.

```python
ILS_MAILS_TEMPLATES = {
    'loan_due': 'invenio_app_ils/loans/email/loan_due.html',
    'loan_overdue': 'invenio_app_ils/loans/email/loan_overdue.html',
}
```

## Circulation Configuration

### `CIRCULATION_LOAN_TRANSITIONS`

A dictionary defining the possible transitions for loans.

```python
CIRCULATION_LOAN_TRANSITIONS = {
    'CREATED': ['PENDING'],
    'PENDING': ['ITEM_ON_LOAN', 'CANCELLED'],
    'ITEM_ON_LOAN': ['RETURNED'],
    'RETURNED': [],
    'CANCELLED': [],
}
```

For detailed documentation for circulation sub-module, refer to [invenio-circulation](https://invenio-circulation.readthedocs.io/en/latest/).

## Debug Configuration

### DEBUG (True/False)

Enable or disable debugging mode.

### DEBUG_TB_ENABLED (True/False)

Enable or disable the debug toolbar.

### DEBUG_TB_INTERCEPT_REDIRECTS (True/False)

Enable or disable intercepting redirects in the debug toolbar.

## Rate Limiting Configuration

### RATELIMIT_STORAGE_URL

Storage URL for the rate limiter.

```python
RATELIMIT_STORAGE_URL = "redis://localhost:6379/3"
```

### RATELIMIT_AUTHENTICATED_USER

Rate limit for authenticated users.

```python
RATELIMIT_AUTHENTICATED_USER = "5000 per hour;150 per minute"
```

### RATELIMIT_GUEST_USER

Rate limit for non-authenticated users.

```python
RATELIMIT_GUEST_USER = "1000 per hour;100 per minute"
```

## Internationalization (I18N) Configuration

### BABEL_DEFAULT_LANGUAGE

Default language setting.

```python
BABEL_DEFAULT_LANGUAGE = "en"
```

### BABEL_DEFAULT_TIMEZONE

Default timezone setting.

```python
BABEL_DEFAULT_TIMEZONE = "Europe/Zurich"
```

## Notifications Configuration

### ILS_NOTIFICATIONS_BACKENDS_BUILDER

Factory function to use when sending notifications.

```python
ILS_NOTIFICATIONS_BACKENDS_BUILDER = (
    "invenio_app_ils.notifications.backends:notifications_backend_builder"
)
```

### ILS_NOTIFICATIONS_MSG_BUILDER

Notification message creator.

```python
ILS_NOTIFICATIONS_MSG_BUILDER = (
    "invenio_app_ils.notifications.messages:notification_msg_builder"
)
```

### ILS_NOTIFICATIONS_TEMPLATES

Override default global common templates.

```python
ILS_NOTIFICATIONS_TEMPLATES = {"footer": "footer.html"}
```

### ILS_NOTIFICATIONS_MSG_BUILDER_DOCUMENT_REQUEST

Notification message creator for document requests notifications.

```python
ILS_NOTIFICATIONS_MSG_BUILDER_DOCUMENT_REQUEST = "invenio_app_ils.document_requests.notifications.messages:notification_document_request_msg_builder"
```

### ILS_NOTIFICATIONS_TEMPLATES_DOCUMENT_REQUEST

Override default document requests templates.

```python
ILS_NOTIFICATIONS_TEMPLATES_DOCUMENT_REQUEST = {}
```

### ILS_NOTIFICATIONS_FILTER_DOCUMENT_REQUEST

Function to select and filter which notifications should be sent.

```python
ILS_NOTIFICATIONS_FILTER_DOCUMENT_REQUEST = document_request_notification_filter
```

## Email Configuration

### SUPPORT_EMAIL

Email address for support.

```python
SUPPORT_EMAIL = "info@example.com"
```

### MAIL_SUPPRESS_SEND (True/False)

Disable email sending by default.

### MAIL_NOTIFY_SENDER

Email address for email notification sender.

```python
MAIL_NOTIFY_SENDER = "noreply@example.com"
```

### MAIL_NOTIFY_CC (list)

Email CC address(es) for email notifications.

### MAIL_NOTIFY_BCC (list)

Email BCC address(es) for email notifications.

### ILS_MAIL_ENABLE_TEST_RECIPIENTS (True/False)

Enable or disable sending mail to test recipients.

### ILS_MAIL_NOTIFY_TEST_RECIPIENTS (list)

When `ILS_MAIL_ENABLE_TEST_RECIPIENTS` is True, all emails are sent here.

```python
ILS_MAIL_NOTIFY_TEST_RECIPIENTS = ["john.doe@example.com"]
```

## Assets Configuration

### COLLECT_STORAGE

Static files collection method (defaults to copying files).

```python
COLLECT_STORAGE = "flask_collect.storage.file"
```

## Accounts Configuration

For accounts configuration, refer to the [flask-security](https://github.com/inveniosoftware/flask-security-fork) and [invenio-accounts](https://invenio-accounts.readthedocs.io/en/latest/) documentation.

Here's the continuation of the comprehensive documentation for the provided Python config file in Markdown format:

## Celery Configuration

### CELERY_BROKER_URL

URL for the Celery message broker (default: RabbitMQ).

### CELERY_RESULT_BACKEND

URL for the Celery result backend (default: Redis).

### CELERY_BEAT_SCHEDULE

Scheduled tasks configuration for Celery (cronjobs).

Example:

```python
CELERY_BEAT_SCHEDULE = {
    "indexer": {
        "task": "invenio_indexer.tasks.process_bulk_queue",
        "schedule": timedelta(minutes=5),
    },
    "send_overdue_loan_reminders": {
        "task": "invenio_app_ils.circulation.notifications.tasks.send_overdue_loans_notification_reminder",
        "schedule": crontab(minute=0, hour=2),
    },
    "stats-aggregate-events": {
        "task": "invenio_stats.tasks.aggregate_events",
        "schedule": timedelta(hours=3),
        "args": [("record-view-agg", "file-download-agg")],
    },
}
```

## Feature Configurations

### EXTEND_LOANS_LOCATION_UPDATED (True/False)

Flag to indicate whether to start a task to update active loans when closures of a location are updated.

### EXTEND_LOANS_SCHEDULE_TIME

Time at which the task to extend loans should be run.

```python
EXTEND_LOANS_SCHEDULE_TIME = datetime.time(2)
```

### ILS_SELF_CHECKOUT_ENABLED (True/False)

Enable or disable Self-Checkout feature endpoint.

## Database Configuration

### SQLALCHEMY_DATABASE_URI

Database URI including user and password.

```python
SQLALCHEMY_DATABASE_URI = "postgresql+psycopg2://test:psw@localhost/ils"
```

## JSONSchemas Configuration

### JSONSCHEMAS_HOST

Hostname used in URLs for local JSONSchemas.

```python
JSONSCHEMAS_HOST = "127.0.0.1:5000"
```

## CSRF Configuration

### REST_CSRF_ENABLED (True/False)

Enable or disable CSRF protection for REST APIs.

## CORS Configuration

### REST_ENABLE_CORS (True/False)

Enable or disable CORS support for REST APIs.

### CORS_SEND_WILDCARD (True/False)

Allow or disallow credentials to be sent with CORS requests.

### CORS_SUPPORTS_CREDENTIALS (True/False)

Exable or disable supporting credentials for CORS requests.

## Flask Configuration

### SECRET_KEY

Secret key used for session management and CSRF protection.

### MAX_CONTENT_LENGTH

Maximum allowed size for uploaded files via form data.

```python
MAX_CONTENT_LENGTH = 100 * 1024 * 1024  # 100 MiB
```

### SESSION_COOKIE_SECURE (True/False)

Set cookie with the secure flag by default.

### SESSION_COOKIE_SAMESITE

Set SameSite attribute for session cookies.

```python
SESSION_COOKIE_SAMESITE = "Lax"
```

### APP_ALLOWED_HOSTS

List of allowed hosts for the application.

```python
APP_ALLOWED_HOSTS = ["localhost", "127.0.0.1"]
```

### SPA_HOST

Host URL for Single Page Application.

```python
SPA_HOST = "https://127.0.0.1:3000"
```

### SPA_PATHS

Paths and placeholders for Single Page Application routes.

```python
SPA_PATHS = dict(
    literature="/literature/%(pid)s",
    loan="/backoffice/loans",
    patron="/backoffice/patrons",
    profile="/profile",
    search="/search?q=%(querystring)s",
)
```

Here's the continuation and completion of the configuration file documentation in Markdown format:

## Records REST Configuration

### RECORDS_REST_MAX_RESULT_WINDOW

Maximum result window for Records REST endpoints.

```python
RECORDS_REST_MAX_RESULT_WINDOW = 10000
```

### RECORDS_REST_VOCAB_MAX_RESULT_WINDOW

Maximum result window for vocabulary Records REST endpoints.

```python
RECORDS_REST_VOCAB_MAX_RESULT_WINDOW = 500
```

### PIDSTORE_RECID_FIELD

Field name in the PID store for the record identifier.

```python
PIDSTORE_RECID_FIELD = "pid"
```

### REST_MIMETYPE_QUERY_ARG_NAME

Name of the URL argument to choose response serializer.

```python
REST_MIMETYPE_QUERY_ARG_NAME = "format"
```

### RECORDS_REST_ENDPOINTS

Dictionary defining the endpoints for Records REST API.

```python
RECORDS_REST_ENDPOINTS = {
    "docid": {
        "pid_type": DOCUMENT_PID_TYPE,
        "pid_minter": DOCUMENT_PID_MINTER,
        "pid_fetcher": DOCUMENT_PID_FETCHER,
        "search_class": DocumentSearch,
        "record_class": Document,
        "indexer_class": DocumentIndexer,
        "search_factory_imp": "invenio_app_ils.search_permissions:ils_search_factory",
        "record_loaders": {
            "application/json": "invenio_app_ils.documents.loaders:document_loader"
        },
        "record_serializers": {
            "application/json": "invenio_app_ils.literature.serializers:json_v1_response"
        },
        "search_serializers": {
            "application/json": "invenio_app_ils.literature.serializers:json_v1_search",
            "text/csv": "invenio_app_ils.literature.serializers:csv_v1_search",
        },
        "search_serializers_aliases": {
            "csv": "text/csv",
            "json": "application/json",
        },
        "list_route": "/documents/",
        "item_route": "/documents/<{0}:pid_value>".format(doc_pid_converter()),
        "default_media_type": "application/json",
        "max_result_window": RECORDS_REST_MAX_RESULT_WINDOW,
        "error_handlers": {},
        "read_permission_factory_imp": record_read_permission_factory,
        "list_permission_factory_imp": allow_all,
        "create_permission_factory_imp": backoffice_permission,
        "update_permission_factory_imp": backoffice_permission,
        "delete_permission_factory_imp": backoffice_permission,
    },
    # Similar structure as above for other endpoints below
    "pitmid": {...},
    "eitmid": {...},
    "locid": {...},
    "serid": {...},
    "dreqid": {...},
    "vocid": {...},
    "litid": {...},
}
```

For a detailed configuration reference, refer to [invenio-records-rest](https://invenio-records-rest.readthedocs.io/en/latest/).

### RECORDS_REST_SORT_OPTIONS

Dictionary defining sort options for Records REST endpoints.

```python
RECORDS_REST_SORT_OPTIONS = {
    "document_requests": {
        "created": {
            "fields": ["_created"],
            "title": "Recently added",
            "order": 1,
        },
        "bestmatch": {
            "fields": ["-_score"],
            "title": "Best match",
            "order": 2,
        },
        # Additional sort options for document requests
    },
    "documents": {...},
    "eitems": {...},
    "items": {...},
    "patrons": {...},
    "series": {...},
}
```

## Facets Configuration

### RECORDS_REST_DEFAULT_RESULTS_SIZE

Number of records to fetch by default.

### FACET_TAG_LIMIT

Number of tags to display in the facets.

### RECORDS_REST_FACETS

Disctionary defining facets for Records REST endpoints.

```python
dict(
    documents=dict(
        aggs=dict(
            tag=dict(terms=dict(field="tags", size=FACET_TAG_LIMIT)),
            doctype=dict(terms=dict(field="document_type")),
            availability=dict(
                range=dict(
                    field="circulation.available_items_for_loan_count",
                    ranges=[{"key": "on shelf", "from": 1}],
                ),
                aggs={
                    "zero_doc_count_filter": {
                        "bucket_selector": {
                            "buckets_path": {"count": "_count"},
                            "script": "params.count > 0",
                        }
                    }
                },
            ),
        ),
        post_filters=dict(
            tag=terms_filter("tags"),
            doctype=terms_filter("document_type"),
            availability=keyed_range_filter(
                "circulation.available_items_for_loan_count",
                {"on shelf": {"gt": 0}},
            ),
        ),
    ),
    # Similar structure as above for other endpoints below
    document_requests=dict(...),
    series=dict(...),
    items=dict(...),
    eitems=dict(...),
)
```

### ILS_VIEWS_PERMISSIONS_FACTORY = views_permissions_factory

Permissions factory for ILS views to handle all ILS actions.

```python
ILS_VIEWS_PERMISSIONS_FACTORY = views_permissions_factory
```

### ILS_INDEXER_TASK_DELAY

Trigger delay for celery tasks to index referenced records.

```python
ILS_INDEXER_TASK_DELAY = timedelta(seconds=2)
```

## Stats Configuration

For detailed documentation on stats, refer to [invenio-stats](https://github.com/inveniosoftware/invenio-stats).

## ILS Configuration

### ILS_VOCABULARIES (list)

List of available vocabularies.

### ILS_VOCABULARY_SOURCES

Dictionary defining metadata for the vocabularies.

```python
ILS_VOCABULARY_SOURCES = {
    "json": "invenio_app_ils.vocabularies.sources:json_source",
    "opendefinition": (
        "invenio_app_ils.vocabularies.sources:opendefinition_source"
    ),
}
```

### OPENDEFINITION_JSONRESOLVER_HOST

Host URL for opendefinition license for jsonresolvers.

### FILES_REST_PERMISSION_FACTORY

Factory function for defining permissions for file upload.

### ILS_RECORDS_EXPLICIT_PERMISSIONS_ENABLED (True/False)

Enable records restrictions by `_access` field.

When enabled, it allows to define explicit permissions for each record to
provide read access to specific users or roles.
When disabled, it will avoid checking for user ids and roles on each search
query and record fetch.

### ILS_LITERATURE_COVER_URLS_BUILDER

Default implementation for building cover urls in document serializer.

### ILS_RECORDS_METADATA_NAMESPACES

Namespaces for fields added to the metadata schema.

### ILS_RECORDS_METADATA_EXTENSIONS

Fields added to the metadata schema.

### ILS_PATRON_ANONYMOUS_CLASS and ILS_PATRON_SYSTEM_AGENT_CLASS

Define the class for the Anonymous and SystemAgent patrons.

```python
ILS_PATRON_ANONYMOUS_CLASS = AnonymousPatron
ILS_PATRON_SYSTEM_AGENT_CLASS = SystemAgent
```

## Notes

- This list includes only a subset of all available configuration variables. For a complete list, refer to the official Invenio App ILS documentation or source code.
- Replace example values with actual values suitable for your instance.
- Ensure to restart the application after modifying configuration variables for changes to take effect.
