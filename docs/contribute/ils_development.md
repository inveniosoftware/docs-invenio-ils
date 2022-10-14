# Contribute

This documentation describes some tips for helping contribute to both frontend and backend of InvenioILS.

#### Develop React-invenio-app-ils as a npm linked library

1. Setup react-invenio-app-ils ready for development

```bash
cd <react-invenio-app-ils dir>
npm install
npm run lib-build
```

2. Link the distribution (the scripts are already provided in package.json)
   and refresh on changes - it will build your dist folder

```bash
cd <react-invenio-app-ils dir>
npm link
npm run watch
```

3. Go to your app, where you specified react-invenio-app-ils as your dependency and link the locally developed react-invenio-app-il

```bash
cd <my-react-app>
npm install
npm link @inveniosoftware/react-invenio-app-ils
```

## Recreate the demo data from scratch

You can recreate the demo data whenever you need. WARNING: this process will destroy any data or user that you have created or modified.

1. Make sure all services are up and running
2. Run again `./scripts/setup` in your virtualenv:

```bash
cd <my directory e.g. myprojects>/invenioils/invenioils
pipenv run invenio setup --verbose
```

## Troubleshooting FAQ

### UI network errors

If you are seeing in your application UI errors:

```bash
Something went wrong
Network Error
```

You can find out more about the error by checking the console in your browser's developer tools.

Verify if:

1. The backend server is running correctly (the console showing no exceptions)
2. You have followed the installation guide
3. the CORS policy is disabled for your local instance (not for any production environments!), see documentation above
4. your browser has the exception for the https temporary certificate of the local instance, see documentation below

### Browser certificate warning

The development server does not provide a valid HTTPS certificate. When opening the webpage of InvenioILS the first time, the browser will show you a warning: this is normal and expected for a local development environment.

1. In your browser go to [https://127.0.0.1:5000](https://127.0.0.1:5000).
2. You will see a warning about the invalid certificate: at this step, you will have to add the development certificate as trusted (`Accept` button or `Proceed to 127.0.0.1 (unsafe)` link). This process varies depending on the browser.
3. Reload the webpage if needed.


