# Data model

## Record types

## Vocabularies

### Document

#### Identifiers

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


#### Alternative identifiers

Alternative identifiers contain suplementary information about the identifiers.
