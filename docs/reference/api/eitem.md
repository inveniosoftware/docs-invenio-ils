# E-Item API

This document outlines the API endpoints available for managing e-items in Invenio ILS.

* **List E-Items**

    - **Endpoint**: `/api/eitems/`
    - **Method**: `GET`
    - **Description**: Retrieves a list of all E-Items in the catalog.

* **Create E-Item**

    - **Endpoint**: `/api/eitems`
    - **Method**: `POST`
    - **Description**: Adds a new E-Item to the catalog.
    - **Example**:

Request

```shell
curl  -X POST \
  'https://127.0.0.1:5000/api/eitems' \
  --header 'Accept: */*' \
  --header 'Authorization: Bearer API-TOKEN' \
  --header 'Content-Type: application/json' \
  --data-raw '{
  "eitem_type": "E-BOOK",
  "document_pid": "6hq54-tc982"
}'
```

Response

```shell
{
  "created": "2024-07-09T13:48:24.091592+00:00",
  "id": "qk9xm-fhk28",
  "links": {
    "self": "https://127.0.0.1:5000/api/eitems/qk9xm-fhk28"
  },
  "metadata": {
    "$schema": "https://cds-ils.cern.ch/schemas/eitems/eitem-v3.0.0.json",
    "created_by": {
      "type": "user_id",
      "value": "3"
    },
    "document": {
      "authors": "Paulo Coelho",
      "cover_metadata": {
        "urls": {
          "is_placeholder": true,
          "large": "https://127.0.0.1:5000/api/static/images/placeholder.png",
          "medium": "https://127.0.0.1:5000/api/static/images/placeholder.png",
          "small": "https://127.0.0.1:5000/api/static/images/placeholder.png"
        }
      },
      "pid": "6hq54-tc982",
      "publication_year": "1988",
      "title": "The Alchemist"
    },
    "document_pid": "6hq54-tc982",
    "eitem_type": "E-BOOK",
    "files": [],
    "open_access": true,
    "pid": "qk9xm-fhk28"
  },
  "updated": "2024-07-09T13:48:24.091598+00:00"
}
```

* **Get E-Item Details**

    - **Endpoint**: `/api/eitems/<eitem_pid>`
    - **Method**: `GET`
    - **Description**: Retrieves detailed information about a specific E-Item.

For a detailed payload reference, [see here](https://github.com/inveniosoftware/invenio-app-ils/blob/d0843db45f0233000a55622fa6063be9e7193926/invenio_app_ils/eitems/loaders/jsonschemas/eitems.py#L50).
