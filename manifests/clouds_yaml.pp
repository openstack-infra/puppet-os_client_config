# Type: os_client_config::clouds_yaml
#
# This type defines configuration file clouds.yaml for OpenStack client.
#
# Parameters:
#   [*cache*] - Cache section for clouds.yaml
#   [*client*] - Client section for clouds.yaml
#   [*clouds*] - Clouds (or public-clouds) section for clouds.yaml
#   [*ensure*] - Metaparameter 'ensure' for file resource
#   [*group*] - Group for resulting file
#   [*perms*] - Unix permissions for created clouds.yaml
#   [*profiles*] - Wheither file contains public clouds configuration (cloud profiles)
#   [*secure*] - Wheither file contains sensitive information (authentication data)
#   [*user*] - Owner of created clouds.yaml
#
# Note! Even in case when 'profiles' is true, parameter for cloud is 'clouds'.
#
define os_client_config::clouds_yaml (
  $cache    = undef,
  $client   = undef,
  $clouds   = undef,
  $ensure   = 'present',
  $group    = undef,
  $perms    = undef,
  $profiles = false,
  $secure   = false,
  $user     = undef,
  ) {

  if ( $secure ) {
    $_filename = 'secure.yaml'
    $_perms    = pick( $perms, '0600' )
  } elsif ( $profiles ) {
    $_filename = 'clouds-public.yaml'
    $_perms    = pick( $perms, '0644' )
  } else {
    $_filename = 'clouds.yaml'
    $_perms    = pick( $perms, '0644' )
  }

  if ( $user ) {
    $_user_home = getvar("home_${user}")
    validate_absolute_path($_user_home)
    $_file_path = "${_user_home}/.config/openstack"
    $_owner = $user
    $_create_directories = [ "${_user_home}/.config", "${_user_home}/.config/openstack" ]
  } else {
    $_file_path = '/etc/openstack'
    $_owner = 'root'
    $_create_directories = [ '/etc/openstack' ]
  }

  $_client = { client => $client }
  $_cache  = { cache  => $cache }

  # clouds-public.yaml should have key 'public-clouds' instead of usual 'clouds', but puppet
  # denies to use variables containig hyphen in name, so let's guess key name basing on $profiles
  if ( $profiles ) {
    $_clouds = { public-clouds => $clouds }
  } else {
    $_clouds = { clouds => $clouds }
  }

  $_clouds_config = delete_undef_values( merge( $_client, $_cache, $_clouds ) )

  ensure_resource('file', $_create_directories, {
    ensure => directory,
    owner  => $_owner,
  })

  file { "${_file_path}/${_filename}":
    ensure  => $ensure,
    owner   => $_owner,
    mode    => $_perms,
    content => template( 'os_client_config/clouds.yaml.erb' ),
  }

  if ( $group ) {
    File["${_file_path}/${_filename}"] {
      group => $group,
    }
  }

}
