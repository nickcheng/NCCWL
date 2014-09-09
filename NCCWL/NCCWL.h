//
//  NCCWL.h
//
//  Created by nickcheng on 13-3-18.
//  Copyright (c) 2013年 NC. All rights reserved.
//

#import "DDLog.h"
#import "DDLogMacros.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

typedef void(^NCCWLCrashHandlerBlockType)(NSString *cwlFilePath);

@interface NCCWL : NSObject

+ (NCCWL *)sharedInstance;

- (void)setCrashHandler:(NCCWLCrashHandlerBlockType)crashHandler;

@end