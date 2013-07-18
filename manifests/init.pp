class nvm_nodejs (
  $user,
  $version,
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

  # TODO:
  # can only support full version numbers (x.x.x), otherwise node path will be wrong
  # need to to enforce it somehow

  if ! defined(User[$user]) {
    # create the user
    user { $user:
      ensure     => present,
      shell      => '/bin/bash',
      home       => "/home/${user}",
      managehome => true,
    }
  }

  # node path and executable
  $NODE_PATH  = "/home/${user}/.nvm/v${version}/bin"
  $NODE_EXEC  = "${NODE_PATH}/node"
  $NPM_EXEC   = "${NODE_PATH}/npm"

  # dependency check
  exec { 'check-needed-packages':
    command     => 'which git && which curl && which make',
    user        => $user,
    environment => [ "HOME=/home/${user}" ],
    require     => User[$user],
  }

  # install via script
  exec { 'nvm-install-script':
    command     => 'curl https://raw.github.com/creationix/nvm/master/install.sh | sh',
    cwd         => "/home/${user}/",
    user        => $user,
    creates     => "/home/${user}/.nvm/nvm.sh",
    # onlyif      => [ 'which git', 'which curl', 'which make' ],
    environment => [ "HOME=/home/${user}" ],
    refreshonly => true,
  }

  exec { 'nvm-install-node':
    command     => "source /home/${user}/.nvm/nvm.sh && nvm install ${version}",
    cwd         => "/home/${user}/",
    user        => $user,
    unless      => "test -e /home/${user}/.nvm/v${version}/bin/node",
    provider    => shell,
    environment => [ "HOME=/home/${user}" ],
    refreshonly => true,
  }

  # sanity check
  exec { 'nodejs-check':
    command     => "${NODE_EXEC} -v",
    user        => $user,
    environment => [ "HOME=/home/${user}" ],
    refreshonly => true,
  }

  # print path
  notify { 'node-exec':
    message => "nvm_nodejs, node executable is ${NODE_EXEC}",
  }

  # order of things
  Exec['check-needed-packages']~>Exec['nvm-install-script']
    ~>Exec['nvm-install-node']~>Exec['nodejs-check']~>Notify['node-exec']
}

