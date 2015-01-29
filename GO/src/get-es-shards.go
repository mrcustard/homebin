package main

import "fmt"
import "flag"
import "io/ioutil"
import "net/http"

func main() {
  elastic_host := flag.String("node", "elastic-client-prod-1.56m.vgtf.net", "Elasticsearch node to connect to")
  flag.Parse()
  resp, err := http.Get("http://" + *elastic_host + ":9200/_cat/shards")
  if err != nil {
    fmt.Println("We have an error: ", err)
  }
  defer resp.Body.Close()
  body, err := ioutil.ReadAll(resp.Body)
  if err != nil {
    fmt.Println(err)
  }
  fmt.Println(string(body))
}
