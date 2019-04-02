//
//  ChangePasswordViewController.h
//  easyVideo
//
//  Created by quanhao huang on 2018/8/23.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ChangePasswordViewController : NSViewController

@property (weak) IBOutlet NSView *topViewBg;
@property (weak) IBOutlet NSTextField *topTitle;
@property (weak) IBOutlet NSTextField *oldpdTitle;
@property (weak) IBOutlet NSSecureTextField *oldpdTF;
@property (weak) IBOutlet NSTextField *alertTitle;
@property (weak) IBOutlet NSTextField *newpdTitle;
@property (weak) IBOutlet NSSecureTextField *newpdTF;
@property (weak) IBOutlet NSTextField *surepdTitle;
@property (weak) IBOutlet NSSecureTextField *surepdTF;
@property (weak) IBOutlet NSView *bottomViewBg;
@property (weak) IBOutlet NSView *cancelViewBg;
@property (weak) IBOutlet NSView *sureViewBg;
@property (weak) IBOutlet NSButton *cancelBtn;
@property (weak) IBOutlet NSButton *sureBtn;

@end
