require 'httpclient'
require 'multi_json'

API_URL = "https://it.wikipedia.org/w/api.php" 

clnt = HTTPClient.new
params = { 'action' => 'opensearch', 'search' => 'gnu linux', 'limit' => 1, 'namespace' => 0, 'format' => 'json' }
res = clnt.get(API_URL, params)
link = MultiJson.load(res.body)[3][0]
puts link