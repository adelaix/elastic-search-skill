(* ExecuteElasticSearch - Fetch data from Elasticsearch using a query string *)

ExecuteElasticSearch[command_Association] := Module[
  {url, username, password, queryString, startTime, endTime, maxResults,
   requestBody, rangeClause, tsRange, mustClauses, jsonBody, request, response},

  (* Extract parameters from command association *)
  url = Lookup[command, "url", "https://elasticsearch.c6ww.wolframalpha.com/logstash-*/_search"];
  username = Lookup[command, "username", Environment["USERNAME"]];
  password = Lookup[command, "password", Environment["PASSWORD"]];
  queryString = Lookup[command, "queryString", ""];
  startTime = Lookup[command, "startTime", None];
  endTime = Lookup[command, "endTime", None];
  maxResults = Lookup[command, "maxResults", 50];

  (* Build the must clauses: always include query_string *)
  mustClauses = {<|
    "query_string" -> <|
      "query" -> queryString,
      "default_field" -> "message"
    |>
  |>};

  (* Add range clause if startTime or endTime is specified *)
  If[startTime =!= None || endTime =!= None,
    tsRange = <||>;
    If[startTime =!= None, tsRange["gte"] = startTime];
    If[endTime =!= None, tsRange["lte"] = endTime];
    rangeClause = <|"range" -> <|"@timestamp" -> tsRange|>|>;
    mustClauses = Append[mustClauses, rangeClause]
  ];

  (* Build the Elasticsearch request body *)
  requestBody = <|
    "query" -> <|"bool" -> <|"must" -> mustClauses|>|>,
    "size" -> maxResults
  |>;

  jsonBody = ExportString[requestBody, "JSON"];

  (* Make the HTTP request with Basic authentication *)
  request = HTTPRequest[url,
    <|"Method" -> "POST", "Body" -> jsonBody,
      "ContentType" -> "application/json", "Username" -> username,
      "Password" -> password|>
  ];
  response = URLExecute[request, {}, "JSON"];

  response
]
