(* Fetch data from Elasticsearch using a KQL-style query string *)

url = "https://elasticsearch.c6ww.wolframalpha.com/logstash-*/_search";
username = Replace[Environment["USERNAME"], {$Failed | "" | _Missing -> "es_admin"}];
password = Replace[Environment["PASSWORD"], {$Failed | "" | _Missing -> "Z2EhHfDVh7tXLwu5"}];

(* Query string: message contains "Label" -> "PreCalculateScan", excluding certain IP ranges *)
queryString = "message: \"\\\"Label\\\" -> \\\"PreCalculateScan\\\"\" AND kubernetes.container_name:\"active-web-elements-server-public-en*\" AND NOT (10.16.61.* OR 10.128.*.* OR 10.5.13.*)";

(* Build the Elasticsearch request body *)
requestBody = <|
  "query" -> <|
    "bool" -> <|
      "must" -> {
        <|
          "query_string" -> <|
            "query" -> queryString,
            "default_field" -> "message"
          |>
        |>,
        <|
          "range" -> <|
            "@timestamp" -> <|
              "gte" -> "now-15m"
            |>
          |>
        |>
      }
    |>
  |>,
  "size" -> 50
|>;

(* Convert to JSON *)
jsonBody = ExportString[requestBody, "JSON"];

(* Make the HTTP request with Basic authentication *)
request = HTTPRequest[url, 
  <|"Method" -> "POST", "Body" -> jsonBody, 
    "ContentType" -> "application/json", "Username" -> username, 
    "Password" -> password|>
];
response = URLExecute[request, {}, "JSON"];

(* Write the full response to file *)
Export[ExpandFileName["~/Desktop/response.json"], response, "JSON"];
