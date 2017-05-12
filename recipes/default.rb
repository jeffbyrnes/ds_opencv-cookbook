#
# Recipe:: ds_opencv
#
# Copyright (c) 2017 The Dark Sky Company, LLC, All Rights Reserved.

apt_update 'opencv' do
  action :update
  only_if { platform_family? 'debian' }
end

include_recipe 'build-essential'

%w(
  cmake
  gfortran
  libjpeg8-dev
  libtiff5-dev
  libjasper-dev
  libpng12-dev
  libatlas-base-dev
).each do |pkg|
  package pkg
end

opencv_path = node['ds_opencv']['opencv']['path']

git opencv_path do
  repository 'https://github.com/opencv/opencv.git'
  revision   node['ds_opencv']['opencv']['version']
  action     :checkout
end

directory "#{opencv_path}/release"

cmake_define = node['ds_opencv']['opencv']['cmake_define']
               .map { |k, v| "-D #{k}=#{v}" }.join(' ')

execute 'cmake_opencv' do
  command "cmake #{cmake_define} .."
  cwd     "#{opencv_path}/release"
  creates "#{opencv_path}/release/Makefile"
end

execute 'make_opencv' do
  command 'make -j4 && make install && ldconfig'
  cwd     "#{opencv_path}/release"
  creates node['ds_opencv']['opencv']['cmake_define']['MAKE_INSTALL_PREFIX'] +
          "/libopencv_core.so.#{node['ds_opencv']['opencv']['version']}"
end
