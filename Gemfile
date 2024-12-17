# frozen_string_literal: true
source "https://rubygems.org"

ruby '3.3.4' # matching https://pages.github.com/versions/

gem 'puma'
gem 'github-pages', group: :jekyll_plugins

group :dev do
    gem 'rack-jekyll', git: 'https://github.com/adaoraul/rack-jekyll'
    # install matching version of remote gem to make it easier to browse included files
    gem 'minimal-mistakes-jekyll', "4.26.2"
end

gem 'jekyll-compose', group: [:jekyll_plugins, :dev]

# If you have any plugins, put them here!
group :jekyll_plugins do
  gem "jekyll-paginate"
  gem "jekyll-sitemap"
  gem "jekyll-gist"
  gem "jekyll-feed"
  gem "jemoji"
  gem "jekyll-include-cache"
end
