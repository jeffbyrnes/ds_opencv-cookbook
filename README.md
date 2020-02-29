# ds_opencv [![CircleCI](https://circleci.com/gh/jeffbyrnes/ds_opencv-cookbook.svg?style=svg)](https://circleci.com/gh/jeffbyrnes/ds_opencv-cookbook) [![Version](https://img.shields.io/cookbook/v/magic.svg)](https://supermarket.chef.io/cookbooks/ds_opencv)

Cookbook to build and install opencv

## Usage

1. Include `ds_opencv::default` in your wrapper cookbook
2. Optionally, set the `node['ds_opencv']['opencv']['version']` in your wrapper if you prefer a version other than what this cookbook specifies
