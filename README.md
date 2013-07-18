# puppet-nvm_nodejs

Localized installation of multiple versions of nodejs via [NVM](https://github.com/creationix/nvm).

Tested to work on 64-bit:
  * AWS Linux
  * CentOS 6.x

## Parameters
  * `user`    : target user to install
  * `version` : must be the full version (format: x.x.x)

## Usage

Basic:

    class { 'nvm_nodejs':
      user    => 'prod',
      version => '0.8.22',
    }

The path of the node executable is stored in `$nvm_nodejs::NODE_EXEC`.

## Dependencies

This module relies on following packages (install it beforehand, either manually or via puppet):
  * git
  * curl
  * make
