set :application, "blavel"
set :repository,  "git@github.com:johngrimes/blavel.git"
set :scm, "git"
set :deploy_to, "/var/www/sites/blavel.com"

set :user, "deploy"
set :runner, "deploy"

role :app, "74.207.246.162"
role :web, "74.207.246.162"
role :db,  "74.207.246.162", :primary => true

namespace :deploy do
  task :restart do
    sudo "service thin-blavel stop"
    sudo "service thin-blavel start"
  end
end

# Remove all but 5 deployed releases after each deployment
after :deploy, 'deploy:cleanup'

task :after_update_code, :roles => :app do

  # Create symbolic link to a common database.yml file in the system directory,
  # which is not under source control
  run "ln -nfs #{shared_path}/db/database.yml #{release_path}/config/database.yml"

  # Create symbolic link to a common environment.rb file in the system directory,
  # which is not under source control
  run "ln -nfs #{shared_path}/config/environment.rb #{release_path}/config/environment.rb"

  # Create symbolic links to common country and location data dumps
  run "ln -nfs #{shared_path}/db/countries.txt #{release_path}/db/countries.txt"
  run "ln -nfs #{shared_path}/db/locations.txt #{release_path}/db/locations.txt"

  # Generate documentation and link it to opencode in the public directory
  run "cd #{release_path}; rake doc:app"
  run "ln -nfs #{release_path}/doc/app #{release_path}/public/opencode"

  # Symlink to rake task for controlling thin cluster
  run "ln -nfs #{deploy_to}/../common/tasks/thin.rake #{release_path}/lib/tasks/thin.rake"

  set_permissions
end

task :after_setup, :roles => [:app, :db, :web] do
  set_permissions
end

task :set_permissions do
  sudo "chown -R deploy:www-data #{deploy_to}"
  sudo "chmod -R g+w #{deploy_to}"
end
