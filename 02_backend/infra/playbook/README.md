# Required

-   [Ansible](https://www.ansible.com/)

# Preparation

## SSH Config

```
Host stg.wadb.app
  HostName [Lightsailで発行されたPublic IPアドレス]
  User ubuntu
  ServerAliveInterval 30
  IdentityFile [秘密鍵]
  ProxyCommand [プロキシ等の設定があればコマンドを書く]
```

# Deployment

## 開発環境

```bash
cd infra/playbook
# https://github.com/sora-corporation/web-app-deploy-basic/wiki/hosts.staging
# を hosts.staging というファイル名で保存
ansible-playbook -i ./hosts.staging staging.yml
```

## 本番環境

```bash
cd infra/playbook
# https://github.com/sora-corporation/web-app-deploy-basic/wiki/hosts.production
# を hosts.production というファイル名で保存
ansible-playbook -i ./hosts.production production.yml
```