# Document API

This document outlines the API endpoints available for managing documents in Invenio ILS.

* **List Documents**

    - **Endpoint**: `/api/documents/`
    - **Method**: `GET`
    - **Description**: Retrieves a list of all documents in the catalog.

* **Create Document**

    - **Endpoint**: `/api/documents`
    - **Method**: `POST`
    - **Description**: Adds a new document to the catalog.
    - **Example**:

Request

```shell
curl -X POST \
  'https://127.0.0.1:5000/api/documents' \
  --header 'Accept: */*' \
  --header 'Authorization: Bearer API-TOKEN' \
  --header 'Content-Type: application/json' \
  --data-raw '{
  "title": "The Alchemist",
  "authors": [{"full_name": "Paulo Coelho"}],
  "publication_year": "1988",
  "document_type": "BOOK",
  "languages": ["eng"]
}'
```

Response

```shell
{
  "created": "2024-07-09T12:13:25.484073+00:00",
  "id": "6hq54-tc982",
  "links": {
    "self": "https://127.0.0.1:5000/api/documents/6hq54-tc982"
  },
  "metadata": {
    "$schema": "https://cds-ils.cern.ch/schemas/documents/document-v1.0.0.json",
    "authors": [
      {
        "full_name": "Paulo Coelho"
      }
    ],
    "circulation": {
      "active_loans_count": 0,
      "available_items_for_loan_count": 0,
      "can_circulate_items_count": 0,
      "items_for_reference_count": 0,
      "overbooked": false,
      "overdue_loans_count": 0,
      "past_loans_count": 0,
      "pending_loans_count": 0
    },
    "cover_metadata": {
      "urls": {
        "is_placeholder": true,
        "large": "https://127.0.0.1:5000/api/static/images/placeholder.png",
        "medium": "https://127.0.0.1:5000/api/static/images/placeholder.png",
        "small": "https://127.0.0.1:5000/api/static/images/placeholder.png"
      }
    },
    "created_by": {
      "type": "user_id",
      "value": "3"
    },
    "document_type": "BOOK",
    "eitems": {
      "hits": [],
      "total": 0
    },
    "items": {
      "hits": [],
      "on_shelf": {},
      "total": 0
    },
    "languages": [
      "eng"
    ],
    "pid": "6hq54-tc982",
    "publication_year": "1988",
    "relations": {},
    "restricted": false,
    "stock": {
      "mediums": []
    },
    "title": "The Alchemist"
  },
  "updated": "2024-07-09T12:13:25.484080+00:00"
}
```

* **Get Document Details**

    - **Endpoint**: `/api/documents/<document_pid>`
    - **Method**: `GET`
    - **Description**: Retrieves detailed information about a specific document.

* **Update Document Details**

    - **Endpoint**: `/api/documents/<document_pid>`
    - **Method**: `PUT`
    - **Description**: Updates information for a specific document.

For a detailed payload reference, [see here](https://github.com/inveniosoftware/invenio-app-ils/blob/d0843db45f0233000a55622fa6063be9e7193926/invenio_app_ils/documents/loaders/jsonschemas/document.py#L204).
