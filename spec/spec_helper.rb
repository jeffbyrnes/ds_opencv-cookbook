require 'chefspec'
require 'chefspec/berkshelf'

# Generate a report
ChefSpec::Coverage.start!

RSpec.configure do |c|
  c.color     = true
  c.formatter = :documentation
  c.platform  = 'ubuntu'
  c.version   = '16.04'

  c.before do
    stub_command('which nginx').and_return '/usr/bin/nginx'
  end
end
