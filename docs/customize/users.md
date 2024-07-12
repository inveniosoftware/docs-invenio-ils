# Adding Users to Invenio ILS instance

This guide provides step-by-step instructions for adding users to a custom Invenio App ILS instance using:

- An existing database
- LDAP synchronization

!!! Note
    The following guides are just an example to give you an idea of how you can get started on existing users to your Invenio ILS instance!

    Similar scripts can also be used to port other cataloging data like Documents, E-Items, Purchase Orders and more!

This process is suitable for administrators who have just set up a new instance and want to onboard all users to the ILS database.

### Prerequisites

- A running instance of Invenio App ILS.
- Administrative access to the Invenio App ILS instance.
- Python installed on your system.

## Adding Users to Invenio App ILS Instance using LDAP Sync

### Step 1: Install LDAP3

First, ensure that the `ldap3` library is installed. You can install it using pip:

```bash
pip install ldap3
```

Make sure you have access to the LDAP directory with user data.

### Step 2: Configure LDAP Connection

Create or update the configuration file for your Invenio App ILS instance to include LDAP connection details. Add the following configuration variables:

```python
LDAP_SERVER = 'ldap://your-ldap-server.com'
LDAP_BIND_USER_DN = 'cn=admin,dc=example,dc=com'
LDAP_BIND_PASSWORD = 'your-bind-password'

LDAP_BASE_DN = 'ou=users,dc=example,dc=com'
LDAP_USER_FILTER = '(objectClass=person)'

LDAP_USER_FIELDS_MAPPING = {
    'email': 'mail',
    'username': 'uid',
    'first_name': 'givenName',
    'last_name': 'sn',
}
```

### Step 3: Create a Script for LDAP Sync

Create a Python script to synchronize LDAP users with the Invenio App ILS database. Save the following script as `ldap_sync.py`:

```python
import os
from ldap3 import Server, Connection, ALL
from invenio_accounts.models import User
from invenio_db import db

# Load configuration
LDAP_SERVER = os.getenv('LDAP_SERVER', 'ldap://your-ldap-server.com')
LDAP_BIND_USER_DN = os.getenv('LDAP_BIND_USER_DN', 'cn=admin,dc=example,dc=com')
LDAP_BIND_PASSWORD = os.getenv('LDAP_BIND_PASSWORD', 'your-bind-password')
LDAP_BASE_DN = os.getenv('LDAP_BASE_DN', 'ou=users,dc=example,dc=com')
LDAP_USER_FILTER = os.getenv('LDAP_USER_FILTER', '(objectClass=person)')
LDAP_USER_FIELDS_MAPPING = {
    'email': os.getenv('LDAP_FIELD_EMAIL', 'mail'),
    'username': os.getenv('LDAP_FIELD_USERNAME', 'uid'),
    'first_name': os.getenv('LDAP_FIELD_FIRST_NAME', 'givenName'),
    'last_name': os.getenv('LDAP_FIELD_LAST_NAME', 'sn'),
}

def ldap_sync():
    # Connect to the LDAP server
    server = Server(LDAP_SERVER, get_info=ALL)
    conn = Connection(server, LDAP_BIND_USER_DN, LDAP_BIND_PASSWORD, auto_bind=True)

    # Search for users
    conn.search(LDAP_BASE_DN, LDAP_USER_FILTER, attributes=list(LDAP_USER_FIELDS_MAPPING.values()))

    for entry in conn.entries:
        # Extract user details
        user_data = {field: getattr(entry, ldap_field, [None])[0] for field, ldap_field in LDAP_USER_FIELDS_MAPPING.items()}

        # Check if the user already exists
        user = User.query.filter_by(email=user_data['email']).first()

        if user is None:
            # Create a new user
            user = User(
                email=user_data['email'],
                username=user_data['username'],
                active=True,
                profile=dict(
                    full_name=f"{user_data['first_name']} {user_data['last_name']}",
                ),
            )
            db.session.add(user)
            print(f"Added new user: {user.email}")
        else:
            # Update existing user
            user.username = user_data['username']
            user.profile['full_name'] = f"{user_data['first_name']} {user_data['last_name']}"
            print(f"Updated existing user: {user.email}")

    # Commit the changes
    db.session.commit()
    print("LDAP synchronization complete.")

if __name__ == '__main__':
    ldap_sync()
```

## Adding Users to Invenio App ILS Instance from a Custom Database

### Step 1: Install Required Packages

Ensure that the required Python packages are installed. You can install them using pip:

```bash
pip install sqlalchemy
```

Make sure you have access to the custom user database.

### Step 2: Configure Database Connection

Create a configuration file or environment variables to store your database connection details. Here's an example of setting up a configuration file:

````python
CUSTOM_DB_URI = 'postgresql://user:password@localhost/customdb'
INVENIO_DB_URI = 'postgresql://invenio:password@localhost/invenio'```
````

### Step 3: Create a Script to Port Users

Create a Python script to read users from the custom database and add them to the Invenio App ILS database. Save the following script as **port_users.py**:

```python
import os
from sqlalchemy import create_engine, MetaData, Table
from sqlalchemy.orm import sessionmaker
from invenio_accounts.models import User
from invenio_db import db
from invenio_app.factory import create_api

# Load configuration
custom_db_uri = os.getenv('CUSTOM_DB_URI', 'postgresql://user:password@localhost/customdb')
invenio_db_uri = os.getenv('INVENIO_DB_URI', 'postgresql://invenio:password@localhost/invenio')

# Create SQLAlchemy engines and sessions
custom_engine = create_engine(custom_db_uri)
invenio_engine = create_engine(invenio_db_uri)

CustomSession = sessionmaker(bind=custom_engine)
InvenioSession = sessionmaker(bind=invenio_engine)

custom_session = CustomSession()
invenio_session = InvenioSession()

# Define the custom user table (adjust to match your schema)
metadata = MetaData()
users_table = Table('users', metadata, autoload_with=custom_engine)

def port_users():
    # Query all users from the custom database
    custom_users = custom_session.query(users_table).all()

    for custom_user in custom_users:
        # Extract user details (adjust to match your schema)
        email = custom_user.email
        username = custom_user.username
        first_name = custom_user.first_name
        last_name = custom_user.last_name

        # Check if the user already exists in Invenio ILS DB
        user = invenio_session.query(User).filter_by(email=email).first()

        if user is None:
            # Create a new user
            user = User(
                email=email,
                username=username,
                active=True,
                profile=dict(
                    full_name=f"{first_name} {last_name}",
                ),
            )
            invenio_session.add(user)
            print(f"Added new user: {email}")
        else:
            # Update existing user
            user.username = username
            user.profile['full_name'] = f"{first_name} {last_name}"
            print(f"Updated existing user: {email}")

    # Commit the changes
    invenio_session.commit()
    print("User porting complete.")

if __name__ == '__main__':
    # Initialize Invenio app context
    app = create_api()
    with app.app_context():
        port_users()

    # Close sessions
    custom_session.close()
    invenio_session.close()
```

### Additional Tips

You may schedule the script to run periodically (e.g., using a cron job) if you need to keep the Invenio user database in sync with your custom database/LDAP directory.

Feel free to adjust the configurations and script to better fit your specific environment and requirements.
