include sshkeys::params
include rsync_cron
# create the ssh keys - gets run on the master so do it here to 
# simulate
sshkeys::ssh_keygen { "rsync@${::fqdn}": }

rsync_cron::agent { $fqdn:
  local_dirs => ["/tmp/abc"],
  key_file   => "/home/rsync/.ssh/rsync@${::fqdn}",
}
