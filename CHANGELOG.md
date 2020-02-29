# CHANGELOG for `opencv` cookbook

## v2.0.0

* Rename cookbook back to `opencv`
* Add Ubuntu 18.04 support
* Refactor for Chef >= 14.1.1
* Use `kitchen-dokken` for testing
* Test against Chef 15
* Download & unpack an archive of OpenCV instead of using git
* Clean up various elements
* Use CircleCI instead of Travis CI for testing

## v1.3.2

* Fix up Test Kitchen + Travis CI setup

## v1.3.1

* Fix unit test to go with 2dedba1a4d26d6d6724d3930e8f5eaeb1f65ef6b

## v1.3.0

* Use `apt` cookbook instead of directly calling `apt_update` resource

## v1.2.0

* Add tests
* Fix incorrect path to library to improve idempotency
* Open source the cookbook
* Initial release to Supermarket

## v1.1.0

* Add some parallelism to opencv make

## v1.0.0

* Initial release
