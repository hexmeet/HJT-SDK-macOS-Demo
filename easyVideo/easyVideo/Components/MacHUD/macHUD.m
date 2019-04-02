//
//  macHUD.m
//  easyVideo
//
//  Created by quanhao huang on 2018/8/14.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "macHUD.h"
#import <SDWebImageManager.h>
#import "NSImage+WebCache.h"
@implementation macHUD

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    self.wantsLayer = YES;
    self.layer.backgroundColor = [NSColor clearColor].CGColor;
    
//    double delayInSeconds = 3;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [self removeFromSuperview];
//    });
    
    [self addTrackingRect:[self bounds] owner:self userData:nil assumeInside:NO];

}

+ (macHUD *)creatMacHUD:(NSString *)titleStr icon:(NSString *)imageStr viewController:(NSViewController *)view
{
    if (imageStr.length == 0) {
        imageStr = @"wrong_tip";
    }
    
    NSBundle*            aBundle = [NSBundle mainBundle];
    NSMutableArray*      topLevelObjs = [NSMutableArray array];
    NSDictionary*        nameTable = [NSDictionary dictionaryWithObjectsAndKeys:
                                      self, NSNibOwner,
                                      topLevelObjs, NSNibTopLevelObjects,
                                      nil];
    
    if (![aBundle loadNibFile:@"macHUD" externalNameTable:nameTable withZone:nil])
    {
        HLog(@"Warning! Could not load myNib file.\n");
    }
    
    macHUD *myView = nil;
    
    for (id classtpye in topLevelObjs) {
        if ([classtpye isKindOfClass:self]) {
            myView = classtpye;
        }
    }
    
    myView.frame = view.view.frame;
    myView.hudBgView.wantsLayer = YES;
    myView.hudBgView.layer.backgroundColor = [NSColor blackColor].CGColor;
    myView.hudBgView.layer.cornerRadius = 10;
    myView.hudBgView.alphaValue = 0.6f;
    
    myView.hudTitleFd.stringValue = titleStr;
    
    myView.hudImage.image = [NSImage imageNamed:imageStr];
    
    [view.view addSubview:myView];
    
    return myView;
}

- (void)mouseDown:(NSEvent *)event
{
    
}

- (void)mouseUp:(NSEvent *)event
{
    
}

- (void)keyDown:(NSEvent *)event
{
    
}

@end
