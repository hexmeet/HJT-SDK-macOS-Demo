//
//  PlistUtils.h
//  easyVideo
//
//  Created by quanhao huang on 2018/9/3.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlistUtils : NSObject

/**
 Save User Info To plistFile

 @param userInfo userInfo
 */
+ (void)saveUserInfoPlistFile:(NSDictionary *)userInfo withFileName:(NSString *)fileName;

/**
 Load User Info

 @return userInfo
 */
+ (NSDictionary *)loadUserInfoPlistFilewithFileName:(NSString *)fileName;

@end
