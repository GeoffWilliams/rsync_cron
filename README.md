# rsync_cron
[![Build Status](https://travis-ci.org/GeoffWilliams/rsync_cron.svg)](https://travis-ci.org/GeoffWilliams/rsync_cron)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with rsync_cron](#setup)
    * [What rsync_cron affects](#what-rsync_cron-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with rsync_cron](#beginning-with-rsync_cron)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

Manage a cron job to periodically rsync a directory between two computers.  sync direction can be in any or both directions.

Rsync+ssh is used to avoid the need for a dedicated rsync service

## Module Description

This module uses ssh and rsync to install a cron job to periodically sync directories between hosts.  This is ideal for syncronising large directories of flies on a regular basis.  Alternatively, this can also be used for machines such as laptops that are not always in reach of the systems they need to sync to.

A brief log file is also created for debugging purposes.

## Setup

### What rsync_cron affects

* Manages a cron job to sync remote to local, local to remote or bi-directionally (by running both sync jobs sequentially)
  impact, or execute on the system it's installed on.
* Doesn't handle deleted files (`--delete`)
* Skips overwriting files that are newer (`-u`)
* Only attempts to run rsync if the remote destination is online, as detected by the `ping` command

### Setup Requirements

* SSH keys need to exist on the Puppet Master already, this module just copies them, however, you could use the [sshkeys](https://forge.puppetlabs.com/geoffwilliams/sshkeys) module to generate them
* SSH needs to be enabled on the host you are connecting to, on the standard port
* cron and rsync packages must already be installed
* machines you want to rsync between must be able to ping each other

## Usage

### Setting up the machine to receive the SSH connection
```puppet
rsync_cron::host { "rsync@mylaptop.localdomain": }
```
Setup the node classified with this resource to accept a connection using the public key found on the Puppet Master in the `/etc/sshkeys/rsync@mylaptop.localdomain.pub` file


### Setting up a machine to run the rsync command
```puppet
rsync_cron::agent { "rsync@${::fqdn}":
  host => "ftp.localdomain",
}
```
Manage a cron job on the node classified with this resource.  Targets a local user `rsync`.  Files will be rsync'ed to/from `ftp.localdomain`

This example is geared around SSH keys generated with the [sshkeys](https://forge.puppetlabs.com/geoffwilliams/sshkeys) module.  It is possible to override the this mechanism by specifying the `key_file` parameter.  See source code for details. 

## Reference

* `rsync_cron` - Dummy class to get `rsync_cron::params` class into scope
* `rsync_cron::params` - Params pattern class
* `rsync_cron::host` - Setup a host to receive connections via rsync+ssh
* `rsync_cron::agent` - Setup a cron job to periodically rsync files to and or from another node that has had `rsync_cron::host` applied to it

## Limitations

Tested on Ubuntu, will probably work elsewhere but untested.

## Development

PRs accepted
