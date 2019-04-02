//
//  NSButton+backgroundcolor.h
//  easyVideo
//
//  Created by quanhao huang on 2018/8/22.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSButton (backgroundcolor)

//Aligned on the left
- (void)changeLeftButtonattribute:(NSString *)text color:(NSColor *)color;
//Align center
- (void)changeCenterButtonattribute:(NSString *)text color:(NSColor *)color;
//Aligned on the Right
- (void)changeRightButtonattribute:(NSString *)text color:(NSColor *)color;

@end
