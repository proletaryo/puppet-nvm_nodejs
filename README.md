# puppet-nvm_nodejs

Localized installation of multiple versions of nodejs via [NVM](https://github.com/creationix/nvm).

Tested to work on 64-bit:

  * AWS Linux
  * CentOS 6.x

## Parameters
  * `user`    : target user to install node into
  * `version` : must be the full version (format: x.x.x)

## Usage

Basic:

    class { 'nvm_nodejs':
      user    => 'prod',
      version => '0.8.22',
    }

## Paths and executables

Once the class was successfully declared, access these variables:

  * `$nvm_nodejs::NODE_PATH` : path to the bin directory
  * `$nvm_nodejs::NODE_EXEC` : full executable path of `node` engine
  * `$nvm_nodejs::NPM_EXEC`  : full executable path of `npm` 

## Dependencies

This module relies on following packages (install it beforehand, either manually or via puppet):

  * git
  * curl
  * make
