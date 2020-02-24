//
//  EVUtils.m
//  easyVideo
//
//  Created by quanhao huang on 2018/9/3.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "EVUtils.h"

@implementation EVUtils

+ (NSString *)get_current_app_path
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}

+ (NSString *)get_download_app_path
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}

+ (NSString *)removeTheStringBlankSpace:(NSString *)str
{
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+ (BOOL)isPureNum:(NSString *)text{
    if (!text) {
        return YES;
    }
    NSScanner *scan = [NSScanner scannerWithString:text];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

+ (NSString *)formaterSecondsToTimer:(int)duration {
    int hour = duration / 3600;
    duration = duration % 3600;
    
    int minute = duration / 60;
    duration = duration % 60;
    
    int second = duration;
    
    NSMutableString *durationString = [[NSMutableString alloc]init];
    if(hour >=0 && hour < 10) {
        [durationString appendFormat:@"%d%d", 0, hour];
    }else {
        [durationString appendFormat:@"%d", hour];
    }
    
    if(minute >= 0  && minute < 10) {
        [durationString appendFormat:@":%d%d", 0, minute];
    }else {
        [durationString appendFormat:@":%d", minute];
    }
    if(second >= 0  && second < 10) {
        [durationString appendFormat:@":%d%d", 0, second];
    }else {
        [durationString appendFormat:@":%d", second];
    }
    
    return durationString;
}

//Fill in the image
+ (NSImage*)resizeImage:(NSImage*)sourceImage size:(NSSize)size{
    
    NSRect targetFrame = NSMakeRect(0, 0, size.width, size.height);
    NSImage*  targetImage = [[NSImage alloc] initWithSize:size];
    
    NSSize sourceSize = [sourceImage size];
    
    float ratioH = size.height/ sourceSize.height;
    float ratioW = size.width / sourceSize.width;
    
    NSRect cropRect = NSZeroRect;
    if (ratioH >= ratioW) {
        cropRect.size.width = floor (size.width / ratioH);
        cropRect.size.height = sourceSize.height;
    } else {
        cropRect.size.width = sourceSize.width;
        cropRect.size.height = floor(size.height / ratioW);
    }
    
    cropRect.origin.x = floor( (sourceSize.width - cropRect.size.width)/2 );
    cropRect.origin.y = floor( (sourceSize.height - cropRect.size.height)/2 );
    
    
    
    [targetImage lockFocus];
    [sourceImage drawInRect:targetFrame
                   fromRect:cropRect       //portion of source image to draw
                  operation:NSCompositingOperationCopy  //compositing operation
                   fraction:1.0              //alpha (transparency) value
             respectFlipped:YES              //coordinate system
                      hints:@{NSImageHintInterpolation:
                                  [NSNumber numberWithInt:NSImageInterpolationLow]}];
    
    [targetImage unlockFocus];
    
    return targetImage;
}

+ (void)setAnimation:(NSView *)animationView andStarlocation:(NSPoint)starP andStoplocation:(NSPoint)stopP andDurationTime:(NSInteger)time
{
    CABasicAnimation *basicAni   = [CABasicAnimation animation];
    basicAni.keyPath             = @"position";
    basicAni.fromValue           = [NSValue valueWithPoint:starP];
    basicAni.toValue             = [NSValue valueWithPoint:stopP];
    basicAni.duration            = time;
    basicAni.fillMode            = kCAFillModeForwards;
    basicAni.removedOnCompletion = NO;
    [animationView.layer addAnimation:basicAni forKey:nil];
}

+ (NSString *)bundleFile:(NSString *)file;
{
    return [[NSBundle mainBundle] pathForResource:[file stringByDeletingPathExtension] ofType:[file pathExtension]];
}

+ (NSColor *) colorWithHexString: (NSString *)color{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [NSColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [NSColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [NSColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+ (NSString *)judgeString:(NSString *)content
{
    //可以包含空格
    NSString *newcontent = [content stringByReplacingOccurrencesOfString:@" " withString:@""];
    //判断特殊字符正则表达式
    NSString * nameCharacters = @"[ \\~\\!\\/\\@\\#\\$\\%\\^\\&#\\$\\%\\^\\&amp;\\*\\(\\)\\-\\_\\=\\+\\\\\\|\\[\\{\\}\\]\\;\\:\\\'\\\"\\,\\&#\\$\\%\\^\\&amp;\\*\\(\\)\\-\\_\\=\\+\\\\\\|\\[\\{\\}\\]\\;\\:\\\'\\\"\\,\\&lt;\\.\\&#\\$\\%\\^\\&amp;\\*\\(\\)\\-\\_\\=\\+\\\\\\|\\[\\{\\}\\]\\;\\:\\\'\\\"\\,\\&lt;\\.\\&gt;\\/\\?]";
    
    NSPredicate * isSpecialCharacter =  [NSPredicate predicateWithFormat:@"SELF MATCHES%@",nameCharacters];
    
    if (![isSpecialCharacter evaluateWithObject:newcontent]) {
        return content;
    }
    return @"Mac";
}

+ (NSInteger)getFileSize:(NSString *)url{
    NSFileManager *file = [NSFileManager defaultManager];
    NSDictionary *dict = [file attributesOfItemAtPath:url error:nil];
    unsigned long long size = [dict fileSize];
    return size;
}

+ (NSString*)getLocalAppVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return infoDictionary[@"CFBundleVersion"];
}

+ (NSString*)getBundleID
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

/**
 比较两个版本号的大小
 
 @param v1 第一个版本号
 @param v2 第二个版本号
 @return 版本号相等,返回0; v1小于v2,返回-1; 否则返回1.
 */
+ (NSInteger)compareVersion:(NSString *)v1 to:(NSString *)v2 {
    // 都为空，相等，返回0
    if (!v1 && !v2) {
        return 0;
    }
    
    // v1为空，v2不为空，返回-1
    if (!v1 && v2) {
        return -1;
    }
    
    // v2为空，v1不为空，返回1
    if (v1 && !v2) {
        return 1;
    }
    
    // 获取版本号字段
    NSArray *v1Array = [v1 componentsSeparatedByString:@"."];
    NSArray *v2Array = [v2 componentsSeparatedByString:@"."];

    NSInteger smallCount = (v1Array.count > v2Array.count) ? v2Array.count : v1Array.count;
    
    for (int i = 0; i < smallCount; i++) {
        NSInteger value1 = [[v1Array objectAtIndex:i] integerValue];
        NSInteger value2 = [[v2Array objectAtIndex:i] integerValue];
        if (value1 > value2) {
            // v1版本字段大于v2版本字段，返回1
            return 1;
        } else if (value1 < value2) {
            // v2版本字段大于v1版本字段，返回-1
            return -1;
        }
        
        // 版本相等，继续循环。
    }
    
    // 版本可比较字段相等，则字段多的版本高于字段少的版本。
    if (v1Array.count > v2Array.count) {
        return 1;
    } else if (v1Array.count < v2Array.count) {
        return -1;
    } else {
        return 0;
    }
    
    return 0;
}

+ (void)saveNewLogWhenOldLogTooBig
{
    //get EVlog path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *logDirectory = [[paths objectAtIndex:0]stringByAppendingPathComponent:@"Log"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([self getFileSize:[logDirectory stringByAppendingPathComponent:@"EVLOG.log"]]>20000000) {
        [fileManager removeItemAtPath:[logDirectory stringByAppendingPathComponent:@"EVLOG2.log"] error:nil];
        NSString *dataPath = [logDirectory stringByAppendingPathComponent:@"/EVLOG2.log"];
        NSError *error = nil;
        NSString *srcPath = [logDirectory stringByAppendingPathComponent:@"/EVLOG.log"];
        BOOL success = [[NSFileManager defaultManager] copyItemAtPath:srcPath toPath:dataPath error:&error];
        if (success == YES)
        {
            NSLog(@"Copied");
            [fileManager removeItemAtPath:[logDirectory stringByAppendingPathComponent:@"EVLOG.log"] error:nil];
        }
        else
        {
            NSLog(@"Not Copied %@", error);
        }
    }
    
    NSString *dateStr = @"EVLOG";
    NSString *logFilePath = [logDirectory stringByAppendingFormat:@"/%@.log",dateStr];
    
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a++", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a++", stderr);
}

+ (NSString *)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    return currentTimeString;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    return dic;
}

+ (BOOL)canRecordScreen
{
    if (@available(macOS 10.15, *)) {
        CFArrayRef windowList = CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly, kCGNullWindowID);
        NSUInteger numberOfWindows = CFArrayGetCount(windowList);
        NSUInteger numberOfWindowsWithName = 0;
        for (int idx = 0; idx < numberOfWindows; idx++) {
            NSDictionary *windowInfo = (NSDictionary *)CFArrayGetValueAtIndex(windowList, idx);
            NSString *windowName = windowInfo[(id)kCGWindowName];
            if (windowName) {
                numberOfWindowsWithName++;
            } else {
                //no kCGWindowName detected -> not enabled
                break; //breaking early, numberOfWindowsWithName not increased
            }

        }
        CFRelease(windowList);
        return numberOfWindows == numberOfWindowsWithName;
    }
    return YES;
}

+ (BOOL)canRecord{
    if (@available(macOS 10.15, *)) {
            CFArrayRef windowList = CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly, kCGNullWindowID);
            NSUInteger numberOfWindows = CFArrayGetCount(windowList);
            NSUInteger numberOfWindowsWithName = 0;
            for (int idx = 0; idx < numberOfWindows; idx++) {
                NSDictionary *windowInfo = (NSDictionary *)CFArrayGetValueAtIndex(windowList, idx);
                NSString *windowName = windowInfo[(id)kCGWindowName];
                if (windowName) {
                    numberOfWindowsWithName++;
                } else {
                    //no kCGWindowName detected -> not enabled
                    break; //breaking early, numberOfWindowsWithName not increased
                }

            }
            CFRelease(windowList);
            if (numberOfWindowsWithName != 0) {
                return YES;
            }else {
                return NO;
            }
        }
    return YES;
}

+ (void)showScreenRecordingPrompt{
  
  /* macos 10.14 and lower do not require screen recording permission to get window titles */
    if(@available(macos 10.15, *)) {
        CGImageRef c = CGWindowListCreateImage(CGRectMake(0, 0, 1, 1),
                                               kCGWindowListOptionOnScreenOnly,
                                               kCGNullWindowID,
                                               kCGWindowImageDefault);
        CFRelease(c);
    }

}


+ (BOOL)queryUserPlist:(NSString *)queryValue
{
    NSMutableDictionary *setDic = [NSMutableDictionary dictionaryWithDictionary:[PlistUtils loadUserInfoPlistFilewithFileName:SETINFO]];
    if ([setDic[queryValue] boolValue]) {
        return YES;
    }else {
        return NO;
    }
}

+ (NSString *)queryUserInfo:(NSString *)queryValue
{
    NSDictionary *setInfo = [PlistUtils loadUserInfoPlistFilewithFileName:SETINFO];
    if ([setInfo[@"iscloudLogin"]isEqualToString:@"YES"]) {
        NSDictionary *userinfo = [PlistUtils loadUserInfoPlistFilewithFileName:CLOUDUSERINFO];
        return userinfo[queryValue];
    }else {
        NSDictionary *userinfo = [PlistUtils loadUserInfoPlistFilewithFileName:PRIVATEUSERINFO];
        return userinfo[queryValue];
    }
}

+ (void)playSound{
    
    SoundManager* soundManager = [SoundManager sharedManager];
    NSString* ringing = [[NSBundle mainBundle] pathForResource:@"ringtone" ofType:@"wav"];
    [soundManager playSound:ringing looping:YES fadeIn:NO];
}

+ (void)stopSound{
    SoundManager* soundManager = [SoundManager sharedManager];
    NSString* ringing = [[NSBundle mainBundle] pathForResource:@"ringtone" ofType:@"wav"];
    [soundManager stopSound:ringing];
}

+ (NSDictionary*)getObjectData:(id)obj
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);//获得属性列表
    for(int i = 0;i < propsCount; i++)
    {
        objc_property_t prop = props[i];
        
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];//获得属性的名称
        id value = [obj valueForKey:propName];//kvc读值
        if(value == nil)
        {
            value = [NSNull null];
        }
        else
        {
            value = [self getObjectInternal:value];//自定义处理数组，字典，其他类
        }
        [dic setObject:value forKey:propName];
    }
    return dic;
}

+ (id)getObjectInternal:(id)obj
{
    if([obj isKindOfClass:[NSString class]]
       || [obj isKindOfClass:[NSNumber class]]
       || [obj isKindOfClass:[NSNull class]])
    {
        return obj;
    }
    
    if([obj isKindOfClass:[NSArray class]])
    {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++)
        {
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    
    if([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys)
        {
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self getObjectData:obj];
}

+ (NSString *)getDateDisplayString:(long long)miliSeconds
{
    NSTimeInterval tempMilli = miliSeconds;
    NSTimeInterval seconds = tempMilli/1000.0;
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    NSCalendar *calendar = [ NSCalendar currentCalendar ];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear ;
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[ NSDate date ]];
    NSDateComponents *myCmps = [calendar components:unit fromDate:myDate];
    
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc ] init ];
    
    //2. 指定日历对象,要去取日期对象的那些部分.
    NSDateComponents *comp =  [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:myDate];
    
    if (nowCmps.year != myCmps.year) {
        dateFmt.dateFormat = @"yyyy-MM-dd hh:mm";
    } else {
        if (nowCmps.day==myCmps.day) {
            dateFmt.AMSymbol = @"上午";
            dateFmt.PMSymbol = @"下午";
            dateFmt.dateFormat = @"aaa hh:mm";
            
        } else if((nowCmps.day-myCmps.day)==1) {
            dateFmt.AMSymbol = @"上午";
            dateFmt.PMSymbol = @"下午";
            dateFmt.dateFormat = @"昨天 aaahh:mm";

        } else {
            if ((nowCmps.day-myCmps.day) <=7) {
                
                dateFmt.AMSymbol = @"上午";
                dateFmt.PMSymbol = @"下午";
                
                switch (comp.weekday) {
                    case 1:
                        dateFmt.dateFormat = @"星期日 aaahh:mm";
                        break;
                    case 2:
                        dateFmt.dateFormat = @"星期一 aaahh:mm";
                        break;
                    case 3:
                        dateFmt.dateFormat = @"星期二 aaahh:mm";
                        break;
                    case 4:
                        dateFmt.dateFormat = @"星期三 aaahh:mm";
                        break;
                    case 5:
                        dateFmt.dateFormat = @"星期四 aaahh:mm";
                        break;
                    case 6:
                        dateFmt.dateFormat = @"星期五 aaahh:mm";
                        break;
                    case 7:
                        dateFmt.dateFormat = @"星期六 aaahh:mm";
                        break;
                    default:
                        break;
                }
            }else {
                dateFmt.dateFormat = @"MM-dd hh:mm";
            }
        }
    }
    return [dateFmt stringFromDate:myDate];
}

static NSDateFormatter *sUserVisibleDateFormatter = nil;
+ (NSString *)userVisibleDateTimeStringForRFC3339DateTimeString:(NSString *)rfc3339DateTimeString {
    /*
      Returns a user-visible date time string that corresponds to the specified
      RFC 3339 date time string. Note that this does not handle all possible
      RFC 3339 date time strings, just one of the most common styles.
     */

    // If the date formatters aren't already set up, create them and cache them for reuse.
    static NSDateFormatter *sRFC3339DateFormatter = nil;
    if (sRFC3339DateFormatter == nil) {
        sRFC3339DateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [sRFC3339DateFormatter setLocale:enUSPOSIXLocale];
        if (rfc3339DateTimeString.length == 20) {
            //example 2019-12-14T06:37:56Z
            [sRFC3339DateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        }else if (rfc3339DateTimeString.length == 22) {
            [sRFC3339DateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.S'Z'"];
        }else if (rfc3339DateTimeString.length == 23) {
            //example 2019-12-14T07:36:46.61Z yyyy-MM-dd'T'HH:mm:ss.SS'Z'
            [sRFC3339DateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SS'Z'"];
        }else {
            //example 2019-12-14T06:36:42.184Z
            [sRFC3339DateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:sss.SSS'Z'"];
        }
        [sRFC3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }

    // Convert the RFC 3339 date time string to an NSDate.
    NSDate *date = [sRFC3339DateFormatter dateFromString:rfc3339DateTimeString];
    NSString *userVisibleDateTimeString;
    
    if (date != nil) {
        long long timeSp = [date timeIntervalSince1970]*1000;
        userVisibleDateTimeString = [EVUtils getDateDisplayString:timeSp];
    }else {
        userVisibleDateTimeString = @"";
    }
    return userVisibleDateTimeString;
}

+ (BOOL)compareTwoTime:(NSString *)time1 time2:(NSString *)time2
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate *date1 = [formatter dateFromString:time1];
    NSDate *date2 = [formatter dateFromString:time2];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *cmps = [calendar components:type fromDate:date1 toDate:date2 options:0];
    
    if (cmps.year>0 || cmps.month>0 || cmps.day>0 || cmps.hour>0 || cmps.minute >10) {
        return YES;
    }else {
        return NO;
    }
}

+ (void)deleteWebCache {
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];

    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];

    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        DDLogInfo(@"delete all WebCache");
    }];
}


@end
