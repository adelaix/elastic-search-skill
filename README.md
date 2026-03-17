# Elasticsearch Skill

Wolfram Language tools for querying Elasticsearch. Fetches log data using Lucene query syntax with optional time ranges.

## Prerequisites

- **Wolfram Language** (Mathematica, Wolfram Engine, or wolframscript)
- **Credentials**: Elasticsearch username and password

## Setup

Set credentials via environment variables (or pass them in the command):

```bash
export ESUSERNAME="your_elasticsearch_username"
export ESPASSWORD="your_elasticsearch_password"
```

## Quick Start

### Load and run a query

```wolfram
Get["fetch_elasticsearch.wl"]

cmd = <|
  "queryString" -> "message:error",
  "startTime" -> "now-15m",
  "maxResults" -> 50
|>;

response = ExecuteElasticSearch[cmd]
hits = response["hits"]["hits"]
```

### Run the example script

```bash
cd /path/to/elastic-search-skill
wolframscript -file run_query.wl
```

Runs a predefined query for PreCalculateScan logs from the last 15 minutes. Requires `ESUSERNAME` and `ESPASSWORD` in the environment.

## ExecuteElasticSearch

| Parameter | Default | Description |
|-----------|---------|--------------|
| `url` | `https://elasticsearch.c6ww.wolframalpha.com/logstash-*/_search` | Search endpoint |
| `username` | `Environment["ESUSERNAME"]` | Basic auth username |
| `password` | `Environment["ESPASSWORD"]` | Basic auth password |
| `queryString` | `""` | Lucene query_string syntax |
| `startTime` | `None` | `@timestamp` lower bound (e.g. `"now-15m"`) |
| `endTime` | `None` | `@timestamp` upper bound |
| `maxResults` | `50` | Maximum hits to return |

## Query String Syntax

Uses Elasticsearch `query_string` (Lucene):

- `field:value` — match field
- `AND`, `OR`, `NOT` — boolean operators
- `*` — wildcard
- `"phrase"` — exact phrase (escape inner quotes: `\"`)

**Example**: `message: "\"Label\" -> \"PreCalculateScan\"" AND kubernetes.container_name:"active-web-elements-server-public-en*"`

## Response

```wolfram
response["hits"]["hits"]   (* list of documents *)
response["hits"]["total"]   (* total matching count *)
```

Each hit has `["_id"]` and `["_source"]` (the document).

## Cursor Skill

A Cursor skill at `.cursor/skills/elastic-search/` lets the AI agent run Elasticsearch queries when you ask. Requires the Wolfram Language Evaluator MCP.
