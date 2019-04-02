//
//  NSColor+SWExtension.h
//  easyVideo
//
//  Created by quanhao huang on 2018/8/30.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSColor (hex)

+ (NSColor*)colorWithRGB:(uint32_t)rgbValue;
+ (NSColor*)colorWithRGB:(uint32_t)rgbValue alpha:(CGFloat)alpha;
+ (NSColor *)colorWithRGBA:(uint32_t)rgbaValue;

@end
