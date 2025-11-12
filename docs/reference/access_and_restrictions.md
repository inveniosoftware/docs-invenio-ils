# Access and restrictions


!!! note
    This is only a part of a bigger article, with many sections still not documented. If you are an expert on the subject, please contribute.


## Access roles

Superuser (Admin) - Actor having the access to set up the application configuration

Librarian - Actor in charge of managing and curating the data, and the workflows.

Librarian (Read-only) - Actor with view-only access to the backoffice. 
Can view all backoffice resources but cannot create, update, or delete records. 
Ideal for external integrations that only need to read data like statistics reporting.

Patron - Actor interacting with the system from the outside, using the feature of the system to cover his demand for books/articles/publications and to interact with the library.

## Backoffice Access Permissions

InvenioILS provides two access actions for backoffice access:

**`ils-backoffice-access`** - Full backoffice access
: Users or roles with this action have full access to the backoffice, including the ability to create, update, and delete all records.

**`ils-backoffice-readonly-access`** - Read-only backoffice access (Available from [v6.0](../releases/version6/upgrade.md))
: Users or roles with this action can view all backoffice resources but cannot create, update, or delete any records.

For instructions on setting up users and roles with these access actions, see the [CLI Users & Authentication reference](cli/users-authentication.md).

## Document Record

In the document schema there are two types connected with giving access tot the record itself.
The restricted access means that record will be only accessible to the `librarian` role - taken into the account the fact that the actors of the role are the day to day managers of the system's workflow.
The fact that the record is restricted means it is not visible to the patron, neither by trying to access the record's landing page nor by performing a search
Read more about access in invenio-access module [documentation](https://invenio-access.readthedocs.io/en/latest/overview.html)


There are two fields on the `Document` record schema to fulfil the need of applying restrictions

- the first one is a flexible way supplied by `invenio-access` module:
```json
{
    "_access": {
        "read": {
            "systemroles": ["campus_user"]
        },
        "update": {
            "users": [1],
            "roles": ["curators"]
        }
    }
}
```
This example will not be discussed here as it is already documented ([here](https://github.com/inveniosoftware/training/tree/master/12-managing-access))


- the second field is the `restricted` boolean field. It fulfils a need for a simple indication if the record should be visible to the patron


## EItem record (electronic items)

### Open access field
The field implementation and naming is a result of one of the requirements which we used as a reference to construct the system.

Most of the electronic item records have assigned URL as a resource, to an external provider.
From the ILS point of view those URLs can require a login to external providers website, and the patron should be informed about it. In the same the Electronic item record should not be restricted.
Open access informs the patron that the link is accessible without any additional restrictions, and the intention of the client was to promote the open over the restricted
