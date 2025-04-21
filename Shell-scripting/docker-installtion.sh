#!/bin/bash

echo << EOF
"=========================================================="
"||     Set up Docker's Apt repository ...............   ||"
"=========================================================="
EOF

# Set up Docker's Apt repository

# Add Docker's official GPG key (suppress output)
sudo apt-get update -y > /dev/null 2>&1
sudo apt-get install ca-certificates curl gnupg -y > /dev/null 2>&1
sudo install -m 0755 -d /etc/apt/keyrings > /dev/null 2>&1
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg > /dev/null 2>&1
sudo chmod a+r /etc/apt/keyrings/docker.gpg > /dev/null 2>&1

# Add the repository to Apt sources (suppress output)
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y > /dev/null 2>&1

echo << EOF
"=========================================================="
"||   Docker's Apt repository is completed...........    ||"
"=========================================================="
EOF

echo << EOF
"=========================================================="
"||   Install the Docker packages....................    ||"
"=========================================================="
EOF

# Install Docker packages (suppress output)
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y > /dev/null 2>&1

echo << EOF
"=========================================================="
"||   Install is completed ....................    ||"
"=========================================================="
EOF

# Get Docker status and version
dockerStatus=$(systemctl status docker | awk '/Active/ {print $3}' | tr -d "[()]")
dockerVersion=$(docker -v | awk '/version/ {print $3}' | tr -d ",")

# Print the status and version
echo "The Docker status is $dockerStatus"
echo "The Docker version is $dockerVersion"