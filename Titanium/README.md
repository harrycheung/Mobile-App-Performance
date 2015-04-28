# Titanium app

## Code

The code is identical to the JavaScript version, except for some variables in [point.js](Resources/point.js) that have been renamed to work around [TIMOB-18770](https://jira.appcelerator.org/browse/TIMOB-18770) for the Windows SDK.

## Running

For iOS and Android:

	$ sudo npm install -g appcelerator/titanium#master
	$ ti sdk install
	$ ti build -p ios|android -T device -C 

For Windows:

* Follow [this guide](http://www.tidev.io/2015/01/12/how-to-try-the-titanium-windows-platform-preview-for-free/) to set up
* `ti build -p windows -G 00000000-0000-1000-8000-000000000000 -T wp-device`