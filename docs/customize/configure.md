# Configuration Variables

This document provides a comprehensive list and explanation of the configuration variables available in the [invenio-app-ils](https://github.com/inveniosoftware/invenio-app-ils) module. These variables can be set in the configuration file(s) to customize the behavior of your InvenioILS application.

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

## Internationalization (I18N) Configuration

### BABEL_DEFAULT_LANGUAGE

Default language setting.

```python
BABEL_DEFAULT_LANGUAGE = "en"
```

> **Disclamer:** The software currently is available only in ENGLISH.

### BABEL_DEFAULT_TIMEZONE

Default timezone setting.

```python
BABEL_DEFAULT_TIMEZONE = "Europe/Zurich"
```

## Accounts Configuration

For accounts configuration, refer to the [flask-security](https://github.com/inveniosoftware/flask-security-fork) and [invenio-accounts](https://invenio-accounts.readthedocs.io/en/latest/) documentation.

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

Enable or disable Self-Checkout feature.

## JSONSchemas Configuration

### JSONSCHEMAS_HOST

Hostname used in URLs for local JSONSchemas.

```python
JSONSCHEMAS_HOST = "127.0.0.1:5000"
```

## CSRF Configuration

### REST_CSRF_ENABLED (True/False)

Enable or disable CSRF protection for REST APIs.

---

> **The following configurations are for customizing the way you make your application secure, it is advised to not modify them if in doubt.**

---

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
**Note:** This variable should store a secure key when your website goes to production!

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

### REST_MIMETYPE_QUERY_ARG_NAME

Name of the URL argument to choose response serializer.

```python
REST_MIMETYPE_QUERY_ARG_NAME = "format"
```

### RECORDS_REST_ENDPOINTS

Dictionary defining the endpoints for Records REST API.

> The following configurations can be modified if you want to customise the Record behaviour by updating the classes, note that these require some advanced developer experience. You can also customise permissions policy for your resources.

```python
RECORDS_REST_ENDPOINTS = {
    "docid": {
        "search_class": DocumentSearch,
        "record_class": Document,
        "indexer_class": DocumentIndexer,
        "search_factory_imp": "invenio_app_ils.search_permissions:ils_search_factory",
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

Dictionary defining sort options for Records REST endpoints. Sort options set here will be displayed in the search pages.

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

Disctionary defining facets (search filters visible on the left hand side of search pages) for Records REST endpoints.

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

## Stats Configuration

For detailed documentation on stats, refer to [invenio-stats](https://github.com/inveniosoftware/invenio-stats).

## ILS Configuration

### ILS_VOCABULARIES (list)

List of available vocabularies.

```python
ILS_VOCABULARIES = [
    "alternative_title_type",
    "author_identifier_scheme",
    "author_type",
    "country",
    "currencies",
    "doc_req_payment_method",
    "doc_subjects",
    "eitem_sources",
    "item_medium",
    "language",
    "license",
    "series_identifier_scheme",
    "tag",
]
```

> You can ceate new vocabularies and them to the list, note that this requires some advanced developer experience.

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

### FILES_REST_PERMISSION_FACTORY

Factory function for defining permissions for file upload.

### ILS_LITERATURE_COVER_URLS_BUILDER

Default implementation for building cover urls in document serializer.

### ILS_RECORDS_METADATA_EXTENSIONS

Fields added to the metadata schema with the key as the endpoint to add to.

```python
ILS_RECORDS_METADATA_EXTENSIONS = {
    "document": {
        "schema": Document._schema,
        "fields": {
            "new_field": {
                "elasticsearch": "long",
                "marshmallow": Integer(),
            },
        },
    },
}
```

## Advanced Configurations

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

### ILS_NOTIFICATIONS_MSG_BUILDER_DOCUMENT_REQUEST

Notification message creator for document requests notifications.

```python
ILS_NOTIFICATIONS_MSG_BUILDER_DOCUMENT_REQUEST = "invenio_app_ils.document_requests.notifications.messages:notification_document_request_msg_builder"
```

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

### ILS_NOTIFICATIONS_TEMPLATES_DOCUMENT_REQUEST

Override default document requests templates.

```python
ILS_NOTIFICATIONS_TEMPLATES_DOCUMENT_REQUEST = {"popup": "popup.html", "header": "header.html"}
```

### ILS_NOTIFICATIONS_FILTER_DOCUMENT_REQUEST

Function to select and filter which notifications should be sent. Possibility to filter out some emails, based on your needs.

```python
ILS_NOTIFICATIONS_FILTER_DOCUMENT_REQUEST = document_request_notification_filter
```

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

### COLLECT_STORAGE

Static files collection method (defaults to copying files).

```python
COLLECT_STORAGE = "flask_collect.storage.file"
```

## Configurations for Website Administrators

### SQLALCHEMY_DATABASE_URI

Database URI including user and password.

```python
SQLALCHEMY_DATABASE_URI = "postgresql+psycopg2://test:psw@localhost/ils"
```

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

### SPA_HOST

Host URL for Single Page Application.

```python
SPA_HOST = "https://127.0.0.1:3000"
```

## Notes

- This list includes only a subset of all available configuration variables. For a complete list, refer to the official InvenioILS documentation or source code.
- Replace example values with actual values suitable for your instance.
- Ensure to restart the application after modifying configuration variables for changes to take effect.
