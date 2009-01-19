# This file does not include any Rake files, but loads up the 
# tasks in the /vendor/gems/ folders

  require 'rubygems'
  Gem.manage_gems
  gem = Gem.cache.search('calendar_date_select').sort_by { |g| g.version }.last
  raise "Gem 'calendar_date_select' is not installed" if gem.nil?
  path = gem.full_gem_path
  Dir[File.join(path, "/**/tasks/**/*.rake")].sort.each { |ext| load ext }

