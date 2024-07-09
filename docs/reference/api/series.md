# Series API

This document outlines the API endpoints available for managing series in Invenio ILS.

* **List Series**

    - **Endpoint**: `/api/series/`
    - **Method**: `GET`
    - **Description**: Retrieves a list of all series in the catalog.

* **Create Series**

    - **Endpoint**: `/api/series`
    - **Method**: `POST`
    - **Description**: Adds a new series to the catalog.
    - **Example**:

Request

```shell
curl -X POST \
  'https://127.0.0.1:5000/api/series' \
  --header 'Accept: */*' \
  --header 'Authorization: Bearer API-TOKEN' \
  --header 'Content-Type: application/json' \
  --data-raw '{
  "title": "Harry Potter",
  "mode_of_issuance": "MULTIPART_MONOGRAPH"
}'
```

Response

```shell
{
  "created": "2024-07-09T12:33:15.409020+00:00",
  "id": "decqv-ct473",
  "links": {
    "self": "https://127.0.0.1:5000/api/series/decqv-ct473"
  },
  "metadata": {
    "$schema": "https://cds-ils.cern.ch/schemas/series/series-v1.0.0.json",
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
    "mode_of_issuance": "MULTIPART_MONOGRAPH",
    "pid": "decqv-ct473",
    "relations": {},
    "title": "Harry Potter"
  },
  "updated": "2024-07-09T12:33:15.409026+00:00"
}
```

* **Get Series Details**

    - **Endpoint**: `/api/series/<series_pid>`
    - **Method**: `GET`
    - **Description**: Retrieves detailed information about a specific series.

* **Update Series Details**

    - **Endpoint**: `/api/series/<series_pid>`
    - **Method**: `PUT`
    - **Description**: Updates information for a specific series.

For a detailed payload reference, [see here](https://github.com/inveniosoftware/invenio-app-ils/blob/d0843db45f0233000a55622fa6063be9e7193926/invenio_app_ils/series/loaders/jsonschemas/series.py#L58).
