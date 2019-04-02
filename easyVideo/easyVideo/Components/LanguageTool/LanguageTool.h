//
//  LanguageTool.h
//  easyVideo
//
//  Created by quanhao huang on 2018/8/13.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LanguageTool : NSObject

+ (NSBundle *)bundle;//Get the current resource file

+ (void)initUserLanguage;//Initialize the language file

+ (NSString *)userLanguage;//Gets the application's current language

+ (void)setUserlanguage:(NSString *)language;//Set current language

@end
