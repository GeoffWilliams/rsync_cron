include sshkeys::params
include rsync_cron
# create the ssh keys - gets run on the master so do it here to 
# simulate
sshkeys::ssh_keygen { "rsync@${::fqdn}": }

# note: local_dir is optional but we set it here so that we can run the 
# command for real on a single computer and test synchronisation between
# two different directories
rsync_cron::agent { "rsync@${::fqdn}":
  host      => "localhost",
  local_dir => "/tmp/abc",
}
