require 'dotenv'
Dotenv.load!

# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'fortuna_luca'
set :repo_url, 'git@github.com:alepore/fortuna_luca.git'
set :deploy_to, "/var/www/#{fetch(:application)}"

set :linked_files, fetch(:linked_files, []).push('.env')

server ENV['DEPLOY_SERVER'],
  user: ENV['DEPLOY_USER'],
  roles: [:app, :web],
  ssh_options: { forward_agent: true }

set :rvm_type, :user
set :rvm_ruby_version, '2.1.5'

namespace :deploy do
  after :publishing, :start_bot do
    on roles(:app) do
      within current_path do
        execute :bundle, 'exec ruby bin/bot'
      end
    end
  end
end
