## Prerequisites

The steps listed in this article require an existing local installation of InvenioILS v5.

!!! warning "Backup"

    Always backup your database, statistics indices and files before you try to perform an upgrade.

## Upgrade Steps

### Upgrade to v6.0

#### (Optional) Read-Only Backoffice Access

Version 6.0 introduces read-only backoffice access through a new access action: `ils-backoffice-readonly-access`

Users or roles with this action can view all backoffice resources without the ability to create, update, or delete records.
For more details see [Managing access](../../reference/access_and_restrictions.md).

For instructions on creating users, roles, and tokens with this access action, see the [CLI Users & Authentication reference](../../reference/cli/users-authentication.md).

### Upgrade to v6.1
!!! warning Steps required before updating 

    The following steps should be performed before upgrading invenio-app-ils to v6.1.0

Version 6.1 introduces new statistics for record changes.
For them to work correctly, search templates need to be created before the indices are.
Thus, the following steps should be performed before upgrading `invenio-app-ils` to v6.1.0.

#### Verify the templates don't already exist

```
GET _template/ils-record-changes-v1
```

```
GET _template/aggr-ils-record-changes-v1
```

#### Create the new templates

```
PUT _template/ils-record-changes-v1
{
    "order": 0,
    "index_patterns": [
        "events-stats-ils-record-changes-*"
    ],
    "settings": {
        "index": {
        "refresh_interval": "5s"
        }
    },
    "mappings": {
        "numeric_detection": false,
        "dynamic": false,
        "date_detection": false,
        "properties": {
        "unique_id": {
            "type": "keyword"
        },
        "method": {
            "type": "keyword"
        },
        "updated_timestamp": {
            "type": "date"
        },
        "user_id": {
            "type": "keyword"
        },
        "pid_type": {
            "type": "keyword"
        },
        "aggregation_id": {
            "type": "keyword"
        },
        "timestamp": {
            "type": "date"
        }
        }
    },
    "aliases": {
        "events-stats-ils-record-changes": {}
    }
}
```

```
PUT _template/aggr-ils-record-changes-v1
{
    "order": 0,
    "index_patterns": [
      "stats-ils-record-changes-*"
    ],
    "settings": {
      "index": {
        "refresh_interval": "5s"
      }
    },
    "mappings": {
      "numeric_detection": false,
      "dynamic": false,
      "date_detection": false,
      "properties": {
        "method": {
          "type": "keyword"
        },
        "updated_timestamp": {
          "type": "date"
        },
        "user_id": {
          "type": "keyword"
        },
        "count": {
          "type": "integer"
        },
        "pid_type": {
          "type": "keyword"
        },
        "aggregation_id": {
          "type": "keyword"
        },
        "timestamp": {
          "type": "date"
        }
      }
    },
    "aliases": {
      "stats-ils-record-changes": {}
    }
}
```

#### Verify the templates have been registered correctly

```
GET _template/ils-record-changes-v1
```

```
GET _template/aggr-ils-record-changes-v1
```

#### (Opional) Create a test document to see whether the templates work


To see that the alias returns no documents
```
GET events-stats-ils-record-changes/_search
{
    "query": {
        "match_all": {}
    }
}
```

Create a test document in a test index
```
PUT events-stats-ils-record-changes-test/_doc/1
{
  "unique_id": "test",
  "method": "insert",
  "updated_timestamp": "2020-11-10T10:00:00Z",
  "user_id": "test",
  "pid_type": "test_book",
  "aggregation_id": "test_agg",
  "timestamp": "2020-11-10T10:00:00Z"
}
```

This should show the test document
```
GET events-stats-ils-record-changes/_search
{
    "query": {
        "match_all": {}
    }
}
```

Delete the index that was created for the test
```
DELETE events-stats-ils-record-changes-test
```


#### Upgrade InvenioILS
Now upgrade `invenio-app-ils` to v6.1.0.
