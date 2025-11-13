# Record Changes
InvenioILS tracks the number of updates, insertions and deletions per record type, user and day.
This data is collected with invenio-stats and accessible through its query endpoint `/api/stats` as the stats `ils-record-changes` and `ils-record-changes-per-user`.


## `ils-record-changes`
This stat returns a time-based histogram of record changes grouped by the specified interval (year, quarter, month, week, or day).
Each bucket contains a timestamp (in the `key` and `date` fields) and the count of changes for that time period (in the `count` field).

### Params
| Name         | Type     | Location | Required | Description |
|--------------|----------|-----------|-----------|--------------|
| `pid_type`   | string   | body      | ✓ | Record type to filter on. One of `acqoid`, `dreqid`, `eitmid`, `illbid`, `ilocid`, `pitmid`, `locid`, `provid`, `docid`, `serid`. |
| `method`     | string   | body      | ✓ | Operation type. One of `insert`, `update`, `delete`. |
| `interval`   | string   | body      | ✓ | Aggregation interval. One of `year`, `quarter`, `month`, `week`, `day`. |
| `start_date` | string   | body      | ✗ | Beginning of the date range (`YYYY-MM-DD`). |
| `end_date`   | string   | body      | ✗ | End of the date range (`YYYY-MM-DD`). |



### Example
```shell
curl --request POST \
  --url https://127.0.0.1:5000/api/stats \
  --header 'authorization: Bearer <auth token>' \
  --header 'content-type: application/json' \
  --data '{
  "eitem_inserts_2024_monthly": {
    "stat": "ils-record-changes",
    "params": {
      "start_date": "2024-01-01",
      "end_date": "2024-12-30",
      "method": "insert",
      "pid_type": "eitmid",
      "interval": "month"
    }
  }
}'
```

## `ils-record-changes-per-user`
This stat returns a user-based histogram of record changes grouped by user.
Each bucket contains a user ID (in the `key` field) and the total count of changes made by that user (in the `count` field).

### Params
| Name         | Type     | Location | Required | Description |
|--------------|----------|-----------|-----------|--------------|
| `pid_type`   | string   | body      | ✓ | Record type to filter on. One of `acqoid`, `dreqid`, `eitmid`, `illbid`, `ilocid`, `pitmid`, `locid`, `provid`, `docid`, `serid`. |
| `method`     | string   | body      | ✓ | Operation type. One of `insert`, `update`, `delete`. |
| `start_date` | string   | body      | ✗ | Beginning of the date range (`YYYY-MM-DD`). |
| `end_date`   | string   | body      | ✗ | End of the date range (`YYYY-MM-DD`). |





### Example
```shell
curl --request POST \
  --url https://127.0.0.1:5000/api/stats \
  --header 'authorization: Bearer <auth token>' \
  --header 'content-type: application/json' \
  --data '{
  "eitem_inserts_2025_users": {
    "stat": "ils-record-changes-per-user",
    "params": {
      "start_date": "2025-01-01",
      "end_date": "2025-12-30",
      "method": "insert",
      "pid_type": "eitmid"
    }
  }
}'
```
