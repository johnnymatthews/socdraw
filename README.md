<div align=center>
    <img alt="LLM-generated image: A whimsical illustration of a sock drawer overflowing with colorful computer code and a few mismatched socks." width=300 src="./socdraw-header-image.jpg" />
    <br><br>
    <p><strong>A repository of Vagrantfiles designed to simplify the process of setting up virtual environments for security professionals and enthusiasts. Whether you're practicing penetration testing, incident response, or digital forensics, these pre-configured Vagrantfiles provide a convenient way to spin up virtual machines tailored to your specific needs.</strong></p>
    <hr>
</div>

## Prerequisites

- [Vagrant](https://developer.hashicorp.com/vagrant/docs/installation) installed.
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

## Getting Started

1. Clone this repo:

   ```shell
   git clone https://github.com/johnnymatthews/socdraw.git
   ```

1. Navigate to a Vagrantfile directory:

   ```shell
   cd socdraw/attacker-ubuntu-24-04/
   ```

1. Initialize and start the VM:

   ```shell
   vagrant up
   ```

## Available VMs

- **Attacker Ubuntu 24.04:** A minimal Ubuntu VM for general attacks.
- **Vulnerable Defender W11 2024:** A particularly vulnerable Windows 11 environment that the Ubuntu Attacker box can attack.

## Contributing

If you have a Vagrantfile for a specific security scenario, feel free to submit a pull request.

- Ensure your Vagrantfile is well-documented and includes clear instructions.
- Consider using a consistent naming convention for your Vagrantfiles.
- Test your Vagrantfile thoroughly before submitting.

## License

This project is licensed under the GNU General Public License v3.0 License. The [Vagrant project](https://github.com/hashicorp/vagrant/blob/71150ee3d8c59c2e27acd8278ae0cad99d12f212/LICENSE), however, is not.
