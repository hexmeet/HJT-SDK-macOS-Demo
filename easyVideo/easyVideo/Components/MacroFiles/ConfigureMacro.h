//
//  configureMacro.h
//  easyVideo
//
//  Created by quanhao huang on 2018/8/21.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#ifndef configureMacro_h
#define configureMacro_h

//Hexadecimal color
#define HEXCOLOR(c) [NSColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:1.0]
//Set language text
#define localizationBundle(s) [[LanguageTool bundle] localizedStringForKey:s value:nil table:@"localization"]
#define infoPlistStringBundle(s) [[LanguageTool bundle] localizedStringForKey:s value:nil table:@"InfoPlist"]
//Screen height width
#define SCREENHEIGHT [NSScreen mainScreen].frame.size.height
#define SCREENWIDTH [NSScreen mainScreen].frame.size.width
//Notification
#define Notifications(s) [[NSNotificationCenter defaultCenter]postNotificationName:s object:nil]//AppDelegate
#define APPDELEGATE (AppDelegate *)[NSApplication sharedApplication].delegate
//LOG
#define HLog(...) \
NSLog(@"%@第%d行:%@\n---------------------------",[[NSString stringWithFormat:@"%s",__FILE__] componentsSeparatedByString:@"/"][[[NSString stringWithFormat:@"%s",__FILE__] componentsSeparatedByString:@"/"].count-1], __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
//NSUserDefaults
#define NSUSERDEFAULT [NSUserDefaults standardUserDefaults]
//AK SK
#define APPAK @"FAKEKEYoTDUxeJqMI7x"
#define APPSK @"FAKESECRETX2fUAZ30zVcG1y3ruLUWn8Uwt2"

#endif /* configureMacro_h */
