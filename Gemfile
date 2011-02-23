source :gemcutter
source :rubygems

gem "rails", "2.3.5"
gem "postgres-pr"
gem "whenever", '0.5.3' # generate cron jobs
gem 'fastercsv'
gem 'calendar_date_select'
gem "haml"
gem "dbi", "0.4.5"
gem "to-csv", :require => 'to_csv'

group :cucumber do
  gem 'cucumber-rails',   '0.3.0' #unless File.directory?(File.join(Rails.root, 'vendor/plugins/cucumber-rails'))
  gem 'database_cleaner', '0.5.0' #unless File.directory?(File.join(Rails.root, 'vendor/plugins/database_cleaner'))
  gem 'capybara',         '0.3.0' #unless File.directory?(File.join(Rails.root, 'vendor/plugins/capybara'))
  gem 'pickle',           '0.2.5'
  gem "rack-bug",   "~> 0.2.1", :require => "rack/bug"
  gem "mongrel"
end

group :test, :cucumber do
  gem "rspec", "1.3.0"
  gem "rspec-rails", "1.3.2"
  gem 'factory_girl', '1.2.3'
end

group :test do
  gem "remarkable_rails", "3.1.12"
  gem "delorean", "0.1.1", :require => "delorean"  # allows time travel
end

group :development do
 gem 'wirble'
 gem 'capistrano'
end


