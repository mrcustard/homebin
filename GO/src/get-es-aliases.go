package main

import "fmt"
import "flag"
import "sort"
import "io/ioutil"
import "net/http"
import "encoding/json"

// version of get-es-aliases in golang
func main() {
	elastic_host := flag.String("node", "elastic-client-prod-1.56m.vgtf.net", "Elasticsearch node to connect to")
	flag.Parse()
	resp, err := http.Get("http://" + *elastic_host + ":9200/_aliases")
	if err != nil {
		fmt.Println("We have an error: ", err)
	}
	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		fmt.Println(err)
	}
	var f interface{}
	json.Unmarshal(body, &f)
	m := f.(map[string]interface{})
  fmt.Println("Index")
  fmt.Println("----------------------")
  s := make([]string, 0)
	for k, _ := range m {
		s = append(s, k)
	}
  fmt.Println(sort.Strings(s))
}
