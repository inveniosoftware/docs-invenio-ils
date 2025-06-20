#!/usr/bin/env bash
# -*- coding: utf-8 -*-
#
# Copyright (C) 2025 CERN.
#
# Invenio is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.


npx markdownlint-cli docs/* && \
awesome_bot --allow-dupe --skip-save-results --allow-redirect docs/**/*.md && \
mkdocs build -v
rm -rf site/
