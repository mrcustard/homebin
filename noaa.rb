#!/usr/bin/env ruby
# Script to grab the current price of my house from zillow
#
require 'nokogiri'
require 'open-uri'

uri = 'http://forecast.weather.gov/MapClick.php?CityName=Alpharetta&state=GA&site=FFC&lat=34.0689&lon=-84.272#.VOYiDFPF91k'
doc = Nokogiri::HTML(open(uri))
#puts doc.at_css('.prop-value-zestimate .value').text #delete("$,")
puts doc
