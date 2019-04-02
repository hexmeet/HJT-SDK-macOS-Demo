//
//  HomeViewController.h
//  easyVideo
//
//  Created by quanhao huang on 2018/8/17.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HomeViewController : NSViewController

/** Left Menu View */
@property (weak) IBOutlet NSView *leftMenuView;
@property (weak) IBOutlet NSButton *userImageBtn;
@property (weak) IBOutlet NSTextField *userName;
@property (weak) IBOutlet NSImageView *registerImage;
@property (weak) IBOutlet NSTextField *registerTitle;
//Meeting View
@property (weak) IBOutlet NSView *meetingView;
@property (weak) IBOutlet NSView *meetingline;
@property (weak) IBOutlet NSImageView *meetingViewImage;
@property (weak) IBOutlet NSTextField *meetingViewTitle;
@property (weak) IBOutlet NSButton *meetingBtn;
//Set View
@property (weak) IBOutlet NSView *setView;
@property (weak) IBOutlet NSView *setline;
@property (weak) IBOutlet NSImageView *setViewImage;
@property (weak) IBOutlet NSTextField *setViewTitle;
@property (weak) IBOutlet NSButton *setBtn;

/** Top Menu View */
@property (weak) IBOutlet NSView *topMenuView;
@property (weak) IBOutlet NSTextField *topMenuViewTitle;

/** Meeting Custom View */
@property (weak) IBOutlet NSView *webContainerView;

/** Setting Custom View */
@property (weak) IBOutlet NSView *setContainerView;

@end
