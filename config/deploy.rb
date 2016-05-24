require 'dotenv'
Dotenv.load!

# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'fortuna_luca'
set :repo_url, 'git@github.com:alepore/fortuna_luca.git'
set :deploy_to, "/var/www/#{fetch(:application)}"

set :linked_files, fetch(:linked_files, []).push('.env')
set :linked_dirs, fetch(:linked_dirs, []).push('log')

server ENV['DEPLOY_SERVER'],
  user: ENV['DEPLOY_USER'],
  roles: [:app, :web],
  ssh_options: { forward_agent: true }

set :rvm_type, :user
set :rvm_ruby_version, '2.1.5'
set :rvm_map_bins, fetch(:rvm_map_bins, []).push('nohup')

set :whenever_roles, :app

after 'deploy:publishing', 'bot:start' do
  on roles(:app) do
    within current_path do
      execute :nohup, "bundle exec ruby bin/bot >> /dev/null 2>&1 & sleep 3", pty: false
    end
  end
end
