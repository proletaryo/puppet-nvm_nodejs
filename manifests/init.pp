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

  # NOTE:
  # this requires git, curl, make... need to check this?

  if ! defined(User[$user]) {
    # create the user
    user { $user:
      ensure     => present,
      shell      => '/bin/bash',
      home       => "/home/${user}",
      managehome => true,
    }
  }

  # node executable
  $NODE_EXEC = "/home/${user}/.nvm/v${version}/bin/node"

  # install via script
  exec { 'nvm-install-script':
    command     => 'curl https://raw.github.com/creationix/nvm/master/install.sh | sh',
    cwd         => "/home/${user}/",
    user        => $user,
    creates     => "/home/${user}/.nvm/nvm.sh",
    environment => [ "HOME=/home/${user}" ],
    require     => User[$user],
  }

  exec { 'nvm-install-node':
    command  => "source /home/${user}/.nvm/nvm.sh && nvm install ${version}",
    cwd      => "/home/${user}/",
    user     => $user,
    unless   => "test -e /home/${user}/.nvm/v${version}/bin/node",
    provider => shell,
    environment => [ "HOME=/home/${user}" ],
    require  => User[$user],
  }

  notify { 'node-exec':
    message => "nvm_nodejs, node executable is ${NODE_EXEC}",
  }

  Exec['nvm-install-script']->Exec['nvm-install-node']~>Notify['node-exec']
}

