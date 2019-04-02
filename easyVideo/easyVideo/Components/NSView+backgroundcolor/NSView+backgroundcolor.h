//
//  NSView+backgroundcolor.h
//  easyVideo
//
//  Created by quanhao huang on 2018/8/21.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSView (backgroundcolor)

- (void)setBackgroundColor:(NSColor *)color;
- (void)setBackgroundColorR:(float)red G:(float)green B:(float)blue withAlpha:(float)alpha;
- (void)setBackgroundColor:(NSColor *)color withAlpha:(float)alpha;

@end
