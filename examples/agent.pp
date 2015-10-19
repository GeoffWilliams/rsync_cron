include sshkeys::params
include rsync_cron::params
# create the ssh keys - gets run on the master so do it here to 
# simulate
sshkeys::ssh_keygen { "rsync@${::fqdn}": }

rsync_cron::agent { "demo":
  key_file => "rsync@${::fqdn}",
}
