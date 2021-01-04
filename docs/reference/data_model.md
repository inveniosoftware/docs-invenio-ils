# Understanding Data Model

This documentation will explain you the main entities that are modeled in InvenioILS. The comprehension of these concepts is fundamental to understand the available workflows, such us `circulation`, `acquisition` or `InterLibrary loans`.

## Libraries

In InvenioILS, the concept of a library is modeled with the **Location** entity. Each physical item has to belong to one of the defined locations (each item belongs, in reality, to an internal location, see below).

You can define multiple locations and optionally enable simple workflows of items transitions from one location to another.

Each location can be composed of multiple **internal locations**: this allows to model the scenario where one large library stores items in multiple buildings.

Let's take a real example: at CERN, there is only on main library, the `CERN Library`. Items are stored in many different buildings across the campus. Each of this building belongs the same unique CERN library.

An item will be stored in a building (internal location) and the building is part of the CERN library (the location). In the simplest scenario, you will have 1 location with 1 internal location.

You can see the latest version of the schema definition for location and internal location here:

* [Location schema](https://github.com/inveniosoftware/invenio-app-ils/blob/master/invenio_app_ils/locations/schemas/locations/location-v1.0.0.json)
* [Internal Location schema](https://github.com/inveniosoftware/invenio-app-ils/blob/master/invenio_app_ils/internal_locations/schemas/internal_locations/internal_location-v1.0.0.json)

## Patrons

A **Patron** is a user of the system, affiliated to a location. A patron can, for example, search for literature, loan items or request to obtain literature not found in the catalog.

!!! note
    At the current state of development of InvenioILS, it is not possible to define custom attributes for patrons or associate patrons to different locations and define rules per location.

## Literature

A **Literature** is a "virtual" entity that includes both **Series** and **Documents**. When managing the catalogue, librarians will act directly on specific series or documents using the backoffice UI. When browsing or searching, a patron will see literature instead, a simplified aggregation of series and documents.

## Series

A **Series** is a sequence of **Documents**. It can be *infinite*, for example in the case of recurring periodicals, characterized by the attribute `type: SERIAL`. It can *finite*, for example in the case of volumes of the same book, characterized by the attribute `type: MULTIPART_MONOGRAPH`.

A serial will in general contain a list of documents. It can also include multipart monographs. Multipart monographs can only contain list of documents.

This parent-children structure is modeled in InvenioILS via [records relations](record_relations.md).

You can see [here](https://github.com/inveniosoftware/invenio-app-ils/blob/master/invenio_app_ils/series/schemas/series/series-v1.0.0.json) the latest version of the schema definition.

## Documents

A **Document** is the abstract representation of a book (or any other type of document), the entity that contains all the information such as title, authors, etc. A document models the common metadata to all the physical copies (**Item**) or digital e-books instances of the book.

You can see [here](https://github.com/inveniosoftware/invenio-app-ils/blob/master/invenio_app_ils/documents/schemas/documents/document-v1.0.0.json) the latest version of the schema definition.

**Example**

TODO

Since the document is the richest entity in InvenioILS, you find below more details on some of the metadata fields.

### Cover Metadata

The field of `cover_metadata` was introduced to provide support for different
literature cover providers. The property that was selected to be used as a
cover is provided in the follwoing form, where the key of the entry is the
type of data we will use to fetch the cover from our provider, followed by its value.
In this example we are using the commonly used `isbn`. For example Open Library
covers API provides support also for `OCLC`, `LCCN`, `OLID` and `ID`.

```console
cover_metadata = {
  "isbn": "0123456789"
}
```

By overriding `ILS_LITERATURE_COVER_URLS_BUILDER` you can provide your "logic"
about the covers.

When `covers_metadata` are getting resolved they are getting decorated with
the `urls` for the covers based on `ILS_LITERATURE_COVER_URLS_BUILDER`.
The current implementation provides 3 different urls based on the size `small`,
`medium` and `large`, so when you are fetching a literature record your
`cover_metadata` should look like:

```console
cover_metadata = {
  "isbn": "0123456789",
  "urls": {
    "small": "https://your.provider.com/?isbn={your_isbn}&size=small"
    "medium": "https://your.provider.com/?isbn={your_isbn}&size=medium"
    "large": "https://your.provider.com/?isbn={your_isbn}&size=large"
  }
}
```

### Identifiers

The identifiers field contains the list of the persistent identifiers relevant to the record, with particular focus on the identifiers which are connected with the domain, like `ISBN`.
The field is structured as

```json
{
  "identifiers": [
    {
      "scheme": "ISBN",
      "value": "1234-4567"
    }
  ]
}
```

to allow for certain flexibility of adding different types of identifiers. The list of possible `scheme` values can be provided by using vocabularies.

#### ISBN, ISSN

https://www.isbn-international.org/content/what-isbn

https://portal.issn.org/

#### DOI

More on https://www.doi.org/

#### Alternative identifiers

TODO

### Subjects, keywords and tags

Subjects, keywords and tags can be use to categorize or group content. They have different purposes:

* The `subjects` field can contain a list of subject terms to describe a document. The list of subjects are defined with controlled vocabularies.
* The `keywords` field can contain a list of keywords or tags in the form `source` with `value` to identify from where the keyword is coming from, and it can be freely input when cataloguing.
* The `tags` field can contain a list of tags, a simple text value, but values are defined with a controlled vocabulary to avoid duplications or spelling mistakes.

### Vocabularies

## Items

## E-items

## Loans
