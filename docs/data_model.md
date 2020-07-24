# Data model

TODO

## Literature

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

## Document

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


## Series

## Item and E-item

## Locations and internal locations

## Vocabularies
