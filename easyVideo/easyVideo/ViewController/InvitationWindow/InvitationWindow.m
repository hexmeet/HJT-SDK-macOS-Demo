//
//  InvitationWindow.m
//  
//
//  Created by quanhao huang on 2018/9/21.
//

#import "InvitationWindow.h"

@implementation InvitationWindow

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
    }
    return self;
}

- (void)setContentView:(__kindof NSView *)contentView{
    
    contentView.wantsLayer            = YES;
    contentView.layer.frame           = contentView.frame;
    contentView.layer.cornerRadius    = 4.0;
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
