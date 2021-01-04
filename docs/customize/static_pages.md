# Static pages

## Backend
InvenioILS provides additional functionality of defining static pages, in order to present addtional information for the end user.
Example use case of a static page is 'About' or 'Contact' page.

InvenioILS allows adding the custom pages through admin panel: `/admin/pages`, where it is possible to create new pages by clicking on `Create button`.
The pages will be available under the routing specified in the creation form.
The functionality is provided by invenio-pages module. Addtionally it is possible to GET the page created by REST API under `/api/pages/<page_id>` where expected payload is similar to the one below:

```json
{
  "title": "test",
  "content": "<p>test</p> ",
  "id": "1",
  "description": "test",
  "url": "/about",
  "links": {
     "self": "https://localhost:5000/api/pages/1"
  }
}
```
 
## Frontend configuration

In the InvenioILS frontend client it is possible to provide a set of created static pages as a configuration variable.
It is implemented by providing simple mapping between the page ID and the expected react routing:

```js
export const staticPages = [
  { name: 'about', route: '/about', apiURL: '1' },
  { name: 'contact', route: '/contact', apiURL: '2' },
];
```