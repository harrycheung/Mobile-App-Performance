var application = require("application");
application.mainModule = "main-page";
application.cssFile = "./app.css";

var livesync = require( "./node_modules/nativescript-livesync/livesync" );
console.log("Live sync:"  + livesync.enabled());
application.start();
