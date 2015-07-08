# os-client-config puppet module

class os_client_config (
  $clouds,
  $config_mode = '0600',
  $config_group = $::id,
  $client = [],
  $cache = [],
){

  $config = {
              'clouds' => $clouds,
              'cache'  => $cache,
              'client' => $client,
            }

  $user_config_dir = $kernel ? {
    'Linux'   => "/home/${::id}/.config/openstack",
    'Windows' => "C:\\Users\\${::id}\\AppData\\Local\\OpenStack\\openstack",
    'Darwin'  => "/home/${::id}/Library/Application Support/openstack",
  }

  $site_config_dir = $kernel ? {
    'Linux'   => '/etc/openstack',
    'Windows' => 'C:\ProgramData\OpenStack\openstack',
    'Darwin'  => '/Library/Application Support/openstack',
  }


  if $::id != 'root' {
    $config_path = "${user_config_dir}/clouds.yaml"
    if !defined(File[$user_config_dir]) {
      file { $user_config_dir:
        ensure => directory,
        owner  => $::id,
        group  => $::id,
      }
    }
  } else {
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
    owner   => $::id,
    mode    => $config_mode,
    group   => $config_group,
    content => template('os_client_config/clouds.yaml.erb'),
  }

}
