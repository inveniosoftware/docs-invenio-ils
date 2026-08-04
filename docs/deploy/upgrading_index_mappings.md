# Index mappings

## Context
InvenioILS uses OpenSearch to index its records allowing for faster searching. We use something called mappings to define how we want these indexes to match records that allows us to further customise the search.

The majority of the searches in InvenioILS use custom mappings to match certain things such as characters with or without accents (boson or bosón), however one part of it (the loans page in the backoffice) uses a module called Invenio-Circulation for which we cannot edit the mapping for this one in the codebase and it must be done live using cURL or the OpenSearch Dashboards developer tools.

## Setup
You must have either access to the OpenSearch Dashboards developer tools console (available at `http://127.0.0.1:5601/app/dev_tools#/console` by default for InvenioILS) or cURL through a terminal.

- Dashboard example query:
    `GET /loans-loan-v1.0.0/_mapping`

- cURL example query:
    `curl -X GET "https://127.0.0.1:9200/loans-loan-v1.0.0/_mapping?pretty"`

- Secured local cURL example query:
    `curl -X GET "https://127.0.0.1:9200/loans-loan-v1.0.0/_mapping?pretty" -u admin:admin -k`
  > **Note:** `-k` skips TLS certificate verification and `admin:admin` is the OpenSearch default
  > credential which is fine for a local dev instance but should be replaced with real
  > credentials and proper certificate verification before running against any shared or
  > production cluster.

The following placeholders will be used throughout the rest of the documentation but ensure you replace them with their actual value unique to you before executing the queries.

```
OLD_INDEX   -> the current real index name, e.g. loans-loan-v1.0.0-1785841481
NEW_INDEX   -> OLD_INDEX with a suffix, e.g. loans-loan-v1.0.0-1785841481-v2
```

## 1. Find current state of index
Confirm the mapping you're working from, and find every alias pointing at the index you're about to replace. Do not skip this — if you miss an alias here, that alias will silently keep pointing at the old (deleted) index after cleanup.

```json
GET /loans-loan-v1.0.0/_alias
```

With the result appearing in the following form.

```json
{
  "OLD_INDEX": {
    "aliases": {
      "loans": {},
      "loans-loan-v1.0.0": {}
    }
  }
}
```

## 2. Validate mappings
Run the following command and ensure that the mappings and settings sections of what is returned matches the mapping in step 3.1 below, and if it matches then continue on, otherwise tweak the following query to match your mapping.

```json
GET /OLD_INDEX/_mapping
GET /OLD_INDEX/_settings
```

## 3. New index
We will now create and validate the state of the new index.

### 3.1 Create new index
Create the new index with the analyzer wired into every text field (both settings AND mappings must be set at creation time because this is the only point at which `analyzer` can be assigned to a field).

```json
PUT /NEW_INDEX
{
  "settings": {
    "analysis": {
      "analyzer": {
        "accent_folding": {
          "type": "custom",
          "tokenizer": "standard",
          "filter": ["lowercase", "asciifolding"]
        }
      }
    }
  },
  "mappings": {
    "_source": { "excludes": ["trigger"] }, // internal only field
    "date_detection": false,
    "numeric_detection": false,
    "properties": {
      "$schema": { "type": "keyword" },
      "_created": { "type": "date" },
      "_updated": { "type": "date" },
      "available_items_for_loan_count": { "type": "long" },
      "can_circulate_items_count": { "type": "long" },
      "cancel_reason": { "type": "keyword" },
      "delivery": {
        "properties": {
          "method": { "type": "keyword" }
        }
      },
      "document": {
        "properties": {
          "authors": {
            "type": "text",
            "analyzer": "accent_folding",
            "fields": { "keyword": { "type": "keyword", "ignore_above": 256 } }
          },
          "cover_metadata": {
            "properties": {
              "ISBN": {
                "type": "text",
                "analyzer": "accent_folding",
                "fields": { "keyword": { "type": "keyword", "ignore_above": 256 } }
              },
              "isbn": {
                "type": "text",
                "analyzer": "accent_folding",
                "fields": { "keyword": { "type": "keyword", "ignore_above": 256 } }
              },
              "urls": { "type": "object" }
            }
          },
          "document_type": {
            "type": "text",
            "analyzer": "accent_folding",
            "fields": { "keyword": { "type": "keyword", "ignore_above": 256 } }
          },
          "edition": {
            "type": "text",
            "analyzer": "accent_folding",
            "fields": { "keyword": { "type": "keyword", "ignore_above": 256 } }
          },
          "identifiers": {
            "properties": {
              "scheme": {
                "type": "text",
                "analyzer": "accent_folding",
                "fields": { "keyword": { "type": "keyword", "ignore_above": 256 } }
              },
              "value": {
                "type": "text",
                "analyzer": "accent_folding",
                "fields": { "keyword": { "type": "keyword", "ignore_above": 256 } }
              }
            }
          },
          "pid": {
            "type": "text",
            "analyzer": "accent_folding",
            "fields": { "keyword": { "type": "keyword", "ignore_above": 256 } }
          },
          "publication_year": {
            "type": "text",
            "analyzer": "accent_folding",
            "fields": { "keyword": { "type": "keyword", "ignore_above": 256 } }
          },
          "title": {
            "type": "text",
            "analyzer": "accent_folding",
            "fields": { "keyword": { "type": "keyword", "ignore_above": 256 } }
          }
        }
      },
      "document_pid": { "type": "keyword" },
      "end_date": { "type": "date" },
      "extension_count": { "type": "short" },
      "extra_data": { "type": "object", "dynamic": "true" },
      "item": {
        "properties": {
          "barcode": {
            "type": "text",
            "analyzer": "accent_folding",
            "fields": { "keyword": { "type": "keyword", "ignore_above": 256 } }
          },
          "description": {
            "type": "text",
            "analyzer": "accent_folding",
            "fields": { "keyword": { "type": "keyword", "ignore_above": 256 } }
          },
          "document_pid": {
            "type": "text",
            "analyzer": "accent_folding",
            "fields": { "keyword": { "type": "keyword", "ignore_above": 256 } }
          },
          "medium": {
            "type": "text",
            "analyzer": "accent_folding",
            "fields": { "keyword": { "type": "keyword", "ignore_above": 256 } }
          },
          "pid": {
            "type": "text",
            "analyzer": "accent_folding",
            "fields": { "keyword": { "type": "keyword", "ignore_above": 256 } }
          }
        }
      },
      "item_pid": {
        "properties": {
          "type": { "type": "keyword" },
          "value": { "type": "keyword" }
        }
      },
      "item_suggestion": {
        "properties": {
          "_created": {
            "type": "text",
            "analyzer": "accent_folding",
            "fields": { "keyword": { "type": "keyword", "ignore_above": 256 } }
          },
          "barcode": {
            "type": "text",
            "analyzer": "accent_folding",
            "fields": { "keyword": { "type": "keyword", "ignore_above": 256 } }
          },
          "internal_location": {
            "properties": {
              "location": {
                "properties": {
                  "name": {
                    "type": "text",
                    "analyzer": "accent_folding",
                    "fields": { "keyword": { "type": "keyword", "ignore_above": 256 } }
                  }
                }
              },
              "name": {
                "type": "text",
                "analyzer": "accent_folding",
                "fields": { "keyword": { "type": "keyword", "ignore_above": 256 } }
              },
              "restricted": { "type": "boolean" }
            }
          },
          "medium": {
            "type": "text",
            "analyzer": "accent_folding",
            "fields": { "keyword": { "type": "keyword", "ignore_above": 256 } }
          },
          "shelf": {
            "type": "text",
            "analyzer": "accent_folding",
            "fields": { "keyword": { "type": "keyword", "ignore_above": 256 } }
          },
          "status": {
            "type": "text",
            "analyzer": "accent_folding",
            "fields": { "keyword": { "type": "keyword", "ignore_above": 256 } }
          }
        }
      },
      "patron": {
        "properties": {
          "email": {
            "type": "text",
            "analyzer": "accent_folding",
            "fields": { "keyword": { "type": "keyword", "ignore_above": 256 } }
          },
          "id": {
            "type": "text",
            "analyzer": "accent_folding",
            "fields": { "keyword": { "type": "keyword", "ignore_above": 256 } }
          },
          "location_pid": {
            "type": "text",
            "analyzer": "accent_folding",
            "fields": { "keyword": { "type": "keyword", "ignore_above": 256 } }
          },
          "name": {
            "type": "text",
            "analyzer": "accent_folding",
            "fields": { "keyword": { "type": "keyword", "ignore_above": 256 } }
          },
          "pid": {
            "type": "text",
            "analyzer": "accent_folding",
            "fields": { "keyword": { "type": "keyword", "ignore_above": 256 } }
          }
        }
      },
      "patron_pid": { "type": "keyword" },
      "pickup_location_pid": { "type": "keyword" },
      "pid": { "type": "keyword" },
      "request_expire_date": { "type": "date" },
      "request_start_date": { "type": "date" },
      "start_date": { "type": "date" },
      "state": { "type": "keyword" },
      "transaction_date": { "type": "date" },
      "transaction_location_pid": { "type": "keyword" },
      "transaction_user_pid": { "type": "keyword" },
      "trigger": { "type": "keyword" }
    }
  }
}
```



### 3.2 Validate new index
Optional validation step to ensure that each text field shows `"analyzer": "accent_folding"` and `accent_folding` appears under settings.index.analysis.analyzer.

```json
GET /NEW_INDEX/_mapping
GET /NEW_INDEX/_settings
```

## 4. Reindex data from the old index into the new index
We now reindex the data from the old index to the new index. This runs the analyzer against every existing document, applying and storing index folding at index time. In the old index, folding would only happen at query time on the query terms not on the stored data.

Check the response to ensure that "failures" is an empty array and all records have been successfully transfered and that the number of records in each index is the same.

```json
POST /_reindex
{
  "source": { "index": "OLD_INDEX" },
  "dest": { "index": "NEW_INDEX" }
}

GET /OLD_INDEX/_count
GET /NEW_INDEX/_count
```

## 5. Swap aliases
Swap the aliases for the two indexes to finally replace the old index with the new one as InvenioILS only uses the alias rather than the full name of the index, allowing us to swap the indexes.

Check the response of the `GET` requests to ensure the aliases now belong to the new index not the old one.

```json
POST /_aliases
{
  "actions": [
    { "remove": { "index": "OLD_INDEX", "alias": "loans-loan-v1.0.0" } },
    { "remove": { "index": "OLD_INDEX", "alias": "loans" } },
    { "add": { "index": "NEW_INDEX", "alias": "loans-loan-v1.0.0" } },
    { "add": { "index": "NEW_INDEX", "alias": "loans" } }
  ]
}

GET /NEW_INDEX/_alias
GET /OLD_INDEX/_alias
```

## 6. Testing
Test against real documents in your index that both do and do not have an accent such as cafe and café.

```json
GET /loans-loan-v1.0.0/_search
{
  "query": {
    "match": {
      "document.title": "TEST_VALUE"
    }
  }
}
```

## 7. Cleanup
Once you are happy that the new index is working as intended, delete the old index.

```json
DELETE /OLD_INDEX
```
