# == Class: megaraid::lsiget
#
# installs the `lsiget` utility for LSI MegaRAID controllers
#
# See: http://mycusthelp.info/LSI/_cs/AnswerDetail.aspx?inc=8264
#
#
# === Parameters
#
# Accepts no parameters.
#
#
# === Examples
#
#    class{ 'megaraid::lsiget': }
#
#
# === Authors
#
# Joshua Hoblitt <jhoblitt@cpan.org>
#
#
class selenium::install(
  $version = '2.35.0',
  $url     = undef,
) {
  validate_string($version)
  validate_string($url)

  include wget

  $jar_name = "selenium-server-standalone-${version}.jar"

  if $url {
    $jar_url = $url
  } else {
    $jar_url = "https://selenium.googlecode.com/files/${jar_name}"
  }

  File {
    owner => $selenium::server::user,
    group => $selenium::server::group,
  }

  file { $selenium::server::install_path:
    ensure => directory,
  }

  $jar_path = "${selenium::server::install_path}/jars"
  $log_path = "${selenium::server::install_path}/log"

  file { $jar_path:
    ensure => directory,
  }

  file { $log_path:
    ensure => directory,
  }

  file { '/var/log/selenium':
    ensure => link,
    owner  => 'root',
    group  => 'root',
    target => $log_path,
  }

  wget::fetch { 'selenium-server-standalone':
    source      => $jar_url,
    destination => "${selenium::server::jar_path}/${jar_name}",
    timeout     => 30,
    execuser    => $selenium::server::user,
    require     => File[$jar_path],
  }

}