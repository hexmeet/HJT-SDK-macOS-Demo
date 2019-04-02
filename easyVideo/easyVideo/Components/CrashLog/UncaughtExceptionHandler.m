//
//  UncaughtExceptionHandler.m
//  easyVideo
//
//  Created by quanhao huang on 2018/11/22.
//  Copyright © 2018 easyVideo. All rights reserved.
//

#import "UncaughtExceptionHandler.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import "ExceptionModel.h"

@implementation UncaughtExceptionHandler

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
    
    DDLogInfo(@"[Info] OC Crash log save sucess:%d", sucess);
}

void HandleException(NSException *exception)
{
    // 异常的堆栈信息
    NSArray *stackArray = [exception callStackSymbols];
    // 出现异常的原因
    NSString *reason = [exception reason];
    // 异常名称
    NSString *name = [exception name];
    
    NSString *exceptionInfo = [NSString stringWithFormat:@"Exception reason：%@\nException name：%@\nException stack：%@",name, reason, stackArray];
    
    NSLog(@"%@", exceptionInfo);
    
    [UncaughtExceptionHandler saveCrash:exceptionInfo];
}


void InstallUncaughtExceptionHandler(void)
{
    NSSetUncaughtExceptionHandler(&HandleException);
}

@end
