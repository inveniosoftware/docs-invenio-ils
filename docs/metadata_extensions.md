# Metadata Extensions

## Backend config

## Frontend config

Provide configuration to enable metadata extensions display.

The configuration should come in the following form.

1. Provide `extensions` property in global config.
2. Provide a `label` that will appear in the overriden components
3. The fields you want to display. This setting is required for the field to be displayed at form so as to be edited. For showing/hiding the field, there is an extra property.
4. Fields support properties

   - `type` the type of the field, can be one of `string`, `boolean`, `date`
   - `default` the default value when used in forms
   - `isRequired` displays if the field is required from the validator, default is `false`
   - `isVisible` shows / hides info from frontsite, default is `true`

```js
global_config = {
  extensions: {
    label: 'Other Fields',
    fields: {
      field_foo: {
        type: 'string',
        default: '',
        isRequired: true,
        isVisible: false,
      },
    },
  },
};
```
