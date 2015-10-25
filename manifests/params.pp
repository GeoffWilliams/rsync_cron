class rsync_cron::params {
  $user      = "rsync"
  $group     = $user
  $mode      = "0700"
  $dir       = "/srv/files"
  $log_file  = "/var/log/rsync_cron.log"
  $cron_hour = "*/1"
  $cron_all  = "*"
}

