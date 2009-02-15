set :application, "fas"
set :repository, "git://github.com/nikhilgupte/shk-fas.git"
set :use_sudo,    false
set :scm, :git
set :deploy_via, :remote_cache
set :deploy_to, "/var/www/apps/#{application}/production"
set :user,      "fas"
set :domain,      "210.210.77.180"
role :app, domain
role :web, domain
role :db,  domain, :primary => true
set :branch, "production"


namespace :deploy do
  desc "Update code, disable website, run migrations, enable website"
  task :full do
    deploy.web.disable
    deploy.update
    deploy.migrate
    deploy.restart
    deploy.web.enable
    deploy.cleanup
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

end
