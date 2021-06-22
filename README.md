# RPC_Service
A minimal interface for Linux on Windows host. This runs a linux as a VM (Virtualbox) in the background and creates a easy interface to interact with it (CLI & GUI) on windows host without changing of tabs and display.


## Features
- Run `linux` command anywhere to change ur shell to linux at that directory.
- Added context menu entry to open ur favourite linux terminal at that directory.
- Run all GUI applications without switiching to Virtual Box tab.

## Installation

### Prequisites (Windows)
- Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads/) along with Guest Additions (preferably at default location)
- Install [Windows X11 server](https://sourceforge.net/projects/vcxsrv/) (preferably at default location)
- Install [Python3](https://www.python.org/downloads/) and add to path
- Install [Git](https://git-scm.com/downloads/) and add to path

### VM

**VirtualBox Configuration**
- Install a linux based OS (preferably Ubuntu Server bcz u don't need Desktop Environment)
- Install VBox guest additions (probably need on every kernel update) (`build-essential` will be needed)
- Configure `Settings > Network` to use a `Host-only adapter`. Also add a Network Adapter of `Bridged Adapter` if u want to use your linux VM on other LAN devices
- Add shared folders of all drives at drive name with `Auto-Mount` and `Make Permanent` flags. E.g. `C_DRIVE` is mounted at `/c/`

**Setting up display**
- Change the following in `/etc/default/grub`
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash" -->  GRUB_CMDLINE_LINUX_DEFAULT="quiet splash text"
GRUB_CMDLINE_LINUX=""                     -->  GRUB_CMDLINE_LINUX="text"
```
And run `sudo update-grub`
- Run `sudo systemctl disable display-manager.service` if u had any desktop environment
- Run `echo "DISPLAY=192.168.56.1:0" | sudo tee -a /etc/environment` if ur host is at `192.168.56.1` (See with `ipconfig` on windows)
- You may also need to run `echo "set \$DISPLAY=192.168.56.1:0" | tee -a ~/.profile`

### Windows
- Clone the repo where you want to install.
- Run `install.bat` as administrator

### Setting up SSH
**VM**
- Install OpenSSH server `sudo apt install openssh-server` and run `sudo systemctl start sshd.service` if the service is off.

**Windows**
- If you already have a SSH key pair, copy it to `.ssh` folder inside ur users folder (`C:\Users\<username>\.ssh`)
- If you dont have a key,
    - Open Git Bash and run the following command substituting the email address `ssh-keygen -t ed25519 -C "your_email@example.com"`
    - When you're prompted to "Enter a file in which to save the key," press Enter. This accepts the default file location. Also keep the passphrase empty and press Enter 2 times.
- If the SSH in VM is configured, run `ssh-copy-id <user>@<ip>` on Git Bash substituting the username in the VM and it's IP. Write the password and press enter when prompted.

## Usage
- Run `server-up` & `display-up` on any terminal to start them. (You can also add these scripts to `Windows Task Scheduler` to run them on startup)
- After sometime (boot of VM) run `linux` command on any shell to change into linux. You also use the `Open Linux Interface Here` context menu.
- Run `server-down` to shutdown the server
- You can change the VM by changing `\helper_scripts\vm.txt`
- You can change the username, IP, shell, terminal by updating contents of `\helper_scripts\config.txt`.