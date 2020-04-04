# Data model

TODO

## Literature

## Document

TODO

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

## Series

## Item and E-item

## Vocabularies
