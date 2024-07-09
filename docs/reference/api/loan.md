# Loan API

This document outlines the API endpoints available for managing loans in Invenio ILS.

* **List Loans**

    - **Endpoint**: `/api/circulation/loans/`
    - **Method**: `GET`
    - **Description**: Retrieves a list of all loans.

* **Create Loan**

    - **Endpoint**: `/api/circulation/loans`
    - **Method**: `POST`
    - **Description**: Creates a new loan.
    - **Example**:

Request

```shell
curl -X POST \
  'https://127.0.0.1:5000/api/circulation/loans' \
  --header 'Accept: */*' \
  --header 'Authorization: Bearer API-TOKEN' \
  --header 'Content-Type: application/json' \
  --data-raw '{
  "patron_pid": "4",
  "transaction_location_pid": "0xjaa-99k69",
  "transaction_user_pid": "3",
  "item_pid": {
    "type": "pitmid",
    "value": "wx52a-16d42"
  }
}'
```

Response

```shell
{
  "created": "2024-07-09T13:41:01.578736+00:00",
  "id": "ggx13-zhk21",
  "links": {
    "actions": {
      "checkout": "https://127.0.0.1:5000/api/circulation/loans/ggx13-zhk21/checkout",
      "request": "https://127.0.0.1:5000/api/circulation/loans/ggx13-zhk21/request"
    }
  },
  "metadata": {
    "$schema": "https://cds-ils.cern.ch/schemas/loans/loan-v1.0.0.json",
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
    "is_overdue": false,
    "item": {
      "barcode": "ABCD-1234",
      "document_pid": "6hq54-tc982",
      "medium": "PAPERBACK",
      "pid": "wx52a-16d42"
    },
    "item_pid": {
      "type": "pitmid",
      "value": "wx52a-16d42"
    },
    "patron": {
      "email": "patron3@test.ch",
      "id": "4",
      "location_pid": "0xjaa-99k69",
      "name": "Medrod Tara",
      "pid": "4"
    },
    "patron_pid": "4",
    "pid": "ggx13-zhk21",
    "state": "CREATED",
    "transaction_date": "2024-07-09T13:41:01.507088+00:00",
    "transaction_location": {
      "name": "Central Library"
    },
    "transaction_location_pid": "0xjaa-99k69",
    "transaction_user": {
      "name": "Hector Nabu"
    },
    "transaction_user_pid": "3"
  },
  "updated": "2024-07-09T13:41:01.578741+00:00"
}
```

* **Get Loan Details**

    - **Endpoint**: `/api/circulation/loans/<loan_pid>`
    - **Method**: `GET`
    - **Description**: Retrieves detailed information about a specific loan.

* **Update Loan Details**

    - **Endpoint**: `/api/circulation/loans/<loan_pid>`
    - **Method**: `PUT`
    - **Description**: Updates information for a specific loan.

For a detailed payload reference, [see here](https://github.com/inveniosoftware/invenio-circulation/blob/fd7f80e98918d9ed78282cda1c6aed40ec30f2f7/invenio_circulation/records/loaders/schemas/json.py#L75).
