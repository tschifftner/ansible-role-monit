#!/usr/bin/ruby

require 'net/https'
require 'json'

uri = URI.parse("{{ monit_slack_url }}")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
request = Net::HTTP::Post.new(uri.request_uri, {'Content-Type' => 'application/json'})
request.body = {
    "channel"  => "#monit",
    "username" => "mmonit",
    "text"     => "[#{ENV['MONIT_HOST']}] #{ENV['MONIT_SERVICE']} - #{ENV['MONIT_DESCRIPTION']}"
}.to_json
response = http.request(request)
puts response.body