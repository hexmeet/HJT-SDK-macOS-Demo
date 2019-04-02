//
//  LanguageTool.m
//  easyVideo
//
//  Created by quanhao huang on 2018/8/13.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "LanguageTool.h"
#import "AppDelegate.h"

#define CNS @"zh-Hans"
#define EN @"en"
#define LocalLanguageKey @"langeuageset"

@implementation LanguageTool

static NSBundle *bundle = nil;
+ (NSBundle *)bundle{
    return bundle;
}

+ (void)initUserLanguage
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *currLanguage = [def valueForKey:LocalLanguageKey];
    
    if(!currLanguage){
        NSArray *preferredLanguages = [NSLocale preferredLanguages];
        currLanguage = preferredLanguages[0];
        if ([currLanguage hasPrefix:@"en"]) {
            currLanguage = EN;
        }else if ([currLanguage hasPrefix:@"zh"]) {
            currLanguage = CNS;
        }else currLanguage = EN;
        [def setValue:currLanguage forKey:LocalLanguageKey];
        [def synchronize];
    }

    NSString *path = [[NSBundle mainBundle] pathForResource:currLanguage ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];
}

+ (NSString *)userLanguage
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *language = [def valueForKey:LocalLanguageKey];
    
    return language;
}

+ (void)setUserlanguage:(NSString *)language
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *currLanguage = [userDefaults valueForKey:LocalLanguageKey];
    if ([currLanguage isEqualToString:language]) {
        return;
    }
    
    [userDefaults setValue:language forKey:LocalLanguageKey];
    [userDefaults synchronize];

    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj" ];
    bundle = [NSBundle bundleWithPath:path];
}

@end
