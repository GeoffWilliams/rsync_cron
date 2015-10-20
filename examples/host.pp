include sshkeys::params
include rsync_cron::params
host { $fqdn:
  ip => $ipaddress,
}
rsync_cron::host { "rsync@${::fqdn}": }
