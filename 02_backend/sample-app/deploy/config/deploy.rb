# require "seed-fu/capistrano3"

set :application, "sample-app"
set :repo_url, "git@github.com:sora-corporation/web-app-deploy-basic.git"
set :repo_tree, '02_backend/sample-app'

set :deploy_to, "/home/www/#{fetch(:application)}"
set :keep_releases, 3

set :rbenv_type, :user
set :rbenv_ruby, "3.4.2"
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w[rake gem bundle ruby rails puma pumactl]
set :rbenv_roles, :all

set :linked_dirs, %w[log tmp/backup tmp/pids tmp/cache tmp/sockets vendor/bundle]

# puma
set :puma_systemctl_user, :system
set :puma_service_unit_name, "puma.service"

# before "deploy:publishing", "db:seed_fu"
