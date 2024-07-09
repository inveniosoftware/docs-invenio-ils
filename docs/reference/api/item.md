# Item API

This document outlines the API endpoints available for managing items in Invenio ILS.

* **List Items**

    - **Endpoint**: `/api/items`
    - **Method**: `GET`
    - **Description**: Retrieves a list of all physical items in the catalog.

* **Create Item**

    - **Endpoint**: `/api/items`
    - **Method**: `POST`
    - **Description**: Adds a new physical item to the catalog.
    - **Example**:

Request

```shell
curl  -X POST \
  'https://127.0.0.1:5000/api/items' \
  --header 'Accept: */*' \
  --header 'Authorization: Bearer API-TOKEN' \
  --header 'Content-Type: application/json' \
  --data-raw '{
  "internal_location_pid": "qknp3-28g56",
  "barcode": "ABCD-1234",
  "status": "CAN_CIRCULATE",
  "document_pid": "6hq54-tc982",
  "circulation_restriction": "TWO_WEEKS",
  "medium": "PAPERBACK"
}'
```

Response

```shell
{
  "created": "2024-07-09T13:04:44.356603+00:00",
  "id": "wx52a-16d42",
  "links": {
    "self": "https://127.0.0.1:5000/api/items/wx52a-16d42"
  },
  "metadata": {
    "$schema": "https://cds-ils.cern.ch/schemas/items/item-v2.0.0.json",
    "barcode": "ABCD-1234",
    "circulation": {},
    "circulation_restriction": "TWO_WEEKS",
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
      "document_type": "BOOK",
      "pid": "6hq54-tc982",
      "publication_year": "1988",
      "title": "The Alchemist"
    },
    "document_pid": "6hq54-tc982",
    "internal_location": {
      "legacy_id": 181529,
      "location": {
        "name": "Central Library",
        "opening_exceptions": [
          {
            "end_date": "2024-06-26",
            "is_open": false,
            "start_date": "2024-06-22",
            "title": "Dolor est est etincidunt numquam porro ut."
          }
        ],
        "opening_weekdays": [
          {
            "is_open": true,
            "times": [
              {
                "end_time": "12:00",
                "start_time": "08:00"
              },
              {
                "end_time": "18:00",
                "start_time": "13:00"
              }
            ],
            "weekday": "monday"
          },
          {
            "is_open": true,
            "times": [
              {
                "end_time": "12:00",
                "start_time": "08:00"
              },
              {
                "end_time": "18:00",
                "start_time": "13:00"
              }
            ],
            "weekday": "tuesday"
          },
          {
            "is_open": true,
            "times": [
              {
                "end_time": "12:00",
                "start_time": "08:00"
              },
              {
                "end_time": "18:00",
                "start_time": "13:00"
              }
            ],
            "weekday": "wednesday"
          },
          {
            "is_open": true,
            "times": [
              {
                "end_time": "12:00",
                "start_time": "08:00"
              },
              {
                "end_time": "18:00",
                "start_time": "13:00"
              }
            ],
            "weekday": "thursday"
          },
          {
            "is_open": true,
            "times": [
              {
                "end_time": "12:00",
                "start_time": "08:00"
              },
              {
                "end_time": "18:00",
                "start_time": "13:00"
              }
            ],
            "weekday": "friday"
          },
          {
            "is_open": false,
            "weekday": "saturday"
          },
          {
            "is_open": false,
            "weekday": "sunday"
          }
        ],
        "pid": "0xjaa-99k69"
      },
      "location_pid": "0xjaa-99k69",
      "name": "Building 3",
      "physical_location": "Voluptatem dolore magnam velit labore sit quisquam.",
      "pid": "qknp3-28g56"
    },
    "internal_location_pid": "qknp3-28g56",
    "medium": "PAPERBACK",
    "pid": "wx52a-16d42",
    "status": "CAN_CIRCULATE"
  },
  "updated": "2024-07-09T13:04:44.356607+00:00"
}
```

* **Get Item Details**

    - **Endpoint**: `/api/items/<item_pid>`
    - **Method**: `GET`
    - **Description**: Retrieves detailed information about a specific physical item.

For a detailed payload reference, [see here](https://github.com/inveniosoftware/invenio-app-ils/blob/d0843db45f0233000a55622fa6063be9e7193926/invenio_app_ils/items/loaders/jsonschemas/items.py#L34).
