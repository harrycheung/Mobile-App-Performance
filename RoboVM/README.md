Mobile App Performance - RoboVM
===============================
[![RoboVM Logo](http://sht.tl/TXcl6m)](http://www.robovm.com)

This is the [RoboVM](http://www.robovm.com) version of [Harry Cheung's Mobile App Performance test sample](https://medium.com/@harrycheung/cross-platform-mobile-performance-testing-d0454f5cd4e9). RoboVM allows you to write native iOS apps using Java, Scala, Kotlin or any other JVM language.

## Running via Maven
Compile and deploy to your connected and provisioned device via

32-bit device
```
mvn clean compile robovm:ios-device -Drobovm.arch=thumbv7
```

64-bit device
```
mvn clean compile robovm:ios-device -Drobovm.arch=arm64
```

## Running via Gradle
Compile and deploy to your connected and provisioned device via

32-bit device
```
./gradlew -Probovm.arch=thumbv7 compileJava launchIOSDevice
```

64-bit device
```
./gradlew -Probovm.arch=arm64 compileJava launchIOSDevice
```

## Running via Eclipse
Follow this [handy guide on how to setup RoboVM for Eclipse](http://docs.robovm.com/user/1.0.0-SNAPSHOT/). Import the project via `File -> Import... -> General -> Existing Projects into Workspace`, pointing the file browser at this directory.

Right click the imported project in the project or package view, select `Run as -> iOS Device App`. This will compile and deploy the app to your connected and provisioned device.

You can switch the architecture for which the app is compiled in the run configuration you just created.