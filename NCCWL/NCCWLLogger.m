//
//  NCCWLLogger.m
//
//  Created by nickcheng on 13-3-18.
//  Copyright (c) 2013年 NC. All rights reserved.
//

#import "NCCWLLogger.h"
#import "LoggerClient.h"

@implementation NCCWLLogger {

}

static Logger *_DDNSLogger_logger = nil;

+ (NCCWLLogger *)sharedInstance {
  static NCCWLLogger *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[NCCWLLogger alloc] init];
  });
  return sharedInstance;
}

- (id)init {
  //
	if((self = [super init]) == nil) return nil;
  
  // create and remember the logger instance
  _DDNSLogger_logger = LoggerInit();
  
  // configure the logger
  LoggerSetOptions(_DDNSLogger_logger, kLoggerOption_BufferLogsUntilConnection | kLoggerOption_BrowseBonjour | kLoggerOption_BrowseOnlyLocalDomain );
  LoggerStart(_DDNSLogger_logger);
  
  return self;
}

- (void)logMessage:(DDLogMessage *)logMessage {
	NSString *logMsg = logMessage->logMsg;
  
	if (formatter) {
    // formatting is supported but not encouraged!
		logMsg = [formatter formatLogMessage:logMessage];
  }
  
	if (logMsg)	{
    int nsloggerLogLevel;
		switch (logMessage->logFlag) {
        // NSLogger log levels start a 0, the bigger the number,
        // the more specific / detailed the trace is meant to be
			case LOG_FLAG_ERROR : nsloggerLogLevel = 0; break;
			case LOG_FLAG_WARN  : nsloggerLogLevel = 1; break;
			case LOG_FLAG_INFO  : nsloggerLogLevel = 2; break;
			default : nsloggerLogLevel = 3; break;
		}
    
    LogMessageF(logMessage->file, logMessage->lineNumber, logMessage->function, @"",
                nsloggerLogLevel, @"%@", logMsg);
  }
}

- (NSString *)loggerName {
	return @"cocoa.lumberjack.NSLogger";
}

@end
