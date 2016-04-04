require 'spec_helper'

describe 'mediawiki::files', :type => :define do
    let(:pre_condition) do
      'include apache'
    end

  context 'using default parameters on Debian' do
    let(:facts) do
      {
        # the module concat needs this. Normaly set by concat through pluginsync
        :concat_basedir         => '/tmp/concatdir',
        :osfamily => 'Debian',
        :operatingsystem => 'Debian',
        :operatingsystemrelease => '6',
        'apache::params::user' => 'foobar',

      }
    end

    let(:params) do
      {
        :target_dir => '/usr/share/mediawiki'
      }
    end

    let(:title) do
      '/etc/mediawiki/dummy_instance/api.php'
    end

    it {

      should contain_file('/etc/mediawiki/dummy_instance/api.php').with(
        'ensure' => 'link',
        'path'   => '/etc/mediawiki/dummy_instance/api.php',
        'owner'  => 'www-data',
        'group'  => 'www-data',
        'mode'   => '0755',
        'target' => '/usr/share/mediawiki/api.php'
      )
    }
  end
end
