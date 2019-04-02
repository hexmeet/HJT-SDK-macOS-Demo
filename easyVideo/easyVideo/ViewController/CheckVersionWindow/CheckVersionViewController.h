//
//  CheckVersionViewController.h
//  easyVideo
//
//  Created by quanhao huang on 2018/11/14.
//  Copyright © 2018 easyVideo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface CheckVersionViewController : NSViewController
/** top */
@property (weak) IBOutlet NSView *topView;
@property (weak) IBOutlet NSTextField *topTitle;

/** middle */
@property (weak) IBOutlet NSImageView *appIcon;
@property (weak) IBOutlet NSTextField *versionTitle;
@property (weak) IBOutlet NSTextField *downloadTitle;
@property (weak) IBOutlet NSProgressIndicator *progressIndicatorBg;
@property (weak) IBOutlet NSTextField *downloadProgressFd;

/** bottom */
@property (weak) IBOutlet NSButton *leftBtn;
@property (weak) IBOutlet NSButton *rightBtn;
@property (weak) IBOutlet NSView *bottomView;

@end

NS_ASSUME_NONNULL_END
