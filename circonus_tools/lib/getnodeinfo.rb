require 'uri'
require 'net/http'

def idbquery(hostname, fields)
  # function
  uri = URI.parse("http://idb.services.dmtio.net/hosts?q=host:#{hostname}+AND+NOT+offline:true&fields=#{fields}")
  resp = Net::HTTP.get_response(uri)
  return resp.body
end

# Example:
# puts idbquery("prd-10-60-160-48.nodes.56m.dmtio.net")
