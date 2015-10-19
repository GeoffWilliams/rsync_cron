# Params
# ------
# [*host*]
#   Server to copy files to via rsync
# [*keyfile*]
#   Path to public ssh key on 

define rsync_cron::agent(
    $local_user  = $rsync_cron::params::user,
    $local_dirs  = [ $rsync_cron::params::dir ],
    $remote_user = $rsync_cron::params::user,
    $remote_dir  = $rsync_cron::params::dir,
    $host        = $title,
    $key_file,
    $hour     = "*/4",
    $minute   = "*",
    $month    = "*",
    $monthday = "*",
    $weekday  = "*",
) {

  $_local_dirs = join($local_dirs, " ")

  cron { "cron_rsync_${title}":
    command  => "ping -c ${host} && rsync -avz -e 'ssh -l ${remote_user} -i ${key_file}' ${_local_dir} ${remote_user}@${host}:${remote_dir}",
    user         => $local_user,
    hour         => $hour,
    minute       => $minute,
    month        => $month,
    monthday     => $monthday,
    weekday      => $weekday,
    environment  => "PATH=/bin:/usr/bin",
  }

  sshkeys::install_keypair { "${local_user}@${fqdn}": 
    user => $user,
  }

}
