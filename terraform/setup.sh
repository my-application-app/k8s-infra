#!/bin/bash

# === Install GitHub Runner ===
sudo apt-get update -y
sudo apt-get install -y curl tar jq

# Create runner directory
sudo mkdir -p /home/ubuntu/actions-runner
cd /home/ubuntu/actions-runner

# Download and extract runner
curl -o actions-runner.tar.gz -L https://github.com/actions/runner/releases/download/v2.328.0/actions-runner-linux-x64-2.328.0.tar.gz
tar xzf ./actions-runner.tar.gz
rm actions-runner.tar.gz

echo "Runner token received: ${runner_token}" >> /var/log/user-data.log

sudo chown -R ubuntu:ubuntu /home/ubuntu/actions-runner

# Configure runner as ubuntu user
sudo -u ubuntu ./config.sh --unattended \
  --url https://github.com/my-appliocation-app \
  --token "${runner_token}" \
  --name org_runner \
  --work "_work" >> /var/log/runner-config.log 2>&1

# Install and start service
sudo ./svc.sh install
sudo ./svc.sh start
