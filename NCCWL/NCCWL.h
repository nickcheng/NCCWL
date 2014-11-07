//
//  NCCWL.h
//
//  Created by nickcheng on 13-3-18.
//  Copyright (c) 2013年 NC. All rights reserved.
//

#import <CocoaLumberjack/CocoaLumberjack.h>

#ifdef DEBUG
static const int ddLogLevel = DDLogLevelVerbose;
#else
static const int ddLogLevel = DDLogLevelWarning;
#endif

typedef void(^NCCWLCrashHandlerBlockType)(NSString *cwlFilePath);

@interface NCCWL : NSObject

+ (NCCWL *)sharedInstance;

- (void)setCrashHandler:(NCCWLCrashHandlerBlockType)crashHandler;

@end