//
//  NSView+backgroundcolor.m
//  easyVideo
//
//  Created by quanhao huang on 2018/8/21.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "NSView+backgroundcolor.h"

@implementation NSView (backgroundcolor)

- (void)setBackgroundColor:(NSColor *)color
{
    self.wantsLayer = YES;
    self.layer.backgroundColor = color.CGColor;
}

- (void)setBackgroundColorR:(float)red G:(float)green B:(float)blue withAlpha:(float)alpha
{
    self.wantsLayer = YES;
    self.layer.backgroundColor = [NSColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha].CGColor;
}

- (void)setBackgroundColor:(NSColor *)color withAlpha:(float)alpha
{
    self.wantsLayer = YES;
    self.layer.backgroundColor = [color colorWithAlphaComponent:alpha].CGColor;
}

@end
