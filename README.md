# OpenStack os_client_config Module

This module installs and configures os_client_config config files.

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with os_client_config](#setup)
    * [What os_client_config affects](#what-os_client_config-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with os_client_config](#beginning-with-os_client_config)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

The os_client_config module creates configuration files for OpenStack Client Configuration
framework used by openstack-client, and also by some OpenStack infrastructure services.

## Module Description

This module can create both system-wide and user-specific configurations for OpenStack
Client Configuration framework. Module can create any set of configuration files,
including clouds.yaml, clouds-public.yaml, and secure.yaml. Note, module can't create
custom configuration files.

## Setup

### Setup Requirements

This module intended to be used in Mirantis' infrastructure, because it requires custom
package 'facter-facts' to get list of users home directories.

### Beginning with os_client_config

Define a hash containig description of clouds, and then just use it directly

```puppet
my_cloud_configs = {
  profiles_global => {
    profiles => true,
    clouds => {
      my-cloud-profile => {
        auth => {
          auth_url => 'http://keystone:5000/v2.0'
        },
      },
    },
  },
}

class { 'os_client_config':
  cloud_configs => my_cloud_configs,
}
```

or via Hiera:

```yaml
os_client_config::cloud_configs:
  clouds_user:
    user: 'user'
    cache:
      expiration_time: 3600
    clouds:
      my-cloud:
        profile: 'my-cloud-profile'
        region_name: 'RegionOne'
  clouds_user_auth:
    user: 'user'
    secure: true
    clouds:
      my-cloud:
        auth:
          username: 'cloud-username'
          password: 'cloud-password'
          project_name: 'cloud-project'
```

```puppet
include os_client_config
```

## Usage

Main class is 'os_client_config' which creates a set of resources from defined type 'os_client_config::clouds_yaml'.

## Reference

###Classes

####Public Classes

* os_client_config: Main class.

####Defined types

* os_client_config::clouds_yaml: This type represents one of configuration files

###Parameters

The only parameter for the `::os_client_config` class is

####`cloud_configs`

Hash containing cloud configurations.

Top-level key is resource name and doesn't matter, but must be unique.

Keys `cache`, `client` and `clouds` will go directly into os-client-config YAML file (clouds.yaml).

Owner of configuration can be specified by key `user`. If there is no such key, then this is global
configuration and it will be placed to system-wide directory - /etc/openstack. Additionally you can
set home directory for user via parameter `home` (by default is '/home/$user').

If key `secure` is 'true', then file will be named 'secure.yaml' (intended to store sensitive data,
such as passwords) and will have restricted permissions (0600).

If key `profiles` contains 'true', then file will be named 'clouds-public.yaml'. Note, puppet denies
to use variables containing hyphen in name, so it's impossible to use key name 'public-clouds'
in hiera YAML, because YAML keys are puppet variables, thus in case when profiles' is true, you MUST
use key 'clouds', and 'clouds-public.yaml' will contain key 'public-clouds'.

Key `ensure` by default is 'present' and may be used to remove configuration when 'absent'.

Key `perms` may override permissions for configuration file.

Key `group` may define group for resulting file.

## Limitations

This module is tested only on Ubuntu Trusty but should be usable on other Linuxes.

## Development

If you want to fix bugs or improve module, you can prepare changes via Gerrit:

  ssh://review.openstack.org:29418/openstack-infra/puppet-os_client_config
