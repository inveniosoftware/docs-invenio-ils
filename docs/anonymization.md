# User anonymization

InvenioILS provides utilities to handle the life cycle of user accounts.

To help with that the following commands are available:

- `list_patron_activity` dumps all the data stored in the system for a given patron.
  The resulting data is a pretty-printed python object and it is such that it can safely be shared with the corresponding user.

- `anonymize_patron` may be used to anonymize a patron's data.
  All personal information regarding this individual will be erased but all their past activity will be preserved anonymously (loans, literature requests, acquisitions, ...).
  The current requests this user has made will be canceled.
  If the user has active loans then the process will abort, those will have to be canceled manually.

  Note that this process is **irreversible** and the patron will permanently lose access to their account.
  The command can be provided an optional `--force` argument to delete any remaining data (even if the user row is not present in the database).

  A confirmation dialog is presented before applying the procedure. 

Both commands take a mandatory argument `--patron-pid`.
These commands are also available as functions in the framework.
