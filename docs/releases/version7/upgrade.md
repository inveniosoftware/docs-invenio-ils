## Prerequisites

The steps listed in this article require an existing local installation of InvenioILS v6.

!!! warning "Backup"

    Always backup your database, statistics indices and files before you try to perform an upgrade.

## Upgrade Steps

### Upgrade to v7.0
!!! warning Steps required before updating 

    The following steps should be performed before upgrading invenio-app-ils to v6.1.0

Version 7.0 introduces new statistics for loans.
For them to work correctly, search templates need to be created and updated before the indices are.
Thus, the following steps should be performed before upgrading `invenio-app-ils` to v7.0.0.

#### Circulation Loan Index
Add the following mapping to the existing index named `loans-loan-v1.0.0-*`.

```
"extra_data": {
  "type": "object",
  "dynamic": true,
  "enabled": true
}
```

##### OpenSearch
This can be done in OpenSearch by navigating to the OpenSearch Dashboard > Index Management > Select the index > Mappings > JSON Editor.

#### Loan Transition Indices

##### Verify the templates don't already exist
```
GET _template/loan-transitions-v1.json
```

```
GET _template/aggr-loan-transitions-v1.json
```


##### Create the new templates
```
PUT _template/loan-transitions-v1.json
{
  "index_patterns": [
    "events-stats-loan-transitions-*"
  ],
  "settings": {
    "index": {
      "refresh_interval": "5s"
    }
  },
  "mappings": {
    "date_detection": false,
    "dynamic": false,
    "numeric_detection": false,
    "properties": {
      "timestamp": {
        "type": "date"
      },
      "updated_timestamp": {
        "type": "date"
      },
      "unique_id": {
        "type": "keyword"
      },
      "trigger": {
        "type": "keyword"
      },
      "pid_value": {
        "type": "keyword"
      },
      "extra_data": {
        "type": "object",
        "dynamic": true,
        "enabled": true
      }
    }
  },
  "aliases": {
    "events-stats-loan-transitions": {}
  }
}
```



```
PUT _template/aggr-loan-transitions-v1.json
{
  "index_patterns": [
    "stats-loan-transitions-*"
  ],
  "settings": {
    "index": {
      "refresh_interval": "5s"
    }
  },
  "mappings": {
    "date_detection": false,
    "dynamic": false,
    "numeric_detection": false,
    "properties": {
      "timestamp": {
        "type": "date"
      },
      "updated_timestamp": {
        "type": "date"
      },
      "trigger": {
        "type": "keyword"
      },
      "count": {
        "type": "integer"
      }
    }
  },
  "aliases": {
    "stats-loan-transitions": {}
  }
}
```

#### Upgrade InvenioILS
Now upgrade `invenio-app-ils` to v7.0.0.

#### (Optional) Add Stats to Loan Indfex

##### Create the indices
To create a new index extend a loan and process the events afetrwards with
cds-ils stats events process

##### Enable Stats Indexing Feature Flag
Enable the feature flag `ILS_EXTEND_INDICES_WITH_STATS_ENABLED = True` in your configuration.


##### Reindex Loans
```bash
invenio index reindex -t loanid
invenio index run
```

