# NCCWL #

CWL == Crash w/ Logs. When your app crash, zip and send the crash info and your recent logs.

## Overview ##

This is a glue library. 

* It uses [PLCrashReporter](https://plcrashreporter.org) to generate crash log. 
* It uses [CocoaLumberjack](https://github.com/robbiehanson/CocoaLumberjack) and [NSLogger](https://github.com/fpillet/NSLogger) to log everything to a file and NSLoggerViewer.
* When a crash occurred, next time you start the app, it'll use [ssziparcive](https://github.com/soffes/ssziparchive) to zip them all and call the block you set with the path of the zip file.

I didn't expose all the properties of log and crash libraries. You can modify them in file ```NCCWL.m``` to fit your need. 

## Dependence ##

Open source libraries:

* [PLCrashReporter](https://plcrashreporter.org) (If you have problem compiling the source code, just download the binary release.)
* [CocoaLumberjack](https://github.com/robbiehanson/CocoaLumberjack)
* [NSLogger](https://github.com/fpillet/NSLogger)
* [ssziparcive](https://github.com/soffes/ssziparchive)

Other frameworks:

* SystemConfiguration.framework
* CFNetwork.framework
* libz.dylib

## Installation ##

Place ```NCCWL``` folder in your project. Add the dependences. That's all.

### Install w/ CocoaPods ###

Add code below in your ```Podfile```. And run ```pod install```.

```
pod 'NCCWL'
```

At last, you need to manual add ```CrashReporter.framework``` to your project. It is in ```(YourProjectFolder)/Pods/NCCWL```.

Because I'm new to CocoaPods, you need to do the last extra step. If you have any idea with the CocoaPods spec file, please tell me. Thank you in advanced!

## Usage ##

Import ```NCCWL.h``` in your main delegate file. and place the code below in your ```application:didFinishLaunchingWithOptions```.

```objective-c
[[NCCWL sharedInstance] setCrashHandler:^(NSString *cwlFilePath) {
  // Handle your zipped crash and logs.
  // How about upload the zipped file to a remote server?
  [Uploader uploadFile:cwlFilePath];
}];
```

----

If you have any problems when using this engine, please feel free to drop me an issue or contact me:

* Twitter: <http://twitter.com/nickcheng>
