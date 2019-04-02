//
//  ConnectingWindow.m
//  easyVideo
//
//  Created by quanhao huang on 2018/9/17.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "ConnectingWindow.h"

@implementation ConnectingWindow

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
        
        [self setMovableByWindowBackground:NO];
        
        if (@available(macOS 10.14, *)) {
            self.appearance  = [NSAppearance appearanceNamed:NSAppearanceNameVibrantLight];
        } else {
            // Fallback on earlier versions
        }
        
//        [self setLevel:NSMainMenuWindowLevel];
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

- (BOOL)windowShouldClose:(NSWindow *)sender
{
    [self orderOut:nil];
    return YES;
}

@end
