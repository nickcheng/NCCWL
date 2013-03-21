//
//  NCCWLFormatter.m
//
//  Created by nickcheng on 13-3-18.
//  Copyright (c) 2013年 NC. All rights reserved.
//

#import "NCCWLFormatter.h"

@implementation NCCWLFormatter {
  NSDateFormatter *_dateFormatter;
}

- (id)init {
  if((self = [super init])) {
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
  }
  return self;
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
  NSString *logLevel;
  switch (logMessage->logFlag) {
    case LOG_FLAG_ERROR : logLevel = @"Errr:"; break;
    case LOG_FLAG_WARN  : logLevel = @"Warn:"; break;
    case LOG_FLAG_INFO  : logLevel = @"    :"; break;
    default             : logLevel = @"Verb:"; break;
  }
  
  NSString *dateAndTime = [_dateFormatter stringFromDate:(logMessage->timestamp)];
  NSString *logMsg = logMessage->logMsg;
  NSString *logFunction = [NSString stringWithUTF8String:logMessage->function];
  NSString *logFile = [NSString stringWithUTF8String:logMessage->file];
  
  return [NSString stringWithFormat:@"%@(%@) %@ %@ <%@(%@:%d)>", dateAndTime, [logMessage threadID], logLevel, logMsg, logFunction, logFile, logMessage->lineNumber];
}

@end
