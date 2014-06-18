class nvm_nodejs (
  $user,
  $version,
  $home = "/home/${user}",
) {

  Exec {
    path => [
       '/usr/local/bin',
       '/usr/bin',
       '/usr/sbin',
       '/bin',
       '/sbin',
    ],
    logoutput => on_failure,
  }

  # NOTE: supports full version numbers (x.x.x) only, otherwise node path will be wrong
  validate_re($version, '^\d+\.\d+\.\d+$',
    'Please specify a valid nodejs version, format: x.x.x (e.g. 0.8.10)')

  if ! defined(User[$user]) {
    # create the user
    user { $user:
      ensure     => present,
      shell      => '/bin/bash',
      home       => $home,
      managehome => true,
    }
  }

  # node path and executable
  $NODE_PATH  = "${home}/.nvm/v${version}/bin"
  $NODE_EXEC  = "${NODE_PATH}/node"
  $NPM_EXEC   = "${NODE_PATH}/npm"

  # dependency check
  exec { 'check-needed-packages':
    command     => 'which git && which curl && which make',
    user        => $user,
    environment => [ "HOME=${home}" ],
    require     => User[$user],
  }

  # install via script
  exec { 'nvm-install-script':
    command     => 'curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | sh',
    cwd         => $home,
    user        => $user,
    creates     => "${home}/.nvm/nvm.sh",
    # onlyif      => [ 'which git', 'which curl', 'which make' ],
    environment => [ "HOME=${home}" ],
    refreshonly => true,
  }

  exec { 'nvm-install-node':
    command     => "source ${home}/.nvm/nvm.sh && nvm install ${version}",
    cwd         => $home,
    user        => $user,
    unless      => "test -e ${home}/.nvm/v${version}/bin/node",
    provider    => shell,
    environment => [ "HOME=/${home}" ],
    refreshonly => true,
  }

  # sanity check
  exec { 'nodejs-check':
    command     => "${NODE_EXEC} -v",
    user        => $user,
    environment => [ "HOME=${home}" ],
    refreshonly => true,
  }

  # # print path
  # notify { 'node-exec':
  #   message => "nvm_nodejs, node executable is ${NODE_EXEC}",
  # }

  # order of things
  Exec['check-needed-packages']~>Exec['nvm-install-script']
    ~>Exec['nvm-install-node']~>Exec['nodejs-check'] # ~>Notify['node-exec']
}

