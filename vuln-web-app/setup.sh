#!/bin/bash

# Update and install dependencies
echo "Updating system and installing dependencies..."
apt-get update
apt-get install -y curl build-essential git

# Install Node.js and npm
echo "Installing Node.js and npm..."
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

# Create empty directory structure
echo "Setting up directory structure..."
mkdir -p /home/vagrant/app/files
mkdir -p /home/vagrant/app/public

# Create example files for path traversal testing
echo "Creating dummy files for testing..."
echo "This is a secret file that should not be accessible!" > /home/vagrant/secret.txt
echo "This is a test file within the allowed directory." > /home/vagrant/app/files/test.txt

# Install required Node.js packages
echo "Installing Node.js packages..."
cd /home/vagrant/app
npm init -y
npm install express body-parser

# Create a non-privileged user to run the application
echo "Setting up non-privileged user..."
useradd -m appuser

# Set up systemd service to start the app automatically
echo "Setting up systemd service..."
cat > /etc/systemd/system/vulnapp.service << EOF
[Unit]
Description=Vulnerable Node.js Application
After=network.target

[Service]
Type=simple
User=appuser
WorkingDirectory=/home/vagrant/app
ExecStart=/usr/bin/node /home/vagrant/app/app.js
Restart=on-failure
Environment=NODE_ENV=development

[Install]
WantedBy=multi-user.target
EOF

# Set up file permissions
echo "Setting up file permissions..."
chown -R vagrant:vagrant /home/vagrant/app
chmod 755 /home/vagrant/app

# Copy app.js to the app directory if it doesn't exist yet
if [ ! -f /home/vagrant/app/app.js ]; then
    echo "Creating placeholder app.js..."
    cat > /home/vagrant/app/app.js << EOF
// This is a placeholder, put your vulnerable app code here
// or use the synced folder to update it from your host machine
const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.send('Vulnerable app is running! Replace this file with your actual app.js code.');
});

app.listen(port, '0.0.0.0', () => {
  console.log(\`Vulnerable app listening at http://0.0.0.0:\${port}\`);
});
EOF
fi

# Create a default index.html in public folder
cat > /home/vagrant/app/public/index.html << EOF
<!DOCTYPE html>
<html>
<head>
    <title>Vulnerable App</title>
</head>
<body>
    <h1>Vulnerable App Server</h1>
    <p>This is a deliberately vulnerable application for security testing purposes.</p>
</body>
</html>
EOF

# Enable and start the service
echo "Starting the application service..."
systemctl enable vulnapp.service
systemctl start vulnapp.service

# Install some additional tools for testing
echo "Installing additional security tools..."
apt-get install -y nmap netcat-openbsd curl wget

# Create a simple setup guide for the user
cat > /home/vagrant/README.md << EOF
# Vulnerable App Testing Environment

This VM is set up for testing web application security vulnerabilities.

## Important Information

- The vulnerable app is running at: http://localhost:3000
- App code is located at: /home/vagrant/app/
- Service name: vulnapp
- To restart the service: sudo systemctl restart vulnapp

## Useful Commands

- View service logs: journalctl -u vulnapp
- Start/stop the service: sudo systemctl start/stop vulnapp
- Check status: sudo systemctl status vulnapp

## Security Testing Tools Available

- nmap: Network scanner
- nc (netcat): Networking utility
- curl/wget: HTTP interaction tools

Happy hacking!
EOF

echo "Setup complete!"
