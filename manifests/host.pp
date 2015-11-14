# rsync_cron::host
# ================
# Setup a host so that a node classified with rsync::agent can connect to it
#
# Parameters
# ==========
# [*title*]
#   key name(s) to allow connection
# [*incoming_dirs*]
#   list of directories to create locally for file storage
# [*user*]
#   user to own any created directories.  defaults to `rsync`
# [*group*]
#   group to own any created directories
# [*mode*]
#   mode to set for any created directories
# [*home_dir*]
#   override the default home directory of `/home/$user/`
define rsync_cron::host(
    $incoming_dirs   = $rsync_cron::params::dir,
    $authorized_keys = $title,
    $user            = $rsync_cron::params::user,
    $group           = $rsync_cron::params::group,
    $mode            = $rsync_cron::params::mode,
    $home_dir        = false,
) {

  File {
    owner  => $user,
    group  => $group,
    mode   => $mode,
  }

  if $home_dir {
    $_home_dir = $home_dir
  } else {
    $_home_dir = "/home/${user}"
  }


  # directory to hold rsync'ed files
  file { $incoming_dirs:
    ensure => directory,
  } 

  # user account that agents ssh into when copying files
  user { $user:
    ensure  => present,
    home    => $_home_dir,
  }

  # home directory for user
  file { $_home_dir:
    ensure => directory,
  }

  # keys themselves need to be generated separately

  # authorise each agent to connect
  sshkeys::authorize { $user:
    authorized_keys => $authorized_keys,
    require         => File[$_home_dir],
  }

}
