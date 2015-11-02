# Params
# ------
# [*host*]
#   Server to copy files to via rsync
# [*keyfile*]
#   Path to public ssh key on 

define rsync_cron::agent(
    $local_user  = $rsync_cron::params::user,
    $local_dirs  = $rsync_cron::params::dir,
    $remote_user = $rsync_cron::params::user,
    $remote_dir  = $rsync_cron::params::dir,
    $log_file    = $rsync_cron::params::log_file,
    $host        = $title,
    $key_file,
    $hour        = $rsync_cron::params::cron_hour,
    $minute      = fqdn_rand(59),
    $month       = $rsync_cron::params::cron_all,
    $monthday    = $rsync_cron::params::cron_all,
    $weekday     = $rsync_cron::params::cron_all,
    $download    = true,
    $upload      = true,
) {
  
  # if you get a duplicate resource error here you need to write to a separate
  # log file
  file { $log_file:
    ensure => file,
    owner  => $local_user,
    group  => $local_group,
    mode   => "0644",
  }

  # Flatten the array of passed-in directories to form an argument to rsync.
  # This will give us a space delimited list of stuff to copy which allows us
  # to copy more then a single directory. 
  $_local_dirs = join(any2array($local_dirs), " ")
  $rsync_cmd = "rsync -avzu -e 'ssh -l ${remote_user} -i ${key_file}' "

  if $download {
    $_download = "${rsync_cmd} ${_local_dirs} ${remote_user}@${host}:${remote_dir} >> ${log_file}"
  } else {
    $_download = "true"
  }

  if $upload {
    $_upload = "${rsync_cmd} ${remote_user}@${host}:${remote_dir} ${_local_dirs} >> ${log_file}"
  } else {
    $_upload = "true"
  }

  cron { "cron_rsync_${title}":
    command  => "ping -c 1 ${host} && ${_upload} && ${_download}",
    user         => $local_user,
    hour         => $hour,
    minute       => $minute,
    month        => $month,
    monthday     => $monthday,
    weekday      => $weekday,
    environment  => "PATH=/bin:/usr/bin",
  }

  sshkeys::install_keypair { "${local_user}@${fqdn}": 
    user => $remote_user,
  }

  sshkeys::known_host { "${local_user}@${host}":}

}
