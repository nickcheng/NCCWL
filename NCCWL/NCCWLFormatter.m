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
  switch (logMessage.flag) {
    case DDLogFlagError   : logLevel = @"Errr:"; break;
    case DDLogFlagWarning : logLevel = @"Warn:"; break;
    case DDLogFlagInfo    : logLevel = @"    :"; break;
    default               : logLevel = @"Verb:"; break;
  }
  
  NSString *dateAndTime = [_dateFormatter stringFromDate:(logMessage.timestamp)];
  NSString *logMsg = logMessage.message;
  NSString *logFunction = logMessage.function;
  NSString *logFile = logMessage.file;
  
  return [NSString stringWithFormat:@"%@(%@) %@ %@ <%@(%@:%lu)>", dateAndTime, [logMessage threadID], logLevel, logMsg, logFunction, logFile, (unsigned long)logMessage.line];
}

@end
