#
# Recipe:: ds_opencv
#
# Copyright:: (c) 2017 The Dark Sky Company, LLC
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

apt_update
build_essential
include_recipe 'git'

package node['ds_opencv']['opencv']['dependencies']

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
          "/lib/libopencv_core.so.#{node['ds_opencv']['opencv']['version']}"
end
