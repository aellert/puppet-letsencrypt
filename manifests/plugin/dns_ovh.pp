# @summary Installs and configures the dns-ovh plugin
#
#   This class installs and configures the Let's Encrypt dns-ovh plugin.
#   https://certbot-dns-ovh.readthedocs.io
#
# @param endpoint Target OVH DNS endpoint.
# @param application_key OVH application key.
# @param application_secret OVH application secret.
# @param consumer_key OVH consumer key.
# @param propagation_seconds Number of seconds to wait for the DNS server to propagate the DNS-01 challenge.
# @param manage_package Manage the plugin.
# @param package_name The name of the package to install when $manage_package is true.
# @param config_dir The path to the configuration directory.
#
class letsencrypt::plugin::dns_ovh (
  Enum['ovh-eu', 'ovh-ca'] $endpoint,
  String[1] $application_key,
  String[1] $application_secret,
  String[1] $consumer_key,
  Integer $propagation_seconds     = $letsencrypt::dns_ovh_propagation_seconds,
  Stdlib::Absolutepath $config_dir = $letsencrypt::config_dir,
  Boolean $manage_package          = $letsencrypt::dns_ovh_manage_package,
  String $package_name             = $letsencrypt::dns_ovh_package_name,
) {
  require letsencrypt

  if $manage_package {
    package { $package_name:
      ensure => installed,
    }
  }

  $ini_vars = {
    dns_ovh_endpoint            => $endpoint,
    dns_ovh_application_key     => $application_key,
    dns_ovh_application_secret  => $application_secret,
    dns_ovh_consumer_key        => $consumer_key,
    dns_ovh_propagation_seconds => $propagation_seconds,
  }

  file { "${config_dir}/dns-ovh.ini":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0400',
    content => epp('letsencrypt/ini.epp', {
      vars => { '' => $ini_vars },
    }),
  }

}
