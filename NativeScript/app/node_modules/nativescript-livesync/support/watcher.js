#!/usr/bin/env node
/**********************************************************************************
 * (c) 2015, Master Technology
 * Licensed under the MIT license or contact me for a Support or Commercial License
 *
 * I do contract work in most languages, so let me solve your problems!
 *
 * Any questions please feel free to email me or put a issue up on the github repo
 * Version 0.0.3                                      Nathan@master-technology.com
 *********************************************************************************/
"use strict";

// Load our Requires
var fs = require('fs');
var cp = require('child_process');
var os = require('os');
var crypto = require('crypto');


// Configuration -----------------------------
var watching = [".css", ".js", ".xml"];
// -------------------------------------------

console.log("\n------------------------------------------------------");
console.log("LiveSync Watcher v0.03");
console.log("(c)2015, Master Technology.  www.master-technology.com");
console.log("------------------------------------------------------");


// Setup any missing Prototypes
if (!String.prototype.endsWith) {
    String.prototype.endsWith = function(searchString, position) {
        var subjectString = this.toString();
        if (position === undefined || position > subjectString.length) {
            position = subjectString.length;
        }
        position -= searchString.length;
        var lastIndex = subjectString.indexOf(searchString, position);
        return lastIndex !== -1 && lastIndex === position;
    };
}


// Load the Project Information and output it
/* ---------------------------------------------------------- */
var info, projectData;
try {
    info = fs.readFileSync('package.json');
    projectData = JSON.parse(info);
}
catch (err) {
        console.log("Unable to read your package.json file, the watcher.js MUST be in your root of your application's directory.");
        process.exit(1);
        return;
}

// The default project name is "org.nativescript.<yourname>"
// however, if you know what you are doing you can replace this so in the future
// when this is no longer hard coded; I want to make sure that it accepts them.

if (!projectData || !projectData.nativescript || !projectData.nativescript.id || projectData.nativescript.id.length === 0 || projectData.nativescript.id.indexOf('.') < 3) {
    console.log("Your package.json file appears to be corrupt, the project that I am detecting is: ", projectData && projectData.nativescript && projectData.nativescript.id);
    process.exit(1);
    return;
}
console.log("Watching your project:", projectData.nativescript.id);

checkFileSha("./platforms/android/libs/x86/libNativeScript.so","60607640311349f9899c50115abf9c25e0c0c9be");
checkFileSha("./platforms/android/libs/armeabi-v7a/libNativeScript.so","f942519dec81124584d418d40eaefbb3860c2912");




// Check for jsHint & xmllint support
/* ---------------------------------------------------------- */
var hasJSHint = false;
var hasXMLLint = false;
var _jshintCallback = function(error) {
    if (!error || error.code === 0) {
        hasJSHint = true;
    } else {
        console.log("JSHINT has not been detected, disabled JSHINT support.");
        console.log("Without JSHINT support, changes to JS files might cause the phone app to crash.");
        console.log("-------------------------------------------------------------------------------");
    }
};
var _xmllintCallback = function(error,a,b) {
    if (!error && b === '') {
        hasXMLLint = true;
    } else {
        console.log("XMLLINT has not been detected, disabled XMLLINT support.");
        console.log("Without XMLLINT support, malformed XML files will cause the phone app to crash.");
        console.log("--------------------------------------------------------------------------------");
    }
};

cp.exec("jshint watcher.js", {timeout: 3000}, _jshintCallback);
if (os.type() === 'Windows_NT') {
  cp.exec("xmllint --noout .\\platforms\\android\\AndroidManifest.xml", {timeout: 3000}, _xmllintCallback);
} else {
  cp.exec("xmllint --noout ./platforms/android/AndroidManifest.xml", {timeout: 3000}, _xmllintCallback);
}

// Globals
var timeStamps = {};

// Startup the Watchers...
setupWatchers("./app");




/**
 * isWatching - will respond true if watching this file type.
 * @param fileName
 * @returns {boolean}
 */
function isWatching(fileName) {
    for (var i=0;i<watching.length;i++) {
        if (fileName.endsWith(watching[i])) {
            return true;
        }
    }
    return false;
}

/**
 * check for any changed files on platforms (Mac's) that don't pass a filename in the callback
 * @param dir
 * @returns {*}
 */
function checkForChangedFiles(dir) {
    var fileList = fs.readdirSync(dir);
    for (var i=0;i<fileList.length;i++) {
        if (!isWatching(dir+fileList[i])) { continue; }
        if (!fs.existsSync(dir+fileList[i])) { continue; }
        var stats = fs.statSync(dir+fileList[i]);
        if (timeStamps[dir+fileList[i]] === undefined || timeStamps[dir+fileList[i]] < stats.mtime.getTime()) {
            timeStamps[dir+fileList[i]] = stats.mtime.getTime();
            return dir+fileList[i];
        }

    }
    return null;
}

/**
 * This runs the adb command so that we can push the file up to the emulator or device
 * @param fileName
 */
function runADB(fileName) {
    var path = "/data/data/" + projectData.nativescript.id + "/files/" + fileName;
    cp.exec('adb push "'+fileName+'" ' + path, {timeout: 5000}, function(err, sout, serr) {
        console.log("Pushing to Device: ", fileName);
        if (err) {
            console.log(err);
            console.log(sout);
            console.log(serr);
        }
    });
}

/**
 * This runs the linters to verify file sanity before pushing to the device
 * @param fileName
 */
function checkParsing(fileName) {
    if (fileName === "./app/app.js") { return; }
    console.log("\nChecking updated file: ", fileName);

    var callback = function(err, stdout , stderr) {
        if (err && (err.code !== 0 || err.killed) ) {
            //console.log("Error: ", err);
            console.log("---------------------------------------------------------------------------------------");
            console.log("---- Failed Sanity Tests on", fileName);
            console.log("---------------------------------------------------------------------------------------");
            if (stdout) { console.log("STDOut", stdout); }
            if (stderr) { console.log("STDErr", stderr); }
            console.log("---------------------------------------------------------------------------------------\n");
        } else {
            runADB(fileName);
        }
    };

  if (fileName.endsWith(".js")) {
      if (hasJSHint) {
          cp.exec('jshint "' + fileName + '"', {timeout: 5000}, callback);
      } else {
          console.log("WARNING: JSHINT is not installed, no test performed on JS file.");
          callback(null, "", "");
      }
  } else if (fileName.endsWith(".xml")) {
      if (hasXMLLint) {
          cp.exec('xmllint --noout "' + fileName + '"', {timeout: 5000}, callback);
      } else {
          console.log("WARNING: XMLLINT is not installed, no test performed on XML file.");
          callback(null, "", "");
      }
  } else {
      callback(null, "", "");
  }
}

/**
 * This is the watcher callback to verify the file actually changed
 * @param dir
 * @returns {Function}
 */
function getWatcher(dir) {
    return function (event, fileName) {
        if (event === "rename") { return; }
        if (!fileName) {
            fileName = checkForChangedFiles(dir);
            if (fileName) {
                checkParsing(fileName);
            }
        }
        else {
            for (var i = 0; i < watching.length; i++) {
                if (fileName.endsWith(watching[i])) {
                    if (!fs.existsSync(dir+fileName)) { continue; }

                    var stat = fs.statSync(dir + fileName);
                    if (timeStamps[dir+fileName] === undefined || timeStamps[dir+fileName] < stat.mtime.getTime()) {
                        timeStamps[dir+fileName] = stat.mtime.getTime();
//                        console.log(dir + fileName, stat.mtime.getTime());
                        checkParsing(dir+fileName);
                    }

                }
            }
        }
    };
}

/**
 * This setups a watcher on a directory
 * @param path
 */
function setupWatchers(path) {
    fs.watch(path, getWatcher(path + "/"));
    var fileList = fs.readdirSync(path);
    for (var i = 0; i < fileList.length; i++) {
        var stats = fs.statSync(path + "/" + fileList[i]);
        if (isWatching(fileList[i])) {
            timeStamps[path + "/" + fileList[i]] = stats.mtime.getTime();
//                console.log(path + "/" + fileList[i], stats.mtime.getTime());
        } else {
            if (stats.isDirectory()) {
                if (fileList[i] === "node_modules") {
                    continue;
                }
                if (fileList[i] === "tns_modules") {
                    continue;
                }
                if (fileList[i] === "App_Resources") {
                    continue;
                }
                setupWatchers(path + "/" + fileList[i]);
            }
        }
    }
}


function checkFileSha(filename, hash) {
    var shaSum = crypto.createHash('sha1');
    var readStream = fs.ReadStream(filename);
    readStream.on('data', function(d) {
        shaSum.update(d);
    });

    readStream.on('end', function() {
        var d = shaSum.digest('hex');
        if (d !== hash) {
            console.error("\n\nYour platform does not seem to be running the correct version of the runtimes.  Please see http://github.com/NathanaelA/nativescript-livesync");
            process.exit(1);
        }
    });
}