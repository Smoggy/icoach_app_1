namespace :unicorn do

  desc 'Generate the unicorn.rb configuration file.'
  task :setup, roles: :app do
    run "mkdir -p #{shared_path}/config"
    template 'unicorn.rb', "#{shared_path}/config/unicorn.rb", true
  end
  after 'deploy:setup', 'unicorn:setup'

  desc 'Symlink the unicorn.rb file into latest release'
  task :symlink, roles: :app do
    run "ln -nfs #{shared_path}/config/unicorn.rb #{release_path}/config/unicorn.rb"
  end
  after 'deploy:finalize_update', 'unicorn:symlink'

end