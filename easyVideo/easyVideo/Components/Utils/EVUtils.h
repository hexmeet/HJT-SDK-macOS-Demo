//
//  EVUtils.h
//  easyVideo
//
//  Created by quanhao huang on 2018/9/3.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "SoundManager.h"
#import <WebKit/WebKit.h>

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

/** Json 解析*/
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/** 屏幕录制权限检测 */
+ (BOOL)canRecord;

/** 屏幕权限申请*/
+ (void)showScreenRecordingPrompt;

/** 查询用户配置Plist文件 */
+ (BOOL)queryUserPlist:(NSString *)queryValue;

/** 查询用户保存信息*/
+ (NSString *)queryUserInfo:(NSString *)queryValue;

/** 呼叫铃声相关 */
+ (void)playSound;
+ (void)stopSound;

/** 对象转字典 */
+ (NSDictionary*)getObjectData:(id)obj;

//聊天界面时间显示内容
+ (NSString *)getDateDisplayString:(long long)miliSeconds;

//解析RFC3339
+ (NSString *)userVisibleDateTimeStringForRFC3339DateTimeString:(NSString *)rfc3339DateTimeString;
    
/**
 计算2个时间的差值是否大于10分钟
 example
 NSString *time1 = @"2019-06-23 12:18:15";
 NSString *time2 = @"2019-06-28 10:10:10";
 */
+ (BOOL)compareTwoTime:(NSString *)time1 time2:(NSString *)time2;

//保持四周一定区域像素不拉伸，将图像扩散到一定的大小
- (NSImage *)stretchableImageWithSize:(NSSize)size edgeInsets:(NSEdgeInsets)insets;
//保持leftWidth,rightWidth这左右一定区域不拉伸，将图片宽度拉伸到(leftWidth+middleWidth+rightWidth)
- (NSImage *)stretchableImageWithLeftCapWidth:(float)leftWidth middleWidth:(float)middleWidth rightCapWidth:(float)rightWidth;

/**
 清除所有的WebCache
 */
+ (void)deleteWebCache;

@end
