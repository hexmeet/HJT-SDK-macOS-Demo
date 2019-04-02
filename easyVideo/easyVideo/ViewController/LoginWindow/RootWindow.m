//
//  RootWindow.m
//  easyVideo
//
//  Created by quanhao huang on 2018/8/21.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "RootWindow.h"

@implementation RootWindow

- (instancetype)initWithContentRect:(NSRect)contentRect
                          styleMask:(NSWindowStyleMask)aStyle
                            backing:(NSBackingStoreType)bufferingType
                              defer:(BOOL)flag{
    self = [super initWithContentRect:contentRect
                            styleMask:aStyle
                              backing:bufferingType
                                defer:flag];
    if (self) {
        
        [self setHasShadow:YES];
        
        [self setOpaque:NO];
  
        [self setBackgroundColor:[NSColor clearColor]];

        [self setMovableByWindowBackground:YES];
        
        if (@available(macOS 10.14, *)) {
            self.appearance  = [NSAppearance appearanceNamed:NSAppearanceNameVibrantLight];
        } else {
            // Fallback on earlier versions
        }
        
        [self invalidateShadow];
    }
    return self;
}

- (void)setContentView:(__kindof NSView *)contentView{

    contentView.wantsLayer            = YES;
    contentView.layer.frame           = contentView.frame;
    contentView.layer.cornerRadius    = 5.0;
    contentView.layer.masksToBounds   = YES;
    
    [super setContentView:contentView];
}

- (BOOL)canBecomeKeyWindow{
    return YES;
}
- (BOOL)canBecomeMainWindow{
    return YES;
}

@end
