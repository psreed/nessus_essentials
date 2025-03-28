# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include nessus_essentials
# 
# @param version
# @param architecture
# @param base_url
class nessus_essentials (
  String $version      = '10.8.3',
  String $architecture = $facts['os']['architecture'],
  String $base_url     = 'https://www.tenable.com/downloads/api/v2/pages/nessus/files/Nessus',
) {
  if $facts['os']['family'] == 'RedHat' {
    $package_src = "${base_url}-${version}-el${facts['os']['release']['major']}.${architecture}.rpm"
    $package_name = "Nessus-${version}-el${facts['os']['release']['major']}.${architecture}"
    package { $package_name:
      ensure   => present,
      provider => 'rpm',
      source   => $package_src,
    }
#    notify { 'nessus_package': message => $package, }
    service { 'nessusd':
      ensure  => running,
      enable  => true,
      require => Package[$package_name],
    }
  } elsif $facts['os']['name'] == 'Ubuntu' {
    $package = "${base_url}-${version}-ubuntu1604.${architecture}.deb"
  }
}
