(* Run Elasticsearch query - last 15 minutes, PreCalculateScan logs *)

Get[FileNameJoin[{Directory[], "fetch_elasticsearch.wl"}]];

cmd = <|
  "url" -> "https://elasticsearch.c6ww.wolframalpha.com/logstash-*/_search",
  "queryString" -> "message: \"\\\"Label\\\" -> \\\"PreCalculateScan\\\"\" AND kubernetes.container_name:\"active-web-elements-server-public-en*\"",
  "startTime" -> "now-15m",
  "maxResults" -> 10000,
  "username" -> "es_admin",
  "password" -> Environment["ESPASSWORD"]
|>;

Echo[cmd];

response = ExecuteElasticSearch[cmd];
Lookup["hits"]@*Lookup["hits"]@response
