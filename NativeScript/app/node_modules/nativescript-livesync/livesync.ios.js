/**********************************************************************************
 * (c) 2015, Master Technology
 * Licensed under the MIT license or contact me for a Support or Commercial License
 *
 * I do contract work in most languages, so let me solve your problems!
 *
 * Any questions please feel free to email me or put a issue up on the github repo
 * Version 0.0.1 - IOS Dummy Wrapper                  Nathan@master-technology.com
 *********************************************************************************/
"use strict";

// ON THIS IOS platform this is a DUMMY wrapper currently.   I supply it so deployment on iOS won't crash.

/* jshint node: true, browser: true, unused: true, undef: true */
/* global __clearRequireCachedItem */

// --------------------------------------------
var fs = require("file-system");
var fsa = require("file-system/file-system-access").FileSystemAccess;
var application = require('application');
var frameCommon = require('ui/frame/frame-common');
var styleScope = require("ui/styling/style-scope");
// --------------------------------------------
var FSA = new fsa();
// --------------------------------------------

var UpdaterSingleton = null;

var Updater = function() {
    if (UpdaterSingleton) {
        return UpdaterSingleton;
    }
    UpdaterSingleton = this;
    this._modelLink = {};
    this._suspendedNavigation = null;
    this._applicationResumedStatus = 0;

    this._updaterEnabled = false;

    //this._hookFramework();
};

/**
 * Returns debugMode status, or allows you to set it.
 * @param value - true/false or no value.
 * @returns {*} - debug mode status.
 */
Updater.prototype.debugMode = function(value) {
    if (arguments.length) {
        this._isDebugMode = !!value;
    } else if (this._isDebugMode === null) {
        return this.checkForDebugMode();
    }
    return this._isDebugMode;
};

/**
 * Allow you to enable/disable the instant update support
 * @param value - true or false
 * @returns {boolean} the current enabled status
 */
Updater.prototype.enabled = function(value) {
    if (arguments.length) {
        this._updaterEnabled = !!value;
    }
    return this._updaterEnabled;
};

/**
 * Retrieves the App name from the AndroidManifest
 * @returns {string} - Name of App
 */
Updater.prototype.getAppName = function() {
    return null;
};

/**
 * Retrieves the app Version from the AndroidManifest
 * @returns {string} - App Version
 */
Updater.prototype.getAppVersion = function() {
    return null;
};

/**
 * Restart the application
 */
Updater.prototype.restart = function() {
    // Does Nothing
};

/**
 * Returns true if the application is running on a emulator
 * @returns {boolean}
 */
Updater.prototype.checkForEmulator = function() {
    return false;
};

/**
 * Returns a list of application signatures
 * @returns {Array} - signature array
 */
Updater.prototype.getAppSignatures = function() {
        return [];
};

/**
 * Returns true if the application was signed with a DebugKey meaning the app is in debug mode
 * @returns {boolean} - false if it is in release mode
 */
Updater.prototype.checkForDebugMode = function() {
    return false;
};

/**
 * Returns true if this application is signed by a release key
 * @returns {boolean} - false if the app is in debug mode
 */
Updater.prototype.checkForReleaseMode = function() {
    return !this.checkForDebugMode();
};

/**
 * Reload the current page
 * @param p - optional page name to reload
 */
Updater.prototype.reloadPage = function(p) {
    reloadPage(p);
};

/**
 * Is the application suspended
 * @returns {boolean} - true/false
 */
Updater.prototype.isSuspended = function() {
    return this._applicationResumedStatus === 0;
};

/**
 * This allows you to link model(s) to a specific page
 * @param page  - the page that uses this model
 * @param model - the model that is linked to the page
 */
Updater.prototype.addModelPageLink = function(page, model) {
    if (!model.endsWith('.js')) {
        model = model + ".js";
    }
    if (page.endsWith('.js')) {
        page = page.substring(0, page.length-3);
    }
    if (typeof this._modelLink[model] === "undefined") {
        this._modelLink[model] = page;
        return;
    } else if (!Array.isArray(this._modelLink[model])) {
        if (this._modelLink[model] === page) {
        return;
        }
        // Convert to an array if it is already assigned a page
        this._modelLink[model] = [this._modelLink[model]];
    }

    var found = false;
    for (var i=0;i<this._modelLink[model].length;i++) {
        if (this._modelLink[model][i] === page) {
            found = true; break;
        }
    }
    if (!found) {
        this._modelLink[model].push(page);
    }
};

/**
 * Returns the current Application Running path
 * @returns {string}
 */
Updater.prototype.currentAppPath = function() {
    return this._curAppPath;
};



/**********************************/
/******  Internal Functions  ******/
/**********************************/

/**
 * Used to hook into the framework functions
 * @private
 */
Updater.prototype._hookFramework = function() {
    // Have to hook into the framework so that we can return our values if need be.
    if (!global.__clearRequireCachedItem) {
        this._updaterEnabled = false;
    }

    //noinspection JSValidateTypes
    //application.loadCss = loadCss;

    // We need to hook the Resume/Suspend Application events because attempting to navigate while suspended will crash
    var oldResume = application.onResume;
    application.onResume = function () {
        if (oldResume) {
            oldResume();
        }
        UpdaterSingleton._applicationResumed();
    };

    var oldSuspend = application.onSuspend;
    application.onSuspend = function () {
        if (oldSuspend) {
            oldSuspend();
        }
        UpdaterSingleton._applicationSuspended();
    };


};

/**
 * Used to track any pages for navigation while the app is suspended
 * @param value - page name
 * @returns {string} - page name
 * @private
 */
Updater.prototype._suspendedNavigate = function(value) {
    if (arguments.length) {
        this._suspendedNavigation = value;
    }
    return this._suspendedNavigation;
};

/**
 * Used to track if the app is suspended
 * @private
 */
Updater.prototype._applicationSuspended = function() {
    this._applicationResumedStatus--;
};

/**
 * Used to track when the app is resumed
 * @private
 */
Updater.prototype._applicationResumed = function() {
    this._applicationResumedStatus++;
    if (this._suspendedNavigation) {
        reloadPage(this._suspendedNavigation);
        this._suspendedNavigation = null;
    }
};

/**
 * Checks if the modified file is related to the currently loaded page
 * @param v
 * @private
 */
Updater.prototype._checkCurrentPage = function(v) {
    var f = frameCommon.topmost();
    var CE, CEjs, CExml, CEcss;
    if (f.currentEntry && f.currentEntry.entry) {
        CE = f.currentEntry.entry.moduleName;
    }
    if (!CE) {
        return;
    }

    if (CE.toLowerCase().endsWith('.js')) {
        CE = CE.substr(0, CE.lastIndexOf('.'));
    }
    CEjs = CE + '.js';
    CExml = CE + '.xml';
    CEcss = CE + '.css';
    //console.log("******************* Checking ", v, "against:", CEjs, CExml, CEcss);

    if (v === CEjs || v === CExml) {
        reloadPage(CE);
    } else if (v === application.cssFile) {
        loadCss();
    } else if (v === CEcss) {
        loadPageCss(CEcss);
    } else {
        if (v.endsWith('.js')) {
            __clearRequireCachedItem(this._curAppPath + v);
            for (var key in this._modelLink) {
                if (this._modelLink.hasOwnProperty(key)) {
                    if (key === v) {
                        if (Array.isArray(this._modelLink[key])) {
                            for (var j = 0; j < this._modelLink[key].length; j++) {
                                if (this._modelLink[key][j] === CE) {
                                    reloadPage(CE);
                                    return;
                                }
                            }
                        } else if (this._modelLink[key] === CE) {
                            reloadPage(CE);
                        }
                        return;
                    }
                }
            }
        }
   }
};



// ---------------------------------------------------------------
// Create our UpdaterSingleton and assign it to the export
// ---------------------------------------------------------------
UpdaterSingleton = new Updater();
module.exports = UpdaterSingleton;


/**
 * This is the loadCss helper function to replace the one on Application
 */
function loadCss() {
    var cssFileName = fs.path.join(fs.knownFolders.currentApp().path, application.cssFile);

    var applicationCss;
    if (FSA.fileExists(cssFileName)) {
        FSA.readText(cssFileName, function (r) { applicationCss = r; });
        //noinspection JSUnusedAssignment
        application.cssSelectorsCache = styleScope.StyleScope.createSelectorsFromCss(applicationCss, cssFileName);

        // Add New CSS to Current Page
        var f = frameCommon.topmost();
        if (f && f.currentPage) {
            f.currentPage._resetCssValues();
            f.currentPage._styleScope = new styleScope.StyleScope();
            //noinspection JSUnusedAssignment
            f.currentPage._addCssInternal(applicationCss, cssFileName);
            f.currentPage._refreshCss();
        }
    }
}

/**
 * Override a single page's css
 * @param cssFile
 */
function loadPageCss(cssFile) {
    var cssFileName;

    // Eliminate the ./ on the file if present so that we can add the full path
    if (cssFile.startsWith("./")) {
        cssFile = cssFile.substring(2);
    }

    if (cssFile.startsWith(UpdaterSingleton.currentAppPath())) {
        cssFileName = cssFile;
    } else {
        cssFileName = fs.path.join(UpdaterSingleton.currentAppPath(), cssFile);
    }

    var applicationCss;
    if (FSA.fileExists(cssFileName)) {
        FSA.readText(cssFileName, function (r) { applicationCss = r; });

        // Add New CSS to Current Page
        var f = frameCommon.topmost();
        if (f && f.currentPage) {
            f.currentPage._resetCssValues();
            f.currentPage._styleScope = new styleScope.StyleScope();
            //noinspection JSUnusedAssignment
            f.currentPage._addCssInternal(applicationCss, cssFileName);
            f.currentPage._refreshCss();
        }
    }
}

/**
 * This is a helper function to reload the current page
 * @param page
 */
function reloadPage(page) {
    return page;
}



