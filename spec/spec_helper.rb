require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |c|
  c.add_formatter 'documentation'

  # Add JUnit output for CI
  if ENV['CI']
    c.add_formatter 'RspecJunitFormatter', './test-results/verify/results.xml'
  end
end
