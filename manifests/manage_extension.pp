#
#
#
define mediawiki::manage_extension(
  $ensure,
  $instance,
  $source,
  $doc_root
){
  $extension = $name
  $line = "require_once( \"${doc_root}/${instance}/extensions/ConfirmAccount/ConfirmAccount.php\" );"
  $path = "${doc_root}/${instance}/LocalSettings.php"

  mediawiki_extension { $extension:
    ensure   =>  present,
    instance =>  $::mediawiki::wiki_name,
    source   =>  $source,
    doc_root =>  $doc_root,
    notify   =>  Exec["set_${extension}_perms"],
  }

  file_line{"${extension}_include":
    ensure  =>  $ensure,
    line    =>  $line,
    path    =>  $path,
    require =>  Mediawiki_extension['ConfirmAccount'],
    notify  =>  Exec["set_${extension}_perms"],
  }
  File_line["${extension}_include"] ~> Service<| title == 'httpd' |>
  exec{"set_${extension}_perms":
    command     =>  "/bin/chown -R ${apache::params::user}:${apache::params::user} ${doc_root}/${instance}",
    refreshonly =>  true,
    notify      =>  Exec["set_${extension}_perms_two"],
  }
  exec{"set_${extension}_perms_two":
    command     =>  "/bin/chown -R ${apache::params::user}:${apache::params::user} /etc/mediawiki/${instance}",
    refreshonly =>  true,
    notify      =>  Exec["set_${extension}_perms_three"],
  }
  exec{"set_${extension}_perms_three":
    command     =>  "/bin/chown -R ${apache::params::user}:${apache::params::user} ${mediawiki::params::install_dir}/mediawiki*",
    refreshonly =>  true
  }
}
