## Magento 2 Vagrant Box

A simple way to get an integrator developer instance of Magento2 up and running. It consists of a Debian Wheezy box, provisioned via Puppet. The provider is VirtualBox, and it will install apache2 +fastcgi, php, php-fpm, mysql and any other necessary dependancies.

Magento 2 is using the community edition composer metapackage as a source. This means developers can easily use this as a basis for their production instance, plugging in a few more deployment actions. This will also enhance upgradability and bigfixing (as these will be distributed to the composer repository without requiring any direct patching, and it keeps the core code away from the developer to avoid "hacks").

This is based heavily on https://github.com/rgranadino/mage2_vagrant - with modifications to fit my personal tastes/needs

### Usage
#### Installation
1. Clone this repository: `git clone --recursive https://github.com/lilmuckers/magento2-vagrant-boilerplate.git`
2. Navigate to the repository in the command line via `cd`
  * **IMPORTANT**: If you cloned the repository without the *--recursive* param, you need to initialize the required submodules: `git submodule update --init --recursive`
3. Start up the virtual machine: `vagrant up`
4. Configure composer `auth.json` in the project root. (see `setupconfig/auth.json.template` for fields)
  * Magento auth keys: http://devdocs.magento.com/guides/v2.0/install-gde/prereq/connect-auth.html
  * Github oauth token: https://help.github.com/articles/creating-an-access-token-for-command-line-use/
5. If you are **online** I have set up a domain on my personal DNS for the VM so no DNS config will be needed: http://dev.patrick-mckinley.com/
  * If you are **offline** you will need to set a hostfile change: `echo '192.168.33.10 'dev.patrick-mckinley.com' >> /etc/hosts`
6. Once the machine completes provisioning, SSH to the server: `vagrant ssh`
7. Install magento2 by running `cd /var/www/mage2 && composer install && reinstall`
  * This may take a while to run as it will download Magento 2 from scratch and create a composer.lock file.

#### Updating
1. From the host machine run `git pull && git submodule update --init && vagrant provision`.
  * If there is an update to the *manifests/mage.pp* or *files/** files it is recommended to provision the guest machine. This can be done by running: `vagrant provision`. There is also a cron that runs every 15 minutes to
provision within the guest machine in the event it's not done after updating.
2. If you want to start from a clean slate run: `reinstall` from within the guest machine. This will uninstall the application and reinstall it from scratch.

#### Configuration
To change/view any of the default configuration for magento2 in this setup - view the `setupconfig/mage-settings.ini`. It uses the standard magento setup arguments detailed here: http://devdocs.magento.com/guides/v2.0/install-gde/install/cli/install-cli-install.html#instgde-install-cli-magento

#### Shell Aliases / Scripts
* `m` - cd into the base magento directory: /var/www/mage2
* `reinstall` - run magento shell uninstall script with the `cleanup_database` flag and run installation again, uses `http://mage2.dev` as base URL
 * `reinstall -s` - install magento with sample data
* `mt` - run bulk magento test suites

#### Status and Debug utilities
A status vhost on port 88 has been setup to view apache's server status, php-fpm status as well as some other utilities.

* http://dev.patrick-mckinley.com:88/server-status
* http://dev.patrick-mckinley.com:88/fpm-status
* http://dev.patrick-mckinley.com:88/info.php
* http://dev.patrick-mckinley.com:88/opcache.php

### Magento Admin User
* Username: admin
* Password: password123
* Admin URL: http://dev.patrick-mckinley.com/admin

### Database Info
* Username: root
* Password: mage2
* DB Name: mage2

### SSH Info
* username: vagrant
* password: vagrant

It's also possible to use `vagrant ssh` from within the project directory


### TODO
* mysql (my.cnf) config allow outside access
* add nicer $PS1
* Disable xdebug for PHP cli for composer, and alias php command to enable xdebug (see composer xdebug page)
* fix running of composer install command on provision
* script to install sample data
