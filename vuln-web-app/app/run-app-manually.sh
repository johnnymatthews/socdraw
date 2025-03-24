#!/bin.bash

vagrant ssh -c "
  # Kill any existing node processes
  sudo pkill node || true
  
  # Make sure the app directory has proper permissions
  sudo chown -R vagrant:vagrant /home/vagrant/app
  
  # Verify the app.js file exists
  if [ ! -f /home/vagrant/app/app.js ]; then
    echo 'ERROR: app.js file not found!'
    exit 1
  fi

  # Make sure it listens on all interfaces
  sudo sed -i 's/app.listen(port)/app.listen(port, \"0.0.0.0\")/' /home/vagrant/app/app.js
  
  # Install dependencies if they're not already installed
  cd /home/vagrant/app && npm list express || npm install express
  cd /home/vagrant/app && npm list body-parser || npm install body-parser
  
  # Run the app in the background
  echo 'Starting Node.js application manually...'
  cd /home/vagrant/app && nohup node app.js > app.log 2>&1 &
  
  # Check if it's running
  sleep 2
  ps aux | grep node
  
  # Check listening ports
  sudo netstat -tulpn | grep node
  
  # Show how to view logs
  echo 'To view logs, run: cat /home/vagrant/app/app.log'
  
  # Show IP addresses
  echo 'VM IP addresses:'
  hostname -I
"
