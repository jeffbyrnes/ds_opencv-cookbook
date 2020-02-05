#
# Cookbook:: opencv
# Spec:: default
#
# Copyright:: (c) 2020 Jeff Byrnes
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

shared_examples 'opencv' do
  it 'converges successfully' do
    expect { chef_run }.to_not raise_error
  end

  it 'downloads and unarchives OpenCV' do
    expect(chef_run).to install_ark('opencv').with url: "https://github.com/opencv/opencv/archive/#{opencv_version}.zip"
  end

  it 'creates a release dir for OpenCV' do
    expect(chef_run).to create_directory '/opt/opencv/release'
  end

  it 'builds & installs OpenCV from source' do
    expect(chef_run).to run_execute 'cmake_opencv'

    expect(chef_run).to run_execute('make_opencv').with(
      creates: "/usr/local/lib/libopencv_core.so.#{opencv_version}"
    )
  end
end

describe 'opencv::default' do
  context 'When all attributes are default, on Ubuntu 18.04' do
    platform 'ubuntu', '18.04'

    let(:opencv_version) { '3.4.9' }

    it_behaves_like 'opencv'
  end

  context 'When installing OpenCV v2.x, on Ubuntu 18.04' do
    platform 'ubuntu', '18.04'

    # README: Setting this as a local variable due to how RSpec handles scope
    #         Avoids duplication in the following assignments
    version = '2.4.13.4'

    override_attributes['opencv']['opencv']['version'] = version

    let(:opencv_version) { version }

    it_behaves_like 'opencv'
  end
end
