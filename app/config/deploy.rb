# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'scarpa'
set :repo_url, 'git@bitbucket.org:logicitsolutions/scarpa.git'

set :deploy_to, '/var/www/scarpa'

set :rvm_type, :system
set :rvm_ruby_version, '2.3.0'

set :nvm_type, :user
set :nvm_node, 'v5.8.0'
set :nvm_map_bins, %w(node npm)

set :pty, true

set :slack_webhook, 'https://hooks.slack.com/services/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'

Airbrussh.configure do |config|
  config.command_output = true
end

set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

set :linked_dirs, fetch(:linked_dirs, []).push(
  'key',
  'certificates',
  'challenge',
  'log',
  'tmp/pids',
  'tmp/cache',
  'tmp/sockets',
  'vendor/bundle',
  'public/ckeditor_assets',
  'public/system',
  'public/spree',
  'node_modules',
  'client/node_modules'
)

namespace :unicorn do
  desc 'Reload application'
  task :reload do
    on roles(:app) do
      sudo 'kill -1 `cat /tmp/unicorn.pid`'
    end
  end
  after 'deploy:finishing', 'unicorn:reload'

  desc 'Start application'
  task :start do
    on roles(:app) do
      execute 'ps -ef | grep -v grep | grep -i unicorn && echo "Already started" || ' \
        'sudo /etc/init.d/unicorn_scarpa start'
    end
  end

  desc 'Stop application'
  task :stop do
    on roles(:app) do
      sudo '/etc/init.d/unicorn_scarpa stop'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app) do
      sudo '/etc/init.d/unicorn_scarpa stop'
      sudo '/etc/init.d/unicorn_scarpa start'
    end
  end

  desc 'Application status'
  task :status do
    on roles(:app) do
      execute 'ps -ef | grep -v grep | grep -i unicorn || echo "No unicorns found"'
    end
  end
end
