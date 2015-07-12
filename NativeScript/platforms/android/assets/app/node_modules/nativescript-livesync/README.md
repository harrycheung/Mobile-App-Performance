# NativeScript Real time LiveSync

This is currently setup to work with V1.1.0 of NativeScript, if you need upgrade instructions to upgrade to NativeScript 1.1.0 from your version please see: [http://fluentreports.com/blog/?p=79](http://fluentreports.com/blog/?p=79)
 
A NativeScript module providing real time development for Android and (hopefully soon) iOS applications. 

The iOS side is currently just a simple DUMMY WRAPPER so that any usage you use on the Android side will not cause any issues when you deploy to your iOS devices/emulator. 


## License

All this code is (c)2015, Master Technology.   This is released under the MIT License, meaning you are free to include this in any type of program -- However for entities that need a support and/or a commercial license please contact me (nathan@master-technology.com).

I do contract work; so if you have a module you want built for NativeScript (or pretty much any other language) feel free to contact me.


## Real Time LiveSync Demo

[![Video Showing off Real Time LiveSync Development Ability](http://img.youtube.com/vi/cCiyJZexSOQ/0.jpg)](http://www.youtube.com/watch?v=cCiyJZexSOQ)


## VERY IMPORTANT NOTES

Please note as a courtesy since a lot of people have told me they can't compile the android runtimes yet.   I have pre-compiled the needed Android Runtime and you can easily download it from: [http://www.master-technology/tns-android-1.1.0.tgz](http://www.master-technology/tns-android-1.1.0.tgz). 
 Then you will need to run this to remove your current runtime and add the new runtime.  (First command removes, second adds using the .\package folder)

Please note this will delete your **AndroidManifest.xml** file; if you have made any changes to it; you will want to make a backup copy of it first.
 
```cmd
tns platform remove android
tns platform add android --frameworkPath=./tns-android-1.1.0.tgz
```

----

If you want to use this in it's **AWESOME real time LiveSync mode**, you **MUST** be running a patched android runtime. I have added code to disable it in the event the support is not detected.  And it will tell you it is disabled in the log! 
Again this currently requires the Android Runtime to be patched with an addition call so please up-vote the pull request:
[https://github.com/NativeScript/android-runtime/pull/92](https://github.com/NativeScript/android-runtime/pull/92)

You can clone the latest runtime, and manually patch it with my above patch, and then install the runtime following the latest documentation. [http://docs.nativescript.org/running-latest](http://docs.nativescript.org/running-latest)
If you are pulling and building the latest android-runtime; make sure you are also running the current version of the common code.
If you have access to VMWare or VirtualBox and/or are using a virtual machine, my [http://github.com/nathanaela/nativescript-vm](http://github.com/nathanaela/nativescript-vm) installation script will build a fully working VM that has the ability to build the runtimes.  

Currently (on the Android) the application on a new startup will overwrite **ALL** source code with the code that it was compiled with.  So, this can possibly cause you a point of confusion as any code that the watcher has deployed to the emulator will now be reset back to the original deployed code.  
If you have made a LOT of changes to several support files; the easiest solution is just to recompile & redeploy the app; so that the compiled app will now have all your changes.   But if you are just working on a single screen at the moment; then just relaunch the existing app continue making your changes and the watcher will push the changes to the emulator and your app will start using your new changes again.  
I do have a solution for this; I just haven't re-implemented it, my initial attempt at real time updates actually has code that worked around this issue.

Please note the watcher does NOT watch the **tns_module** or **node_module** folders, mainly because these folders rarely change and so adding these folders will consume more resources on your computer.  So any changes to either of these folders you just need to redeploy the app.        
    


## Installation

Run `npm install jshint -g`

If you don't have xmllint already on your machine; you will need to install it. (Windows users: http://xmlsoft.org/sources/win32/)

Run `npm install nativescript-livesync --save` from inside your project's `app` directory:


```
│ <--------- Root Project Folder
│ watcher.js  (copy this file from the nativescript-livesync/support folder)  
│ .jshintrc   (copy this file from the nativescript-livesync/support folder)
├── app <------------------------------ run npm install from inside the app folder, here
│   ├── app.css
│   ├── app.js
│   ├── main-page.js
│   ├── main-page.xml
│   ├── node_modules
│   │   └── nativescript-livesync <-- The install will place the module's code here
│   │       ├── support  <-- Copy watcher.js & .jshintrc from here to the main folder.     
│   │       └── ...
│   ├── package.json <----------------- The install will register “nativescript-livesync” as a dependency here
│   ├── App_Resources  
│   └── tns_modules
│       └── ...
├── lib
└── platforms
    ├── android
    └── ios
```

As is, using npm within NativeScript is still experimental, so it's possible that you'll run into some issues. A more complete solution is in the works, and you can check out [this issue](https://github.com/NativeScript/nativescript-cli/issues/362) for an update on its progress and to offer feedback.

If npm doesn't end up working for you, you can just copy and paste this repo's livesync.android.js, and livesync.ios.js files into your app and reference them directly.


## Usage & Running

To use the livesync module you must first `require()` it from your project's `node_modules` directory:

```js
var livesync = require( "./node_modules/nativescript-livesync/livesync" );
```

You should as a minimum put this in your **app.js** like so:
```js
var application = require("application");
application.mainModule = "main-page";
// ----- MODIFY THIS LINE -----
application.cssFile = "app.css"; // this was "./app.css"
// ----------------------------

// ---- ADD THIS LINE ----
require('./node_modules/nativescript-livesync/livesync');
// -----------------------

application.start();
```

Then this will activate at the start of the application and work for the entire time, also notice the removal of the "./" in the cssFile.  

You will also want to copy the "support" folder files to your main folder as it will contain a .jslintrc (feel free to change it to match your coding styles) file, and the nifty watcher.js file that you run at the start of your development that monitors your local files for any changes.
After you move those two files out to the root 


## Get the LiveSync object
```var livesync = require('./node_modules/nativescript-livesync/livesync');```

### Methods

#### addModelPageLink(Page, Model)
##### Parameters
* Page - this is the page that the model is related too.
* Model - this is the model that relates to the page

#### ignoreFile(Page)
##### Parameters
* Page - this is the file to totally ignored for sending as updates.
You can call this multiple times and it will just add it to a list of files to ignore.

#### restartFile(Page)
##### Parameters
* Page - this is the file to cause the app on the client to restart.  Please note you probably don't want to use this until I have page persistence working and deployed.  This will restart the app; but the notes apply above how the app will reset the pages back to the original compiled pages.  
You can call this multiple times and it will just add it to a list of files to restart on.

#### enabled(value) 
##### Parameters
* (no parameter) will return if it is enabled
* (value) - set it to be enabled (true) or disabled (false)

#### debugMode(value)
##### Parameters 
* (no Parameter) will return if it is running in debugMode 
* (value) - set it to be forced into or out of debugMode, rather than letting it use the detection method.

#### getAppName()
This will return the package name in the from the AndroidManifest

#### getAppVersion()
This will return the VersionName from inside the AndroidManifest

#### restart()
This will fully restart the application - 
**NOTE:** On restart the application will currently **overwrite** any changes that you have sent to the emulator did as it extracts all source code on startup.

#### checkForEmulator()
This will check to see if the app is running on a emulator

#### checkForDebugMode()
This will check to see if the app was signed with a debug key (i.e. debug mode)

#### reloadPage()
This will reload the current page

#### isSuspended()
This will tell you if the application is suspended.  (i.e. some other app has focus)

#### currentAppPath()
This will return the current application path.
