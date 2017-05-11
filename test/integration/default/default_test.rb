# Inspec test for recipe ds_api::default

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

describe package 'libcairo2-dev' do
  it { should be_installed }
end

describe port 80 do
  it { should be_listening }
  its('processes') { should include 'nginx' }
end

describe service 'nginx' do
  it { should be_enabled }
  it { should be_running }
end

describe command 'curl localhost/v1/status.txt' do
  its('stdout') { should eq "OK!\n" }
end

# sync_dsgm_cmd = '/usr/bin/rsync -qrtmz darksky@45.79.184.77:src/' \
#                 'darkskynet-generator/data/dsgm/ /srv/darksky/var/weather/'

# sync_nn_cmd = "/usr/bin/rsync -qrtmz --delete --exclude='/*/training.dat' " \
#               'darksky@45.79.184.77:src/darkskynet-generator/data/nn/combined/ ' \
#               '/srv/darksky/var/nn/'

# describe crontab('darksky').commands sync_dsgm_cmd do
#   its('minutes') { should cmp '*/5' }
# end

# describe crontab('darksky').commands sync_nn_cmd do
#   its('minutes') { should cmp '0' }
# end

%w(
  api_static
  nn
).each do |data_type|
  describe file "/srv/api/var/#{data_type}" do
    it { should exist }
  end
end
