# OpenStack os_client_config Module

This module installs and configures os_client_config config files.

This module takes hashes as parameters to configure oscc. These can be looked up in hiera directly
or merged or anything you wish.

When run as root, the puppet module puts the config into the SITE_CONFIG_DIR. When run as notroot
it puts the config into the USER_CONFIG_DIR.


```puppet
class { 'os_client_config':
  cache => {
    'class' => 'dogpile.cache.pylibmc',
    'max_age' => 3600,
    'arguments' => {
      'url' => [
        '127.0.0.1',
      ],
    }
  },
  clouds => {
   'mordred' => {
     'profile' => 'hp',
     'auth' => {
       'username' => 'mordred@inaugust.com',
       'password' => 'XXXXXXXXX',
       'project_name' => 'mordred@inaugust.com',
     },
     'region_name' => 'region-b.geo-1',
     'dns_service_type' => 'hpext:dns',
     'compute_api_version' => '1.1',
   },
   'monty' => {
     'auth' => {
       'auth_url' => 'https://region-b.geo-1.identity.hpcloudsvc.com:35357/v2.0',
       'username' => 'monty.taylor@hp.com',
       'password' => 'XXXXXXXX',
       'project_name' => 'monty.taylor@hp.com-default-tenant',
     },
     'region_name' => 'region-b.geo-1',
     'dns_service_type' =>  'hpext:dns',
   },
   'infra' => {
     'profile' => 'rackspace',
     'auth' => {
       'username' => 'openstackci',
       'password' => 'XXXXXXXX',
       'project_id' => '610275',
     },
     'region_name' => 'DFW,ORD,IAD',
   }
 },
}
```
