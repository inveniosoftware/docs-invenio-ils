# Loan Statistics

InvenioILS provides two complementary endpoints for analyzing loan data:

1. **Loan Histogram**: A flexible aggregation endpoint for analyzing the current state of loans with custom grouping and metrics
2. **Loan Transitions**: An event-based tracking system for monitoring the number of loan state changes


## Loan Histogram

The Loan Histogram endpoint provides real-time aggregation of loan records from the loans index.
It allows flexible grouping by any field and computation of statistical metrics on numeric fields.
Each response returns the count for the loans matching the filter and grouping criteria under the field `doc_count` and the requested aggregated metrics.


### Endpoint

```
GET /api/circulation/loans/stats
```

### Parameters

| Name       | Type       | Location | Required | Description                                                                                                                                                                  |
| ---------- | ---------- | -------- | -------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `group_by` | JSON array | query    | ✓        | Array of grouping definitions. Each item is an object with `field` (required) and `interval` (required for date fields). See [format details below](#group_by-field-format). |
| `metrics`  | JSON array | query    | ✗        | Array of metric definitions. Each item is an object with `field` (required) and `aggregation` (required). See [format details below](#metrics-field-format).                 |
| `q`        | string     | query    | ✗        | Search query string for filtering loans (uses standard search syntax).                                                                                                       |

#### `group_by` Field Format

Each grouping object can be:

- **Term field**: `{"field": "field_name"}` - Groups by exact values (e.g., `state`, `patron_pid`)
- **Date field**: `{"field": "date_field", "interval": "time_interval"}` - Groups by time intervals
    - Available intervals for date fields: `1d` (day), `1w` (week), `1M` (month), `1q` (quarter), `1y` (year)

#### `metrics` Field Format

Each metrics object is:

- `{"field": "field_name", "aggregation": "aggregation_type"}`
    - Available aggregation types: `avg` (average), `sum` (total), `min` (minimum), `max` (maximum), `median` (50th percentile)

!!! tip "Discovering available fields"
    To see all available loan fields for grouping and metrics, query the loans endpoint:
    ```
    GET /api/circulation/loans
    ```

### Examples

#### Group by loan state

```shell
curl --get \
  --url 'https://127.0.0.1:5000/api/circulation/loans/stats' \
  --data-urlencode 'group_by=[{"field":"state"}]' \
  --header 'content-type: application/json' \
  --header 'authorization: Bearer <auth token>'
```

#### Group by month with average extension count

```shell
curl --get \
  --url 'https://127.0.0.1:5000/api/circulation/loans/stats' \
  --data-urlencode 'group_by=[{"field":"start_date","interval":"1M"}]' \
  --data-urlencode 'metrics=[{"field":"extension_count","aggregation":"avg"}]' \
  --header 'content-type: application/json' \
  --header 'authorization: Bearer <auth token>'
```

#### Multiple grouping fields

```shell
curl --get \
  --url 'https://127.0.0.1:5000/api/circulation/loans/stats' \
  --data-urlencode 'group_by=[{"field":"state"},{"field":"start_date","interval":"1M"}]' \
  --header 'content-type: application/json' \
  --header 'authorization: Bearer <auth token>'
```

#### Grouping by document availability during request and query filtering

```shell
curl --get \
  --url 'https://127.0.0.1:5000/api/circulation/loans/stats' \
  --data-urlencode 'group_by=[{"field":"extra_data.stats.available_items_during_request"}]' \
  --data-urlencode 'q=request_start_date:[2025-01-01 TO 2025-12-31]' \
  --header 'content-type: application/json' \
  --header 'authorization: Bearer <auth token>'
```

---

## Loan Transitions

The Loan Transitions statistics track loan state change events over time using the invenio-stats package. 
Each time a loan transitions to a new state (e.g., checkout, extend, return), an event is recorded with a timestamp and trigger type.


### Endpoint

```
POST /api/stats
```

### Parameters

The request body should contain a named query with the `loan-transitions` stat type.

| Name         | Type   | Location | Required | Description                                                                            |
| ------------ | ------ | -------- | -------- | -------------------------------------------------------------------------------------- |
| `trigger`    | string | body     | ✓        | The transition type to filter on. See [available triggers](#available-triggers) below. |
| `interval`   | string | body     | ✓        | Aggregation interval. One of `year`, `quarter`, `month`, `week`, `day`.                |
| `start_date` | string | body     | ✗        | Beginning of the date range (`YYYY-MM-DD`).                                            |
| `end_date`   | string | body     | ✗        | End of the date range (`YYYY-MM-DD`).                                                  |

### Available Triggers

The following transition triggers are implemented in InvenioILS:

| Trigger    | Description      |
| ---------- | ---------------- |
| `request`  | Loan requested   |
| `checkout` | Item checked out |
| `extend`   | Loan extended    |
| `cancel`   | Loan cancelled   |

!!! note "Custom transition types"
    Other systems or extensions may add additional transition types. The available triggers are determined by your circulation configuration. E.g. [cds-ils](https://github.com/CERNDocumentServer/cds-ils) adds the `self-checkout` and `checkin` transition

### Example

Track loan extensions by month in 2025:

```shell
curl --request POST \
  --url https://127.0.0.1:5000/api/stats \
  --header 'content-type: application/json' \
  --header 'authorization: Bearer <auth token>' \
  --data '{
  "loan_extensions_2025": {
    "stat": "loan-transitions",
    "params": {
      "trigger": "extend",
      "start_date": "2025-01-01",
      "end_date": "2025-12-31",
      "interval": "month"
    }
  }
}'
```


