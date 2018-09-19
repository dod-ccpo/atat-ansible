# ATAT Ansible

## Description

This is a respository containing the Ansible code used to manage the servers
running the base infrastructure for ATAT. At the time of this writing, that would
be the Kubernetes Master and the three Kubernetes Workers hosting all of the
applications and services for the Staging environments.

## Installation

### System Requirements

This code should be usable by a regular Ansible installation. Ansible requires
Python, and creating a virtual environment is recommended. Python 3 is supposed
to work, but if you encounter errors, try using a Python 2.7 environment.

### Running
* All playbooks require that a private SSH key be identified via extra-vars which
  Ansible will use to connect as the `ansible` user (aside from a special
bootstrap host, which SSHs as `root`)
* Possible variables that can be passed via the CLI:
 * `target_host` - Used by the bootstrap host. Specifies the IP of the server
   Ansible should configure.
 * `target_ssh_key` - The private key Ansible should use when making an SSH
   connection to the specified host(s)
* Example commands:
 * `ansible-playbook bootstrap.yml --extra-vars "target_ssh_key=~/.ssh/foo_rsa
   target_host=10.1.1.10"`
 * `ansible-playbook kubernetes.yml --extra-vars "target_ssh_key=~/.ssh/foo_rsa"`

#### Inventory
This repository uses a static inventory located in the `/inventory` subdirectory.

#### Group Vars
Various sets of variables will be inherited based on a host's group membership
and the contents of the `/group_vars` subdirectory

#### Roles
* `atat.base` - Applies basic configuration changes to all servers.
 * Updates all installed packages to the most recent version
 * Ensures the default packages are installed
 * Sets a command prompt
 * Adds ATAT user and group
 * Configures the firewall
  * Deny incoming traffic by default
  * Allow SSH traffic
* `atat.ssh_access` - Sets up sshd and local users for remote access.
 * Creates users
 * Adds the public keys for each user
 * Adds users to sudo
 * Swaps out the sshd config (includes changes like disabling SSH in as root)
* `grycap.kubernetes` - Installation and basic setup for Kubernetes servers
  (pulled from Ansible Galaxy)
* `atat.kube` - Applies ATAT specific settings and firewall rules related to
  running and managing the Kubernetes cluster.

#### Playbooks
* `bootstrap.yml` - Used to bootstrap a new Rackspace server.
 * Installs Python 2 for Ansible to use when gathering facts
 * Runs the `atat.base` and the `atat.ssh_access` roles
* `rackspace_base.yml` - Used to continue the management of a Rackspace server
  that has been bootstrapped.
 * Runs the `atat.base` and the `atat.ssh_access` roles
* `kubernetes.yml` - Applies Kubernetes related roles to the appropriate servers
  in the inventory, based on which groups they belong to.
