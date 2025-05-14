#!/bin/bash

export AWS_DEFAULT_PROFILE=web-app-deploy-basic
aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin 969649391948.dkr.ecr.ap-northeast-1.amazonaws.com
docker build --platform linux/amd64 -t web-app-deploy-basic-development .
docker tag web-app-deploy-basic-development:latest 969649391948.dkr.ecr.ap-northeast-1.amazonaws.com/web-app-deploy-basic-development:latest
docker push 969649391948.dkr.ecr.ap-northeast-1.amazonaws.com/web-app-deploy-basic-development:latest
