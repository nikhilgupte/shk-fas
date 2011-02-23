require 'bundler/capistrano'
set :application, "fas"
set :branch, "production"
set :repository, "git://github.com/nikhilgupte/shk-fas.git"
ssh_options[:forward_agent] = true
set :deploy_via, :remote_cache
set :deploy_to, "/var/www/apps/#{application}/production"
set :host, "210.210.77.180"
set :use_sudo, false
set :user, "fas"

set :tag_on_deploy, false
set :build_gems, false
set :compress_assets, false
set :backup_database_before_migrations, false
set :keep_releases, 5

set :bundle_without, [:development, :test, :cucumber]
set :bundle_flags,   "--deployment"

default_run_options[:pty] = true

after "deploy:update_code", "deploy:link_config"

set :config_files, %w(database.yml)
namespace :deploy do
  desc 'symlink config files'
  task :link_config, :roles => :app do
    unless config_files.empty?
      config_files.each do |file|
        run "ln -nsf #{File.join(shared_path, "config/" + file)} #{File.join(release_path, "/config/" + file)}"
      end
    end
  end
  
end


