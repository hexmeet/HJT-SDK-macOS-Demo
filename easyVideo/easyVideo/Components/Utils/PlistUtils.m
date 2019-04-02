//
//  PlistUtils.m
//  easyVideo
//
//  Created by quanhao huang on 2018/9/3.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "PlistUtils.h"

@implementation PlistUtils

+ (void)saveUserInfoPlistFile:(NSDictionary *)userInfo withFileName:(NSString *)fileName
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    NSString *filepath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", fileName]];
    [userInfo writeToFile:filepath atomically:YES];
}

+ (NSDictionary *)loadUserInfoPlistFilewithFileName:(NSString *)fileName
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    NSString *filepath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", fileName]];
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:filepath];
    return data;
}

@end
