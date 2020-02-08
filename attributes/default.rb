default['ds_opencv']['opencv']['version'] = '3.2.0'
default['ds_opencv']['opencv']['url'] = "https://github.com/opencv/opencv/archive/#{node['ds_opencv']['opencv']['version']}.zip"
default['ds_opencv']['opencv']['path'] = "/opt/opencv-#{node['ds_opencv']['opencv']['version']}"
default['ds_opencv']['opencv']['cmake_define'] = {
  'MAKE_BUILD_TYPE' => 'RELEASE',
  'MAKE_INSTALL_PREFIX' => '/usr/local',
  'BUILD_PERF_TESTS' => 'OFF',
  'WITH_GTK' => 'OFF',
  'WITH_FFMPEG' => 'OFF',
  'WITH_GSTREAMER' => 'OFF',
  'WITH_CUDA' => 'OFF',
}
