# Record relations

A relation is simply a link, a reference, from one record to another. Optionally, it can have some extra metadata to describe the relation. For example, in a library you can find a book written in English language and the same book in French. It is a nice feature for cataloguing purposes but also to show to the user that a book also exists in another language. It is natural to think then that a language relation can link these 2 books.

## Understanding the data model

In InvenioILS, only documents and series can have relations. Other models do not have this functionality enabled.
<!-- TODO: link to domain section -->

Three kinds of relations exist in InvenioILS:
### Parent-Child relation

Models the relation between a series (serial or multipart monograph) and a set of other series or documents.

For example:

- A series (**the parent**) can contain:
    - A set of documents (**the children**).
    - Multipart monographs (**the children**, but also **the parent**), which can contain:
        - documents (**the children**).

InvenioILS models these types of `Parent-Child relation`:

- `Serial relation`
- `Multipart Monograph relation`

Parent-Child relations can optionally have the extra field `volume` that describes the relation.
For example, in a serial or periodical, each issue is normally described by `issue+volume`: this information can be added to the relation description.

<!-- TODO: add a small diagram here -->

### Siblings relation
Models the relation between records of the same model, where the order is not important (unordered).

For example:

- A series and another series
- A document and another document

InvenioILS models these types of `Siblings relation`:

- `Language relation`
- `Edition relation`
- `Other relation`

Siblings relations can optionally have the extra field `note` that describes the relation.  
This can be useful to describe the `Other relation` and give a meaning to it.

### Sequence relation
Models the relation between records of the same model, where the order is important.
For example:

- A journal series that stops publishing volumes and issues at a certain point in time (**the old**) and continues as a new series afterwards (**the new**)
    - The old series **is continued by** the new one
    - The new series **continues** the old one



## Under the hood

Relations between records are stored safely in the Invenio database and they are used as source of truth when validating exiting of new relations. InvenioILS uses [InvenioPIDRelations](https://github.com/inveniosoftware/invenio-pidrelations) module to store the relations graph as Parent-Child relation, basically list of tuples `Parent PID`, `Child PID` and `Relation Type`. There is no extra metadata that can be stored at the moment for each relation.
InvenioILS hides this internal implementation and adds an abstraction on top, to model not only Parent-Child relations, but also the other types described above.

Each record with relations has, at least, an extra field `relations` in its metadata: this field is stored in the database as a `JSON Schema Reference` and it is calculated "on-the-fly" by reading the `PIDRelations` db table when the record is fetched or indexed. This is to avoid any duplication of metadata both in the db and records metadata which could lead to data inconsistencies.

Since relations extra metadata, e.g. the `volume` for `Parent-Child relations` cannot be stored in the database, it is instead stored in the record metadata, in the `relations_extra_metadata` field. To avoid duplication, the extra metadata is stored only in one of the record of the relation: when fetching or indexing the second record of the relation, the extra metadata is automatically read from the first and added it on the fly.
See the section below for more clear explanations.

## Relations metadata

When creating a new relation, the extra metadata is always and only stored in the parent or first record metadata. Let's see an example.

Let's model a relation between the book "The lord of the rings" (PID: "J8H") and the book "The Hobbit" (PID: "M1A") of type `Siblings Other`, with an extra note 'same author'.
Example of the REST payload:
```
POST /documents/J8H/relations
{
   pid: 'M1A',
   pid_type: 'docid',
   relation_type: other',
   note: 'same author'
}
```
As result, the extra metadata `note` will be stored **only** in the book "The lord of the rings", the first. Let's see what happens when fetching both records from the db:
```
GET /documents/J8H
{
  title: 'The lord of the rings',
  pid: 'J8H',
  edition: 'first',
  publication_year: 1954,
  ...
  relations: {
      other: {
        pid: 'M1A',
        pid_type: 'docid',
        note: 'same author',
        record_fields: {
          title: 'The Hobbit',
          edition: '1st',
          publication_year: 1937
        }
      }
  },
  relations_extra_metadata: {
    other: {
      note: 'same author',
      pid: 'M1A',
      pid_type: 'docid',
    }
  }
...
}
```

As expected, the first record of the relation has the field `relations_extra_metadata` with the extra note that we have added. The `relations` filled has been automatically generated by getting the information for the second record merged with the extra metadata.

```
GET /documents/M1A

{
  title: 'The Hobbit',
  pid: 'M1A'
  edition: '1st',
  publication_year: 1937,
  ...
  relations: {
      other: {
        pid: 'J8H',
        pid_type: 'docid',
        note: 'same author',
        record_fields: {
          title: 'The lord of the rings',
          edition: 'first',
          publication_year: 1954
        }
      }
  },
  relations_extra_metadata: {}
...
}
```

The second record do not contain the extra metadata (otherwise it would be a duplication), but it contains the `relations` field with the information of the first record and the extra metadata merged.
