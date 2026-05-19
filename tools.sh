#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "========================================="
echo "🚀 Starting DevOps Tools Installation"
echo "========================================="

# Update and install prerequisite packages
sudo apt-get update -y
sudo apt-get install -y curl gnupg software-properties-common apt-transport-https ca-certificates lsb-release unzip

# ---------------------------------------------------------------------
# 1. INSTALL DOCKER
# ---------------------------------------------------------------------
echo "🐳 Installing Docker..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg --yes

# --- FIX APPLIED HERE (Removed duplicate /etc) ---
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start and enable Docker service
sudo systemctl enable docker
sudo systemctl start docker

# Add current user to docker group
sudo usermod -aG docker $USER

# ---------------------------------------------------------------------
# 2. INSTALL TERRAFORM
# ---------------------------------------------------------------------
echo "🛠️ Installing Terraform..."
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt-get update -y
sudo apt-get install -y terraform

# ---------------------------------------------------------------------
# 3. INSTALL AWS CLI
# ---------------------------------------------------------------------
echo "☁️ Installing AWS CLI..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
sudo ./aws/install
rm -rf aws awscliv2.zip

# ---------------------------------------------------------------------
# 4. INSTALL JENKINS
# ---------------------------------------------------------------------
echo "🏗️ Installing Jenkins (and OpenJDK 21)..."
sudo apt-get install -y openjdk-21-jre

sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/" | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y jenkins

# Start and enable Jenkins service
sudo systemctl enable jenkins
sudo systemctl start jenkins

#---------------------------------------------------------------------
sudo apt install tree
# ---------------------------------------------------------------------
# 🏁 VERIFICATION
# ---------------------------------------------------------------------
echo "========================================="
echo "✅ Installation Complete! Verifying Versions:"
echo "========================================="
docker --version
terraform --version
aws --version
java -version
jenkins --version

echo ""
echo "💡 IMPORTANT STEPS TO DO NEXT:"
echo "1. Run 'newgrp docker' to use Docker without sudo."
echo "2. Access Jenkins at: http://your_server_ip:8080"
echo "3. Run this command to get your initial Jenkins admin password:"
echo "   sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
echo "========================================="
