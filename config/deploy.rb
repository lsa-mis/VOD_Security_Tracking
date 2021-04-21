# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '3.0.1'

server 'vodsecurityproduction.miserver.it.umich.edu', roles: [:web, :app, :db], primary: true

set :repo_url,        'git@github.com:lsa-mis/VOD_Security_Tracking.git'
set :application,     'vodsecurityproduction'
set :user,            'deployer'

# Don't change these unless you know what you're doing
set :pty,             true
set :stage,           :production
set :deploy_via,      :remote_cache
set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :tmp_dir, '/home/deployer/tmp'

## Defaults:
# set :scm,           :git
# set :branch,        :master
# set :format,        :pretty
# set :log_level,     :debug
set :keep_releases, 3

## Linked Files & Directories (Default None):
set :linked_files, %w{config/puma.rb config/nginx.conf config/master.key config/puma.service}
set :linked_dirs,  %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :linked_dirs, fetch(:linked_dirs, []).push('public/packs', 'node_modules')

namespace :puma do
  desc 'Stop the PUMA service'
  task :stop do
    on roles(:app) do
      execute "cd #{fetch(:deploy_to)}/current; #{:rbenv_prefix} bundle exec pumactl -P ~/apps/#{fetch(:application)}/current/tmp/pids/puma.pid stop"
    end
  end

  desc 'Restart the PUMA service'
  task :restart do
    on roles(:app) do
      execute "cd #{fetch(:deploy_to)}/current; #{:rbenv_prefix} bundle exec pumactl -P ~/apps/#{fetch(:application)}/current/tmp/pids/puma.pid phased-restart"
    end
  end

  desc 'Start the PUMA service'
  task :start do
    on roles(:app) do
      puts "You must intially start the puma service using sudo on the server"
    end
  end
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Upload to shared/config'
  task :upload do
    on roles (:app) do
     upload! "config/master.key",  "#{shared_path}/config/master.key"
     upload! "config/puma_prod.rb",  "#{shared_path}/config/puma.rb"
     upload! "config/nginx_prod.conf",  "#{shared_path}/config/nginx.conf"
     upload! "config/puma_prod.service",  "#{shared_path}/config/puma.service"
    end
  end

  desc "reload the database with seed data"
  task :seed do
    on roles(:db) do
      execute "cd #{fetch(:deploy_to)}/current; bin/rails db:seed RAILS_ENV=production"
    end
  end

  before :starting,     :check_revision
  after  :finishing,    'puma:restart'
end

namespace :maintenance do
  desc "Maintenance start (edit config/maintenance_template.yml to provide parameters)"
  task :start do
    on roles(:web) do
      upload! "config/maintenance_template.yml", "#{current_path}/tmp/maintenance.yml"
    end
  end

  desc "Maintenance stop"
  task :stop do
    on roles(:web) do
      execute "rm #{current_path}/tmp/maintenance.yml"
    end
  end
end

