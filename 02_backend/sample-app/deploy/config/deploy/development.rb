set :branch, "main"
set :pty, false

server "dev.wadb.app", roles: %w[web app db job]

set :ssh_options, {
  user: "ubuntu",
  forward_agent: true,
  auth_methods: %w[publickey]
}
