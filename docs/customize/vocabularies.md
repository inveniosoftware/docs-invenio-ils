# Vocabularies

Vocabularies are indexed using Elasticsearch and can be indexed from a JSON
source file. To manage vocabularies use the `ils vocabulary` CLI.

Some pre-defined vocabulary generators are available. To generate a JSON file
with a list of languages or countries use:

```bash
ils vocabulary generate languages -o languages.json
ils vocabulary generate countries -o countries.json
```

To add vocabularies from a JSON file use the `index` command:

```bash
ils vocabulary index json [file1.json, file2.json, ...]
```

To add custom vocabularies or modify the text or data of an existing vocabulary
use the same `index` command as above.

If you change the `key` attribute of a vocabulary or if you remove a vocabulary
you also need to remove it from Elasticsearch. Use the `delete` command to
remove a vocabulary:

```bash
ils vocabulary delete country  # remove all countries
ils vocabulary delete country --key CH  # remove only Switzerland
```

Example vocabularies are available in `invenio_app_ils/vocabularies/data`.

Vocabulary-specific configuration is available in `config.py` and `invenioConfig.js`.
