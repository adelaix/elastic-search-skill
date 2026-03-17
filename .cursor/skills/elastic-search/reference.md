# ExecuteElasticSearch Reference

## Function Signature

```wolfram
ExecuteElasticSearch[command_Association]
```

Returns the raw Elasticsearch JSON response (Association).

## Command Association Keys

| Key | Type | Default | Notes |
|-----|------|---------|-------|
| `"url"` | String | `"https://elasticsearch.c6ww.wolframalpha.com/logstash-*/_search"` | Elasticsearch `_search` endpoint |
| `"username"` | String | `Environment["ESUSERNAME"]` | Basic auth username |
| `"password"` | String | `Environment["ESPASSWORD"]` | Basic auth password |
| `"queryString"` | String | `""` | Lucene query_string syntax |
| `"startTime"` | String or None | `None` | `@timestamp` gte (e.g. `"now-15m"`, `"2026-03-17"`) |
| `"endTime"` | String or None | `None` | `@timestamp` lte |
| `"maxResults"` | Integer | `50` | `size` parameter |

## Elasticsearch Query Structure

The function builds a `bool` query with `must`:

- **query_string**: Always included; uses `queryString` and `default_field: "message"`
- **range** (optional): Included only when `startTime` or `endTime` is set; filters on `@timestamp`

## Example Commands

```wolfram
(* Minimal - query only *)
<|"queryString" -> "message:error"|>

(* With time range *)
<|"queryString" -> "message:PreCalculateScan", "startTime" -> "now-1h", "maxResults" -> 100|>

(* Full *)
<|"username" -> "user", "password" -> "pass", "url" -> "https://...", "queryString" -> "...", "startTime" -> "now-15m", "endTime" -> "now", "maxResults" -> 50|>
```

## Response Format

```wolfram
<|
  "hits" -> <|
    "total" -> <|"value" -> n, ...|>,
    "hits" -> {<|"_id" -> ..., "_source" -> <|...|>, ...|>, ...}
  |>,
  ...
|>
```

Access documents: `Lookup["hits"]@*Lookup["hits"]@response`
