# puppet-nvm_nodejs

Localized installation of multiple versions of nodejs via [NVM](https://github.com/creationix/nvm).

Tested to work on 64-bit:

  * AWS Linux
  * CentOS 6.x
  * Ubuntu 12.04

## Parameters
  * `user`        : target user to install node into
  * `version`     : must be the full version (format: x.x.x)
  * `manage_user` : specify if the user resource should be created or not,
    defaults to false (format: boolean)
  * `home`        : set the target home dir. defaults to `/home/${user}` if skipped

## Usage

Basic:

    class { 'nvm_nodejs':
      user    => 'prod',    # this will create /home/prod automatically
      manage_user => true,
      version => '0.8.22',
    }

    class { 'nvm_nodejs':
      user    => 'jenkins',
      version => '0.8.22',
      home    => '/var/tmp/jenkins',  # explicit home location
    }

## Paths and executables

Once the class was successfully declared, access these variables:

  * `$nvm_nodejs::NODE_PATH` : path to the bin directory
  * `$nvm_nodejs::NODE_EXEC` : full executable path of `node` engine
  * `$nvm_nodejs::NPM_EXEC`  : full executable path of `npm` 

## Dependencies

This module relies on following packages to be installed via puppet:
  * git
  * curl
  * make
