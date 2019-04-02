//
//  SignalHandler.m
//  easyVideo
//
//  Created by quanhao huang on 2018/11/22.
//  Copyright © 2018 easyVideo. All rights reserved.
//

#import "SignalHandler.h"
#import "SignalHandler.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import "UncaughtExceptionHandler.h"
#import "ExceptionModel.h"

@implementation SignalHandler

+ (void)saveCrash:(NSString *)exceptionInfo
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *logDirectory = [[paths objectAtIndex:0]stringByAppendingPathComponent:@"Log"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:logDirectory]) {
        NSError *error = nil;
        [fileManager createDirectoryAtPath:logDirectory withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"error = %@",[error localizedDescription]);
        }
    }
    
    NSString *logFilePath = [logDirectory stringByAppendingPathComponent:@"UncaughtException.log"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:logDirectory]){
        [[NSFileManager defaultManager] createDirectoryAtPath:logDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    
    BOOL sucess = [exceptionInfo writeToFile:logFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    DDLogInfo(@"[Info] Signal Crash log save sucess:%d", sucess);
}

@end

void SignalExceptionHandler(int signal)
{
    NSMutableString *mstr = [[NSMutableString alloc] init];
    [mstr appendString:@"Stack:\n"];
    void* callstack[128];
    int i, frames = backtrace(callstack, 128);
    char** strs = backtrace_symbols(callstack, frames);
    for (i = 0; i <frames; ++i) {
        [mstr appendFormat:@"%s\n", strs[i]];
    }
    [SignalHandler saveCrash:mstr];
}

void InstallSignalHandler(void)
{
    signal(SIGHUP, SignalExceptionHandler);
    signal(SIGINT, SignalExceptionHandler);
    signal(SIGQUIT, SignalExceptionHandler);
    
    signal(SIGABRT, SignalExceptionHandler);
    signal(SIGILL, SignalExceptionHandler);
    signal(SIGSEGV, SignalExceptionHandler);
    signal(SIGFPE, SignalExceptionHandler);
    signal(SIGBUS, SignalExceptionHandler);
    signal(SIGPIPE, SignalExceptionHandler);
}
