require 'rack/jekyll'
# better mimic gh-pages, which adds plugins and overrides some settings
# https://github.com/github/pages-gem/blob/master/lib/github-pages/configuration.rb
require 'github-pages'

run Rack::Jekyll.new(:auto => true,
                     :force_build => true,
                     "url" => "http://blog.test",
                     "show_drafts" => true)
