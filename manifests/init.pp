# == Class: os_client_config
#
# This class configures OpenStack Client Configuration framework.
#
# See:
#   http://docs.openstack.org/developer/os-client-config/
#   http://docs.openstack.org/developer/python-openstackclient/configuration.html
#
# === Parameters
#
# [*cloud_configs*]
#
#   Hash containing cloud configurations. See example below.
#
#   Top-level key is resource name and doesn't matter, but must be unique.
#
#   Keys `cache`, `client` and `clouds` will go directly into os-client-config YAML file (clouds.yaml).
#
#   Owner of configuration can be specified by key `user`. If there is no such key, then this is global
#   configuration and it will be placed to system-wide directory - /etc/openstack. Additionally you can
#   set home directory for user via parameter `home` (by default is '/home/$user').
#
#   If key `secure` is 'true', then file will be named 'secure.yaml' (intended to store sensitive data,
#   such as passwords) and will have restricted permissions (0600).
#
#   If key `profiles` contains 'true', then file will be named 'clouds-public.yaml'. Note, puppet denies
#   to use variables containing hyphen in name, so it's impossible to use key name 'public-clouds'
#   in hiera YAML, because YAML keys are puppet variables, thus in case when profiles' is true, you MUST
#   use key 'clouds', and 'clouds-public.yaml' will contain key 'public-clouds'.
#
#   Key `ensure` by default is 'present' and may be used to remove configuration when 'absent'.
#
#   Key `perms` may override permissions for configuration file.
#
#   Key `group` may define group for resulting file.
#
# === Examples
#
#  `include os_client_config`
#
#  Hiera example:
#
#   os_client_config::cloud_configs:
#     profiles_global:                              <- Unique resource name
#       profiles: true                              <- Configuration file contains profiles and must be named 'clouds-public.yaml'
#       clouds:                                     <- Will go as-is (with all subkeys) directly into 'clouds-public.yaml'
#         my-cloud-profile:
#           auth:
#             auth_url: 'http://keystone:5000/v3'
#           identity_api_version: '3'
#     clouds_user:                                  <- Unique resource name
#       user: 'service_user'                        <- User-specific configuration for user 'user'
#       home: '/var/lib/service'                    <- Config will be placed into /var/lib/service/.config/openstack
#       cache:                                      <- Will go as-is (with all subkeys) directly into 'clouds.yaml'
#         expiration_time: 3600
#       clouds:                                     <- Will go as-is (with all subkeys) directly into 'clouds.yaml'
#         my-cloud:
#           profile: 'my-cloud-profile'
#           region_name: 'RegionOne'
#     clouds_user_auth:                             <- Unique resource name
#       user: 'service_user'                        <- User-specific configuration for user 'user'
#       home: '/var/lib/service'                    <- Config will be placed into /var/lib/service/.config/openstack
#       secure: true                                <- Configuration file contains private data and must be named 'secure.yaml'
#       clouds:                                     <- Will go as-is (with all subkeys) directly into 'clouds.yaml'
#         my-cloud:
#           auth:
#             username: 'cloud-username'
#             password: 'cloud-password'
#             project_name: 'cloud-project'
#
# === Authors
#
# Alexander Evseev <aevseev@mirantis.com>
#
# === Copyright
#
# Copyright 2016 Mirantis, Inc.
#
class os_client_config (
  $cloud_configs = hiera_hash('os_client_config::cloud_configs'),
  ) {

  create_resources( os_client_config::clouds_yaml, $cloud_configs )
}
