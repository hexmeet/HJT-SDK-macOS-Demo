//
//  EVUtils.h
//  easyVideo
//
//  Created by quanhao huang on 2018/9/3.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVUtils : NSObject

/**
 Obtain engineering path

 @return engineering path
 */
+ (NSString *)get_current_app_path;

/** get download path */
+ (NSString *)get_download_app_path;

/** Delete the blank space */
+ (NSString *)removeTheStringBlankSpace:(NSString *)str;

/** Only Numbers are allowed */
+ (BOOL)isPureNum:(NSString *)text;

/** formater Seconds To Timer */
+ (NSString *)formaterSecondsToTimer:(int)duration;

/** Fill in the image */
+ (NSImage *)resizeImage:(NSImage *)sourceImage size:(NSSize)size;

/** Set the View Animation */
+ (void)setAnimation:(NSView *)animationView andStarlocation:(NSPoint)starP andStoplocation:(NSPoint)stopP andDurationTime:(NSInteger)time;

/** Get File Path */
+ (NSString *)bundleFile:(NSString *)file;

/** Color */
+ (NSColor *)colorWithHexString:(NSString *)color;

/**
 判断是否含有特殊字符（有返回Mac 没有则返回全部 可以包含空格）
 
 @param content 传入判断字符串
 @return 返回新字符串
 */
+ (NSString *)judgeString:(NSString *)content;

/** Calculating file size */
+ (NSInteger)getFileSize:(NSString *)url;

/** 获取 bundle version版本号 */
+ (NSString*)getLocalAppVersion;

/** 获取BundleID */
+ (NSString*)getBundleID;

/** 版本比较 */
+ (NSInteger)compareVersion:(NSString *)v1 to:(NSString *)v2;

/** 日志大小设置 */
+ (void)saveNewLogWhenOldLogTooBig;

/** 获取当前时间 */
+ (NSString *)getCurrentTimes;

@end
