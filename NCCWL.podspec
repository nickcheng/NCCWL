Pod::Spec.new do |s|
  s.name         = "NCCWL"
  s.version      = "0.2.5"
  s.summary      = "CWL == Crash w/ Logs. When your app crash, zip and send the crash info and your recent logs."
  s.description  = <<-DESC
                    This is a glue library. 

                    * It uses [PLCrashReporter](https://code.google.com/p/plcrashreporter/) to generate crash log. 
                    * It uses [CocoaLumberjack](https://github.com/robbiehanson/CocoaLumberjack) and [NSLogger](https://github.com/fpillet/NSLogger) to log everything to a file and NSLoggerViewer.
                    * When a crash occurred, next time you start the app, it'll use [ssziparcive](https://github.com/soffes/ssziparchive) to zip them all and call the block you set with the path of the zip file.

                    I didn't expose all the properties of log and crash libraries. You can modify them in file ```NCCWL.m``` to fit your need. 
                   DESC
  s.homepage     = "https://github.com/nickcheng/NCCWL"
  s.license      = "MIT"
  s.author       = { "nickcheng" => "n@nickcheng.com" }
  s.source       = { :git => "https://github.com/nickcheng/NCCWL.git", :tag => "0.2.5" }

  s.platform     = :ios, "9.0"
  s.requires_arc = true

  s.source_files = "NCCWL"
  s.public_header_files = "NCCWL/*.h"

  s.dependency "CocoaLumberjack", "~> 2.3.0"
  s.dependency "NSLogger", "~> 1.5.1"
  s.dependency "SSZipArchive", "~> 1.2.0"
  s.dependency "PLCrashReporter-DynamicFramework", "~> 1.3.0.1"
end
