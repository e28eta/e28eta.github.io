require 'rack/jekyll'
# better mimic gh-pages, which adds plugins and overrides some settings
# https://github.com/github/pages-gem/blob/master/lib/github-pages/configuration.rb
require 'github-pages'

run Rack::Jekyll.new(:auto => true,
                     :force_build => true,
                     :future => true,
                     :show_drafts => true,
                     :strict_front_matter => true,
                     :unpublished => true,
                     :url => "http://blog.test",
                     :verbose => true)
