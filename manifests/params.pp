# rsync_cron::params
# ==================
# Common variables (params pattern)
class rsync_cron::params {

  # remote user to connect to when SSHing into rsync host
  $user      = "rsync"

  # group of rsync user (same as user)
  $group     = $user

  # default mode for directories created
  $mode      = "0700"

  # default directory to sync files from/to
  $dir       = "/srv/files/"

  # default log file location for agents
  $log_file  = "/var/log/rsync_cron.log"

  # default hourly cron schedule for crontab
  $cron_hour = "*/1"

  # default value for all other crontab fields
  $cron_all  = "*"
}

