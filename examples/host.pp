include rsync_cron::params
rsync_cron::host { "rsync@${::fqdn}": }
