require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |c|
  c.parser = 'future'
  c.default_facts = {
    :operatingsystem => 'Ubuntu',
    :lsbdistid       => 'Ubuntu',
    :lsbdistcodename => 'trusty',
    :osfamily        => 'Debian'
  }
end
