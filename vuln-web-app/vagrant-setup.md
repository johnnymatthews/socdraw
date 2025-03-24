# Vulnerable App Testing Environment Setup

This guide will help you set up a Vagrant box for testing your vulnerable Node.js application.

## Prerequisites

- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- [Vagrant](https://www.vagrantup.com/downloads)
- Basic familiarity with command line

## Setup Instructions

1. **Create a new directory for your project**

   ```bash
   mkdir vulnerable-app-test
   cd vulnerable-app-test
   ```

2. **Create the required files**

   Create the following files in your project directory:
   - `Vagrantfile` (use the content from the Vagrantfile artifact)
   - `setup.sh` (use the content from the setup.sh artifact)
   - Create an `app` subdirectory

3. **Place your vulnerable app in the app directory**

   Copy the vulnerable Node.js application code (from the previous artifact) into a file named `app.js` in the `app` directory.

   ```bash
   mkdir -p app/files app/public
   # Copy the Node.js vulnerable app code into app/app.js
   ```

4. **Start the Vagrant environment**

   ```bash
   vagrant up
   ```

   This will:
   - Download the Ubuntu 22.04 base image
   - Configure the VM with the specified settings
   - Run the setup script to install Node.js and dependencies
   - Start your vulnerable application automatically

5. **Access your vulnerable application**

   Once the VM is running, you can access your application at:
   - http://192.168.56.10:3000
   - http://localhost:3000

6. **SSH into the VM**

   If you need to make changes or debug:

   ```bash
   vagrant ssh
   ```

7. **Testing your application**

   You can now use tools like Burp Suite, OWASP ZAP, or even just your browser to test the vulnerabilities in your application.

## Directory Structure

```
vulnerable-app-test/
├── Vagrantfile
├── setup.sh
└── app/
    ├── app.js         # Your vulnerable Node.js application
    ├── files/         # Directory for file-related vulnerabilities
    └── public/        # Public web files
```

## Managing the Vagrant Box

- **Stop the VM**: `vagrant halt`
- **Restart the VM**: `vagrant reload`
- **Destroy the VM**: `vagrant destroy`

## Service Management

If you need to restart your application:

```bash
vagrant ssh -c "sudo systemctl restart vulnapp"
```

To view logs:

```bash
vagrant ssh -c "sudo journalctl -u vulnapp"
```

## Security Considerations

This setup creates an intentionally vulnerable environment. Please ensure:

1. You run this on a private network or behind a firewall
2. Do not expose this to the internet
3. Use this for educational purposes only
4. Consider using NAT networking instead of bridged if working in a shared environment

## Additional Files

For comprehensive testing, you might want to add these to your `app` directory:

- A `package.json` file with proper dependencies
- More test files in the `files` directory for path traversal testing
- User data files for authentication testing
