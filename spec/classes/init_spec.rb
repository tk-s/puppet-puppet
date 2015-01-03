require 'spec_helper'

describe 'puppet' do

  context 'with defaults for all parameters' do

    # All classes
    it { should contain_class('puppet') }
    it { should contain_class('puppet::repo') }
    it { should contain_class('puppet::install') }
    it { should contain_class('puppet::config') }
    it { should contain_class('puppet::service') }

    # apt repo
    it { should contain_apt__source('puppetlabs') }

    # Puppet Package
    it { should contain_package('puppet').with(:name => 'puppet') }

    # Puppet Agent Service
    it { should contain_service('puppet').with(:name => 'puppet') }

    # Config notifies Service
    it { should contain_class('puppet::config').that_notifies('Class[puppet::service]') }

  end

end
