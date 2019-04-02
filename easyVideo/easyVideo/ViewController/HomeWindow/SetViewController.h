//
//  SetViewController.h
//  easyVideo
//
//  Created by quanhao huang on 2018/8/24.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SetViewController : NSViewController

@property (weak) IBOutlet NSView *leftViewBg;
@property (weak) IBOutlet NSView *conventionalViewBg;
@property (weak) IBOutlet NSTextField *conventionalTitle;
@property (weak) IBOutlet NSButton *conventionalBtn;
@property (weak) IBOutlet NSView *audioViewBg;
@property (weak) IBOutlet NSTextField *audioTitle;
@property (weak) IBOutlet NSButton *audioBtn;
@property (weak) IBOutlet NSView *videoViewBg;
@property (weak) IBOutlet NSTextField *videoTitle;
@property (weak) IBOutlet NSButton *videoBtn;
@property (weak) IBOutlet NSView *aboutViewBg;
@property (weak) IBOutlet NSTextField *aboutTitle;
@property (weak) IBOutlet NSButton *aboutBtn;

@property (weak) IBOutlet NSView *conventionView;
@property (weak) IBOutlet NSView *audioView;
@property (weak) IBOutlet NSView *videoView;
@property (weak) IBOutlet NSView *aboutView;

@end
