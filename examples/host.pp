include sshkeys::params
include rsync_cron
host { $fqdn:
  ip => $ipaddress,
}
rsync_cron::host { "rsync@${::fqdn}": }
