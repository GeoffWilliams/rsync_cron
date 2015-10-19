define rsync::host(
    $incoming_dirs   = $rsync::params::dir,
    $authorized_keys = $title,
    $user            = $rsync::params::user,
    $group           = $rsync::params::group,
    $mode            = $rsync::params::mode,
    $home_dir        = "/home/${user}",
) {

  # directory to hold rsync'ed files
  file { $incoming_dirs:
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => $mode,
  } 

  # user that agents ssh in as to copy files
  user { $user:
    ensure  => present,
    homedir => $home_dir,
  }

  # keys are generated separately

  # authorise each agent to connect
  sshkeys::authorize { $user:
    authorized_keys => $authorized_keys,
  }

}
