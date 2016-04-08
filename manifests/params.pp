# === Class: mediawiki::params
#
#  The mediawiki configuration settings idiosyncratic to different operating
#  systems.
#
# === Parameters
#
# None
#
# === Examples
#
# None
#
# === Authors
#
# Martin Dluhos <martin@gnu.org>
#
# === Copyright
#
# Copyright 2012 Martin Dluhos
#
class mediawiki::params {

  $tarball_url        = 'http://releases.wikimedia.org/mediawiki/1.22/mediawiki-1.26.2.tar.gz'
  $conf_dir           = '/etc/mediawiki'
  $installation_files = [ 'api.php',
                          'api.php5',
                          'bin',
                          'docs',
                          'extensions',
                          'img_auth.php',
                          'img_auth.php5',
                          'includes',
                          'index.php',
                          'index.php5',
                          'languages',
                          'load.php',
                          'load.php5',
                          'maintenance',
                          'mw-config',
                          'opensearch_desc.php',
                          'opensearch_desc.php5',
                          'profileinfo.php',
                          'redirect.php',
                          'redirect.php5',
                          'redirect.phtml',
                          'resources',
                          'serialized',
                          'skins',
                          'StartProfiler.sample',
                          'tests',
                          'thumb_handler.php',
                          'thumb_handler.php5',
                          'thumb.php',
                          'thumb.php5',
                          'wiki.phtml']

  case $::operatingsystem {
    redhat, centos:  {
      $web_dir            = '/var/www/html'
      $install_dir        = $web_dir
      $doc_root           = "${web_dir}/wikis"
      $packages           = ['php-gd', 'php-mysql', 'php-xml', 'wget', 'php-pecl-apcu', 'php-intl']
      $apache             = $apache::params::service_name
    }
    debian:  {
      $web_dir            = '/var/www'
      $install_dir        = $web_dir
      $doc_root           = "${web_dir}/wikis"
      $packages           = ['php5', 'php5-mysql', 'wget']
      $apache             = $apache::params::service_name
    }
    ubuntu:  {
      $web_dir            = '/var/www'
      $install_dir        = '/usr/lib'
      $doc_root           = "${web_dir}/wikis"
      $apache             = $apache::params::service_name

      case $::operatingsystemrelease {
        '16.04': {
          $packages = ['php7.0', 'php7.0-mysql', 'wget', 'php7.0-opcache', 'php7.0-gd', 'php7.0-intl', 'git']
        }
        default: {
          $packages = ['php5', 'php5-mysql', 'wget', 'php5-xcache', 'php5-gd', 'php5-intl', 'git']
        }
      }

    }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }
}
