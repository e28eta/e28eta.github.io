require 'rack/jekyll'

run Rack::Jekyll.new(:auto => true, "url" => "http://blog.test")
