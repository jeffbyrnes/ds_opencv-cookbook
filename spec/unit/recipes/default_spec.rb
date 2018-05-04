#
# Cookbook Name:: ds_opencv
# Spec:: default
#
# Copyright (c) 2016 The Dark Sky Company, LLC, All Rights Reserved.

require 'spec_helper'

describe 'ds_opencv::default' do
  context 'When all attributes are default, on Ubuntu 16.04' do
    let(:chef_run) { ChefSpec::ServerRunner.new.converge described_recipe }

    let(:opencv_path) { '/opt/opencv-3.2.0' }
    let(:opencv_version) { '3.2.0' }

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'updates apt' do
      expect(chef_run).to include_recipe 'apt'
    end

    it 'sets up our build environment' do
      expect(chef_run).to include_recipe 'build-essential'
    end

    %w(
      cmake
      gfortran
      libjpeg8-dev
      libtiff5-dev
      libjasper-dev
      libpng12-dev
      libatlas-base-dev
    ).each do |pkg|
      it "installs #{pkg}" do
        expect(chef_run).to install_package pkg
      end
    end

    it 'clones and checks out OpenCV v3.2.0' do
      expect(chef_run).to checkout_git(opencv_path).with(
        repository: 'https://github.com/opencv/opencv.git',
        revision:   opencv_version.to_s
      )
    end

    it 'creates a release dir for OpenCV' do
      expect(chef_run).to create_directory "#{opencv_path}/release"
    end

    it 'builds & installs OpenCV from source' do
      expect(chef_run).to run_execute('cmake_opencv').with(
        command: 'cmake -D MAKE_BUILD_TYPE=RELEASE -D MAKE_INSTALL_PREFIX=/usr/local ' \
                 '-D BUILD_PERF_TESTS=OFF -D WITH_GTK=OFF -D WITH_FFMPEG=OFF ' \
                 '-D WITH_GSTREAMER=OFF -D WITH_CUDA=OFF ..',
        cwd:     "#{opencv_path}/release",
        creates: "#{opencv_path}/release/Makefile"
      )

      expect(chef_run).to run_execute('make_opencv').with(
        command: 'make -j4 && make install && ldconfig',
        cwd:     "#{opencv_path}/release",
        creates: "/usr/local/lib/libopencv_core.so.#{opencv_version}"
      )
    end
  end
end
