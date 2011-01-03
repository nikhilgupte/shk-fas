require 'bundler/capistrano'
set :application, "FAS"
set :repository, "git://github.com/nikhilgupte/shk-fas.git"
ssh_options[:forward_agent] = true
set :deploy_via, :remote_cache

set :tag_on_deploy, false
set :build_gems, false
set :compress_assets, false
set :backup_database_before_migrations, false
set :keep_releases, 5

set :bundle_without, [:development, :test, :cucumber]
set :bundle_flags,   "--deployment"

default_run_options[:pty] = true


after "deploy:update_code", "deploy:link_config"
after "deploy:update_code", "deploy:generate_css"
after "deploy:symlink", "deploy:update_crontab"

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
  
  desc "Update the crontab file"
  task :update_crontab, :roles => :db do
    run "cd #{release_path} && bundle exec whenever --update-crontab #{application} --set environment=#{rails_env}"
  end

  desc "Regenerate the CSS files"
  task :generate_css, :roles => :app do
    run "cd #{release_path} && rake more:generate RAILS_ENV=#{rails_env}"
  end
  
end

after "deploy:setup", "thinking_sphinx:shared_sphinx_folder"

after "deploy:start", "bluepill:start"
after "deploy:stop", "bluepill:quit"
after "deploy:restart", "bluepill:quit", "bluepill:start"

# Bluepill related tasks
#after "deploy:update", "bluepill:quit", "bluepill:start"
namespace :bluepill do
  desc "Stop processes that bluepill is monitoring and quit bluepill"
  task :quit, :roles => [:app], :on_error => :continue do
    sudo "bluepill stop"
    sleep 10 
    sudo "bluepill quit"
    sleep 10 
  end
 
  desc "Load bluepill configuration and start it"
  task :start, :roles => [:app] do
    sudo "bluepill load #{deploy_to}/current/config/#{stage}.pill"
  end
 
  desc "Prints bluepills monitored processes statuses"
  task :status, :roles => [:app] do
    sudo "bluepill status"
  end
end

