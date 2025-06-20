# REST API reference

## Summary

The following document is a reference guide for all the REST APIs that InvenioILS exposes.

## Intended audience

This guide is intended for advanced users, and developers of InvenioILS that have some experience with using REST APIs and are aware of the expected functionality a repository would be exposing.

## Authentication

### Login

After whipping up your local InvenioILS server, navigate to `https://127.0.0.1:5000/login` and login. For this API reference, we will be logging in as a `librarian` with the email `librarian@test.ch` that was added to the database in the [demo data setup step](../../install.md).

The only authentication method supported at the moment for REST API calls is by using Bearer tokens that you can generate at the "Applications" section of your user's account settings in your InvenioILS instance. There are two ways to pass the tokens in your requests.

**Authorization HTTP header (recommended)**

```shell
curl -k -H "Authorization: Bearer API-TOKEN" https://127.0.0.1:5000/api/documents
```

**`access_token` HTTP query string parameter**

```shell
curl -k https://127.0.0.1:5000/api/documents?access_token=API-TOKEN
```

API References:

- [Document API](./document.md)
- [Series API](./series.md)
- [Item API](./item.md)
- [Loan API](./loan.md)
- [E-Item API](./eitem.md)
- [Patron API](./patron.md)
- [Document Request API](./document_request.md)
- [Borrowing Request API](./borrowing_request.md)
- [Acquisition API](./acquisition.md)
- [Location API](./location.md)
- [Provider API](./provider.md)
