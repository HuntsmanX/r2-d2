# config valid only for Capistrano 3.1
lock '3.4'

set :application, 'r2-d2'
set :repo_url, 'git@github.com:Zone3000/r2-d2.git'
set :rvm_type, :user
set :rvm_ruby_version, '2.1.3'
set :deploy_to, '/var/www/apps/r2-d2'
set :backup_path, '/home/deployer/Backup'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

application = 'r2-d2'

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      sudo "service unicorn_r2d2 stop"
      sudo "service resque_scheduler_r2d2 stop"
      sudo "service resque_worker_whois_r2d2 stop"
      sudo "service resque_worker_bulk_curl_r2d2 stop"
      sudo "service resque_worker_mailers_r2d2 stop"
    end
  end

  desc 'Setup'
  task :setup do
    on roles(:all) do
      execute "mkdir  #{shared_path}/config/"
      execute "mkdir  /var/www/apps/#{application}/run/"
      execute "mkdir  /var/www/apps/#{application}/log/"
      execute "mkdir  /var/www/apps/#{application}/socket/"
      execute "mkdir #{shared_path}/system"

      upload!('shared/database.yml', "#{shared_path}/config/database.yml")
      upload!('shared/secrets.yml', "#{shared_path}/config/secrets.yml")
      upload!('shared/nginx.conf', "#{shared_path}/nginx.conf")
      upload!('shared/nginx_server_block', "#{shared_path}/nginx_server_block")
      upload!('shared/unicorn_init.sh', "#{shared_path}/unicorn_init.sh")
      upload!('shared/resque_scheduler_init.sh', "#{shared_path}/resque_scheduler_init.sh")
      upload!('shared/resque_worker_whois_init.sh', "#{shared_path}/resque_worker_whois_init.sh")
      upload!('shared/resque_worker_bulk_curl_init.sh', "#{shared_path}/resque_worker_bulk_curl_init.sh")
      upload!('shared/resque_worker_mailers_init.sh', "#{shared_path}/resque_worker_mailers_init.sh")

      sudo "service nginx stop"
      sudo "rm -f /etc/nginx/nginx.conf"
      sudo "ln -s #{shared_path}/nginx.conf /etc/nginx/nginx.conf"
      sudo "ln -s #{shared_path}/nginx_server_block /etc/nginx/sites-enabled/r2-d2.nmchp.com"
      sudo "service nginx start"

      sudo "ln -s #{shared_path}/unicorn_init.sh /etc/init.d/unicorn_r2d2"
      sudo "ln -s #{shared_path}/resque_scheduler_init.sh /etc/init.d/resque_scheduler_r2d2"
      sudo "ln -s #{shared_path}/resque_worker_whois_init.sh /etc/init.d/resque_worker_whois_r2d2"
      sudo "ln -s #{shared_path}/resque_worker_bulk_curl_init.sh /etc/init.d/resque_worker_bulk_curl_r2d2"
      sudo "ln -s #{shared_path}/resque_worker_mailers_init.sh /etc/init.d/resque_worker_mailers_r2d2"

      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "db:create"
        end
      end
    end
  end

  desc 'Create symlink'
  task :symlink do
    on roles(:all) do
      execute "ln -s #{shared_path}/config/database.yml #{release_path}/config/database.yml"
      execute "ln -s #{shared_path}/config/secrets.yml #{release_path}/config/secrets.yml"
      execute "ln -s #{shared_path}/system #{release_path}/public/system"
    end
  end

  desc 'Update secrets.yml'
  task :secrets do
    on roles(:all) do
      execute "rm /var/www/apps/r2-d2/current/config/secrets.yml"
      execute "rm /var/www/apps/r2-d2/shared/config/secrets.yml"
      upload!('shared/secrets.yml', '/var/www/apps/r2-d2/shared/config/secrets.yml')
      execute "ln -s /var/www/apps/r2-d2/shared/config/secrets.yml /var/www/apps/r2-d2/current/config/secrets.yml"
    end
  end

  after :finishing, 'deploy:cleanup'
  after :finishing, 'deploy:restart'

  after :updating, 'deploy:symlink'

  after :setup, 'deploy'

  before :setup, 'deploy:starting'
  before :setup, 'deploy:updating'
  before :setup, 'bundler:install'

  after :secrets, 'deploy:restart'

end
