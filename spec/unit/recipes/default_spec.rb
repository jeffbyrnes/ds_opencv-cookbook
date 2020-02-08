#
# Cookbook:: ds_opencv
# Spec:: default
#
# Copyright:: (c) 2016 The Dark Sky Company, LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'spec_helper'

describe 'ds_opencv::default' do
  context 'When all attributes are default, on Ubuntu 18.04' do
    platform 'ubuntu', '18.04'

    let(:opencv_path) { '/opt/opencv-3.2.0' }
    let(:opencv_version) { '3.2.0' }

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    %w(
      cmake
      gfortran
      libjpeg8-dev
      libtiff5-dev
      libpng-dev
      libatlas-base-dev
    ).each do |pkg|
      it "installs #{pkg}" do
        expect(chef_run).to install_package pkg
      end
    end

    it 'clones and checks out OpenCV v3.2.0' do
      expect(chef_run).to checkout_git(opencv_path).with(
        repository: 'https://github.com/opencv/opencv.git',
        revision: opencv_version.to_s
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
        cwd: "#{opencv_path}/release",
        creates: "#{opencv_path}/release/Makefile"
      )

      expect(chef_run).to run_execute('make_opencv').with(
        command: 'make -j4 && make install && ldconfig',
        cwd: "#{opencv_path}/release",
        creates: "/usr/local/lib/libopencv_core.so.#{opencv_version}"
      )
    end
  end
end
