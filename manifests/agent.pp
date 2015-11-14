# rsync_cron::agent
# =================
# Setup a cron job to periodically connect to the specified remote host and
# rsync the requested directories
#
# Parameters
# ==========
# [*key_file*]
#   if not using sshkeys module to generate SSH keys, you can specify an SSH
#   key file to use for the rsync command.  SSH key specified must alread exit
#   and must not have a passphrase set
# [*key_name*]
#   if using sshkeys module to generate SSH keys, then all you need is the key
#   name here, eg `rsync@mylaptop.localdomain`.  Defaults to $title
# [*local_user*]
#   user to run rsync as.  only needed if using a key_file, otherwise the local
#   user will be determined from $key_name
# [*local_dir*]
#   local directory to rsync to/from
# [*remote_user*]
#   remote user to ssh into on $host
# [*remote_dir*]
#   remote directory to rsync files to/from
# [*log_file*]
#   log file to write debug the output of the cronjob to (for debugging)
# [*host*]
#   remote host to SSH into when copying files with rsync
# [*hour*]
#   hour field for crontab entry
# [*minute*]
#   minute field for crontab entry
# [*month*]
#   month field for crontab entry
# [*monthday*]
#   monthday field for crontab entry
# [*weekday*]
#   weekday field for crontab entry.
# [*download*]
#   true to download files from $host every time the cronjob runs, otherwise
#   false
# [*upload*]
#   true to upload files to $host every time the cronjob runs, otherwise false
define rsync_cron::agent(
    $key_file     = false,
    $key_name     = $title,
    $local_user   = $rsync_cron::params::user,
    $local_dir    = $rsync_cron::params::dir,
    $remote_user  = $rsync_cron::params::user,
    $remote_dir   = $rsync_cron::params::dir,
    $log_file     = $rsync_cron::params::log_file,
    $host         = $title,
    $hour         = $rsync_cron::params::cron_hour,
    $minute       = fqdn_rand(59),
    $month        = $rsync_cron::params::cron_all,
    $monthday     = $rsync_cron::params::cron_all,
    $weekday      = $rsync_cron::params::cron_all,
    $download     = true,
    $upload       = true,
) {
  
  if $key_file {
    $_key_file    = $key_file
    $_local_user  = $local_user
  } elsif $key_name {
    if $key_name =~ /\w+@\w+/ {
        $split_title = split($key_name, "@")
        $_local_user = $split_title[0]

        $_key_file = "/home/${_local_user}/.ssh/${key_name}"
    } else {
      fail("requested key '${key_name}' is not in the correct format - should be user@host")
    }
  } else {
    fail("one of key_name or key_file must be specified for Rsync_cron::Agent[${title}]")
  }


  # if you get a duplicate resource error here you need to write to a separate
  # log file
  file { $log_file:
    ensure => file,
    owner  => $_local_user,
    group  => $_local_user,
    mode   => "0644",
  }

  # how to invoke rsync
  $rsync_cmd = "rsync -avzu -e 'ssh -l ${remote_user} -i ${_key_file}' "

  # create local directories to hold received files
  file { $local_dir:
    ensure => directory,
  }

  if $download {
    $_download = "${rsync_cmd} ${local_dir} ${remote_user}@${host}:${remote_dir} >> ${log_file} 2>&1"
  } else {
    # run the /bin/true command (exit immediately with status 0)
    $_download = "true"
  }

  if $upload {
    $_upload = "${rsync_cmd} ${remote_user}@${host}:${remote_dir} ${local_dir} >> ${log_file} 2>&1"
  } else {
    # run the /bin/true command (exit immediately with status 0)
    $_upload = "true"
  }

  # finally the cron job itself!  use ping to test if a host is alive before
  # starting up rsync
  cron { "cron_rsync_${title}":
    command      => "ping -c 1 ${host} && ${_upload} && ${_download}",
    user         => $_local_user,
    hour         => $hour,
    minute       => $minute,
    month        => $month,
    monthday     => $monthday,
    weekday      => $weekday,
    environment  => "PATH=/bin:/usr/bin",
  }

  # if using $key_name, assume the sshkeys module generated the keys.  If not
  # then the user needs to copy the keys separately
  if $key_name {
    sshkeys::install_keypair { $key_name:}
  }

  # download the host keys if we need to
  sshkeys::known_host { "${_local_user}@${host}":}

}
