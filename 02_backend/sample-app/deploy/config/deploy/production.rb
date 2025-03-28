set :branch, "main"
set :pty, false

server "prod.wadb.web.a", roles: %w[web app]
server "prod.wadb.web.c", roles: %w[web app]
server "prod.wadb.job", roles: %w[app db job]

set :ssh_options, {
  user: "ubuntu",
  forward_agent: true,
  auth_methods: %w[publickey]
}
