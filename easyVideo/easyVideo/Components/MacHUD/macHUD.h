//
//  macHUD.h
//  easyVideo
//
//  Created by quanhao huang on 2018/8/14.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface macHUD : NSView

@property (weak) IBOutlet NSView *hudBgView;
@property (weak) IBOutlet NSImageView *hudImage;
@property (weak) IBOutlet NSTextField *hudTitleFd;

/**
 creat Mac HUD
 
 @param titleStr The title content
 @param imageStr The image name
 @param view Current view controller
 */
+ (macHUD *)creatMacHUD:(NSString *)titleStr icon:(NSString *)imageStr viewController:(NSViewController *)view;

@end
