# Params
# ------
# [*host*]
#   Server to copy files to via rsync
# [*keyfile*]
#   Path to public ssh key on 

define rsync::agent(
    $local_user  = $rsync::params::user,
    $local_dirs  = [ $rsync::params::dir ],
    $remote_user = $rsync::params::user,
    $remote_dir  = $rsync::params::dir,
    $host,
    $key_file,
    $hour     = "*/4",
    $minute   = "*",
    $month    = "*",
    $monthday = "*",
    $weekday  = "*",
) {

  $_local_dirs = join($local_dirs, " ")

  cron { logrotate,
    command  => "ping -c ${host} && rsync -avz -e 'ssh -l ${remote_user} -i ${key_file}' ${_local_dir} ${remote_user}@${host}:${remote_dir}",
    user     => $user,
    hour     => $hour,
    minute   => $minute,
    month    => $month,
    monthday => $monthday,
    weekday  => $weekday,
    path     => [ "/bin", "/usr/bin"],
  }

  sshkeys::install_keypair { "${user}@${fqdn}": 
    user => $user,
  }

}
