//
//  NCCWL.m
//
//  Created by nickcheng on 13-3-18.
//  Copyright (c) 2013年 NC. All rights reserved.
//

#import "NCCWL.h"
#import <CrashReporter/CrashReporter.h>
#import "NCCWLFormatter.h"
#import "NCCWLLogger.h"
#import "SSZipArchive.h"

@implementation NCCWL {
  NCCWLCrashHandlerBlockType _crashHandlerBlock;
}

#pragma mark -
#pragma mark Public Methods

-(void)setCrashHandler:(NCCWLCrashHandlerBlockType)crashHandler {
  _crashHandlerBlock = crashHandler;
}

#pragma mark -
#pragma mark Init

+ (NCCWL *)sharedInstance {
  static NCCWL *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[NCCWL alloc] init];
  });
  return sharedInstance;
}

- (id)init {
  //
  if((self = [super init]) == nil) return nil;
  
  // Custom initialization
  [self configLog];
  [self configCrash];
  
  return self;
}

#pragma mark -
#pragma mark Private Methods

- (void)configLog {
  NCCWLFormatter *formatter = [[NCCWLFormatter alloc] init];
  [[DDTTYLogger sharedInstance] setLogFormatter:formatter];
  [DDLog addLogger:[DDTTYLogger sharedInstance]];
  [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
  
  DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
  NCCWLFormatter *fileLoggerFormatter = [[NCCWLFormatter alloc] init];
  fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
  fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
  fileLogger.maximumFileSize = 1024 * 100; // 100 KB
  [fileLogger setLogFormatter:fileLoggerFormatter];
  [DDLog addLogger:fileLogger];
  
  NCCWLLogger *logger = [NCCWLLogger sharedInstance];
  [DDLog addLogger:logger];
}

- (void)configCrash {
  PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
  
  // Check if we previously crashed
  if ([crashReporter hasPendingCrashReport])
    [self handleCrashReport];
  
  // Enable the Crash Reporter
  NSError *error;
  if (![crashReporter enableCrashReporterAndReturnError: &error])
    DDLogWarn(@"Warning: Could not enable crash reporter: %@", error);
}

- (void)handleCrashReport {
  PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
  
  //  Try loading the crash report
  NSError *error;
  NSData *crashData;
  crashData = [crashReporter loadPendingCrashReportDataAndReturnError: &error];
  if (!crashData) {
    DDLogWarn(@"Could not load crash report: %@", error);
  } else {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      DDLogInfo(@"Begin zipping logs and crash");
      // Generating zipped file path
      NSString *cacheDir = ((NSURL *)[[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject]).path;
      NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString];
      NSString *zippedFilePath = [cacheDir stringByAppendingPathComponent:[NSString stringWithFormat:@"zip_%@.zip", guid]];
      
      SSZipArchive *zipArchive = [[SSZipArchive alloc] initWithPath:zippedFilePath];
      if ([zipArchive open]) {
        // Zip logs
        NSString *logPath = [cacheDir stringByAppendingPathComponent:@"Logs"];
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        NSDirectoryEnumerator *dirEnumerator = [fileManager enumeratorAtPath:logPath];
        for (NSString *file in dirEnumerator) {
          NSString *fullPath = [logPath stringByAppendingPathComponent:file];
          [zipArchive writeFile:fullPath];
        }
        // Zip crash
        [zipArchive writeData:crashData filename:@"crashData.plcrash"];
        // Purge the report
        [crashReporter purgePendingCrashReport];
        [zipArchive close];
        DDLogInfo(@"Zipped file: %@", zippedFilePath);
      }
      
      // Call CrashHandler to do the rest.
      if (_crashHandlerBlock) {
        DDLogInfo(@"Calling crashHandlerBlock");
        _crashHandlerBlock(zippedFilePath);
      }
    });
  }
}

@end
