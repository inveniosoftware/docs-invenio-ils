# Document Request API

This document outlines the API endpoints available for managing document requests in Invenio ILS.

* **List Document Requests**

    - **Endpoint**: `/api/document-requests`
    - **Method**: `GET`
    - **Description**: Retrieves a list of all document requests.

* **Create Document Request**

    - **Endpoint**: `/api/document-requests`
    - **Method**: `POST`
    - **Description**: Creates a new document request.

* **Get Document Request Details**

    - **Endpoint**: `/api/document-requests/<document_request_pid>`
    - **Method**: `GET`
    - **Description**: Retrieves detailed information about a specific document request.

* **Update Document Request**

    - **Endpoint**: `/api/document-requests/<document_request_pid>`
    - **Method**: `PUT`
    - **Description**: Updates details of an existing acquisition document request.

For a detailed payload reference, [see here](https://github.com/inveniosoftware/invenio-app-ils/blob/d0843db45f0233000a55622fa6063be9e7193926/invenio_app_ils/document_requests/loaders/jsonschemas/document_request.py#L41).
