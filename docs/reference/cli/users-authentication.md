# Users & Authentication

This page provides a reference for managing users, roles, access permissions, and tokens in InvenioILS.

## Access Actions

### List Available Access Actions

Check which access actions are available in your system:

```bash
invenio access list
```

## Roles

### Create a Role

Create a new role:

```bash
invenio roles create <role-name>
```

### Assign Access Action to Role

Assign an access action to a role:

```bash
invenio access allow <action-name> role <role-name>
```

### Add Role to User

Assign a role to a user:

```bash
invenio roles add <user-email> <role-name>
```

## Users

### Create a User

Create a new user

```bash
invenio users create <email> -a --password=<password> --profile "<json-profile>"
```

**Example:**

```bash
ils users create library@example.com -a --password=123456  --profile '{"full_name": "Library User"}' 
```


## Tokens

### Create a Token

Create an access token for a user:

```bash
invenio tokens create --name "<token-name>" --user <user-email>
```
