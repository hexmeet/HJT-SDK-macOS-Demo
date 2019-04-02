//
//  JoinMeetingViewController.h
//  easyVideo
//
//  Created by quanhao huang on 2018/8/24.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface JoinMeetingViewController : NSViewController

@property (weak) IBOutlet NSTextField *joinMeetingTitle;
@property (weak) IBOutlet NSTextField *accoutTF;
@property (weak) IBOutlet NSTextField *passwordTF;
@property (weak) IBOutlet NSView *loginViewBg;
@property (weak) IBOutlet NSButton *loginBtn;
@property (weak) IBOutlet NSButton *videoBtn;
@property (weak) IBOutlet NSButton *muteBtn;

@property (weak) IBOutlet NSTableView *tab;
@property (weak) IBOutlet NSScrollView *tabBg;


@end
