require "bundler/capistrano"
require "rvm/capistrano"
require 'capistrano/sidekiq'
require 'capistrano-unicorn'

set :stages, %w(production staging)
set :stage, ARGV.select { |arg| stages.include? arg }.first || 'staging'
load "config/deploy/#{stage}.rb"

set(:unicorn_env) { rails_env }

set :application, "icoach_app"
set :user, "deployer"
set :port, 1026
set :deploy_to, "/home/#{user}/rails_apps/#{fetch :rails_env}/#{application}"
set :current_path, File.join(deploy_to, current_dir)
set :shared_path,  File.join(deploy_to, shared_dir) 
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "git@github.com:Smoggy/icoach_app_1.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end

  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
    puts "Now edit #{shared_path}/config/database.yml and add your username and password"
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"
end