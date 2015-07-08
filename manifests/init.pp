# Copyright 2015 Hewlett-Packard Development Company, L.P.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

# os-client-config puppet module
# sets up clouds.yaml

# parameters
# clouds, client, and cache are hashes. See readme for advanced usage.
#
# target_user
# Sets which user to create configuration for. Defaults to 'root' which
# creates site wide configuraton in $SITE_CONFIG_DIR

class os_client_config (
  $clouds,
  $config_mode = '0600',
  $target_user = 'root',
  $config_group = $::id,
  $client = {},
  $cache = {},
){

  validate_hash($clouds)
  validate_hash($client)
  validate_hash($cache)

  $config = {
              'clouds' => $clouds,
              'cache'  => $cache,
              'client' => $client,
            }

  $user_config_dir = $::kernel ? {
    'Linux'   => "/home/${::id}/.config/openstack",
    'Windows' => "C:\\Users\\${::id}\\AppData\\Local\\OpenStack\\openstack",
    'Darwin'  => "/home/${::id}/Library/Application Support/openstack",
  }

  $site_config_dir = $::kernel ? {
    'Linux'   => '/etc/openstack',
    'Windows' => 'C:\ProgramData\OpenStack\openstack',
    'Darwin'  => '/Library/Application Support/openstack',
  }


  if $target_user != 'root' {
    # This is, suprisingly, windows-safe
    $config_path = "${user_config_dir}/clouds.yaml"
    if !defined(File[$user_config_dir]) {
      file { $user_config_dir:
        ensure => directory,
        owner  => $target_user,
        group  => $target_user,
      }
    }
  } else {
    # This is, suprisingly, windows-safe
    $config_path = "${site_config_dir}/clouds.yaml"
    if !defined(File[$site_config_dir]) {
      file { $site_config_dir:
        ensure => directory,
        owner  => 'root',
        group  => 'root',
      }
    }
  }

  file { $config_path:
    ensure  => file,
    owner   => $target_user,
    mode    => $config_mode,
    group   => $config_group,
    content => template('os_client_config/clouds.yaml.erb'),
  }

}
