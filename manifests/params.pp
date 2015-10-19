class rsync_cron::params {
  $user  = "rsync"
  $group = $user
  $mode  = "0700"
  $dir   = "/srv/test"
}
