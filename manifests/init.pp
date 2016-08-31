# Class: os_client_config
#
# This class configures OpenStack client.
#
# See: http://docs.openstack.org/developer/os-client-config/
#      http://docs.openstack.org/developer/python-openstackclient/configuration.html
#
# Parameters:
#
#   [$cloud_configs*] - Hash containing cloud configurations. See example below.
#                       Top-level key is resource name and doesn't matter, but must be unique.
#                       Keys 'cache', 'client' and 'clouds' will go directly into os-client-config YAML file (clouds.yaml).
#                       Owner of configuration can be specified by key 'user'. If there is no such key, then this is global config.
#                       If key 'secure' is 'true', then file will be named 'secure.yaml' and will have restricted permissions (0600).
#                       If key 'profiles' contains 'true', then file will be named 'clouds-public.yaml'. Note, puppet denies to use
#                       variables containing hyphen in name, so it's impossible to use key name 'public-clouds' in hiera YAML, because
#                       YAML keys are puppet variables, thus in case when profiles' is true, you MUST use key 'clouds',
#                       and 'clouds-public.yaml' will contain key 'public-clouds'.
#                       Key 'ensure' by default is 'present' and may be used to remove configuration when 'absent'.
#                       Key 'perms' may override permissions for configuration file.
#                       Key 'group' may define group for resulting file.
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
#       user: 'user'                                <- User-specific configuration for user 'user'
#       cache:                                      <- Will go as-is (with all subkeys) directly into 'clouds.yaml'
#         expiration_time: 3600
#       clouds:                                     <- Will go as-is (with all subkeys) directly into 'clouds.yaml'
#         my-cloud:
#           profile: 'my-cloud-profile'
#           region_name: 'RegionOne'
#     clouds_user_auth:                             <- Unique resource name
#       user: 'user'                                <- User-specific configuration for user 'user'
#       secure: true                                <- Configuration file contains private data and must be named 'secure.yaml'
#       clouds:                                     <- Will go as-is (with all subkeys) directly into 'clouds.yaml'
#         my-cloud:
#           auth:
#             username: 'cloud-username'
#             password: 'cloud-password'
#             project_name: 'cloud-project'
#
class os_client_config (
  $cloud_configs = hiera_hash('os_client_config::cloud_configs'),
  ) {

  create_resources( os_client_config::clouds_yaml, $cloud_configs )
}
