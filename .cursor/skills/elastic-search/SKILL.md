---
name: elastic-search
description: Fetches data from Elasticsearch using Wolfram Language and ExecuteElasticSearch. Use when the user wants to query Elasticsearch, fetch log data, search indices, or retrieve documents from Elasticsearch. Requires Wolfram Language Evaluator MCP.
---

# Elasticsearch Fetch

## Quick Start

When the user wants to fetch data from Elasticsearch:

1. **Load the function**: `Get["<project-root>/fetch_elasticsearch.wl"]` — use the full path to the project's `fetch_elasticsearch.wl` (e.g. `/Users/delaix/Projects/git/elastic-search-skill/fetch_elasticsearch.wl` for this repo)
2. **Build the command** as an Association with the required keys
3. **Call** `ExecuteElasticSearch[command]` via the Wolfram Language Evaluator
4. **Extract hits** from `response["hits"]["hits"]`

## Command Parameters

| Key | Required | Default | Description |
|-----|----------|---------|-------------|
| `username` | No* | `Environment["ESUSERNAME"]` | Elasticsearch username |
| `password` | No* | `Environment["ESPASSWORD"]` | Elasticsearch password |
| `url` | No | `https://elasticsearch.c6ww.wolframalpha.com/logstash-*/_search` | Search endpoint |
| `queryString` | Yes | — | Lucene/query_string syntax query |
| `startTime` | No | `None` | `@timestamp` lower bound (e.g. `"now-15m"`) |
| `endTime` | No | `None` | `@timestamp` upper bound |
| `maxResults` | No | `50` | Maximum hits to return |

\* Credentials must come from the command or environment variables. No fallbacks.

## Workflow

1. Ensure `ESUSERNAME` and `ESPASSWORD` are set (or include them in the command)
2. Construct the command association with at least `queryString`
3. Evaluate via Wolfram Language Evaluator:

```wolfram
Get["<project-root>/fetch_elasticsearch.wl"]
cmd = <|"queryString" -> "...", "startTime" -> "now-15m", "maxResults" -> 50|>
response = ExecuteElasticSearch[cmd]
hits = Lookup["hits"]@*Lookup["hits"]@response
```

## Query String Syntax

Uses Elasticsearch `query_string` (Lucene syntax):

- `field:value` — match field
- `AND`, `OR`, `NOT` — boolean operators
- `*` — wildcard
- `"phrase"` — exact phrase (escape inner quotes: `\"`)

**Example**: `message: "\"Label\" -> \"PreCalculateScan\"" AND kubernetes.container_name:"active-web-elements-server-public-en*"`

## Response Structure

```wolfram
Lookup["hits"]@*Lookup["hits"]@response  (* list of documents *)
Lookup["total"]@*Lookup["hits"]@response (* total matching count *)
```

Each hit has `["_id"]`, `["_source"]` (the document).

## Additional Resources

- For full API details, see [reference.md](reference.md)
