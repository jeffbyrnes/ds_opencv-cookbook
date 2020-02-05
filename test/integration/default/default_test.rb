# Inspec test for recipe ds_opencv::default

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

control 'ds_opencv' do
  impact 1.0
  title 'Verify OpenCV v3.x and its dependencies are installed'

  %w(
    cmake
    gfortran
    libjpeg8-dev
    libtiff5-dev
    libpng-dev
    libatlas-base-dev
  ).each do |pkg|
    describe package pkg do
      it { should be_installed }
    end
  end

  describe file '/usr/local/lib/libopencv_core.so.3.2.0' do
    it { should exist }
  end
end
