define rsync_cron::host(
    $incoming_dirs   = $rsync_cron::params::dir,
    $authorized_keys = [ $title ],
    $user            = $rsync_cron::params::user,
    $group           = $rsync_cron::params::group,
    $mode            = $rsync_cron::params::mode,
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
    home    => $home_dir,
  }

  # keys are generated separately

  # authorise each agent to connect
  sshkeys::authorize { $user:
    authorized_keys => $authorized_keys,
  }

}
