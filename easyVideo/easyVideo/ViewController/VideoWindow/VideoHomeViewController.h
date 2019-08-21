//
//  VideoHomeViewController.h
//  easyVideo
//
//  Created by quanhao huang on 2018/8/30.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SWSTAnswerButton.h"

@interface VideoHomeViewController : NSViewController

@property (weak) IBOutlet NSImageView *signalImage;
@property (weak) IBOutlet NSTextField *timerLb;
@property (weak) IBOutlet NSTextField *meetingNumber;

@property (weak) IBOutlet NSView *topViewBg;
@property (weak) IBOutlet NSView *buttomViewBg;
@property (weak) IBOutlet NSView *localViewBg;
@property (weak) IBOutlet NSView *handUpViewBg;
@property (weak) IBOutlet NSButton *localBtn;
@property (weak) IBOutlet NSButton *handUpBtn;

/** button */
@property (weak) IBOutlet SWSTAnswerButton *muteBtn;
@property (weak) IBOutlet SWSTAnswerButton *cameraBtn;
@property (weak) IBOutlet NSButton *setBtn;
@property (weak) IBOutlet NSButton *meetingBtn;
@property (weak) IBOutlet SWSTAnswerButton *videoLayoutBtn;
@property (weak) IBOutlet NSButton *handBtn;
@property (weak) IBOutlet NSButton *callendBtn;
@property (weak) IBOutlet NSButton *locolShowHiddenBtn;
@property (weak) IBOutlet NSButton *shareBtn;

/** title */
@property (weak) IBOutlet NSTextField *muteTitle;
@property (weak) IBOutlet NSTextField *cameraTitle;
@property (weak) IBOutlet NSTextField *setTitle;
@property (weak) IBOutlet NSTextField *meetingTitle;
@property (weak) IBOutlet NSTextField *videoTitle;
@property (weak) IBOutlet NSTextField *handupTitle;
@property (weak) IBOutlet NSTextField *shareTitle;
@property (weak) IBOutlet NSButton *showContentVideo;
@property (weak) IBOutlet NSTextField *showContentTitle;
@property (weak) IBOutlet NSLayoutConstraint *centerLine;
@property (weak) IBOutlet NSLayoutConstraint *showContentleft;
@property (weak) IBOutlet NSButton *alertBtn;
/** 录制 */
@property (weak) IBOutlet NSTextField *recTitle;
@property (weak) IBOutlet NSView *recordBg;
@property (weak) IBOutlet NSView *redBg;
/** 取消选定视频 */
@property (weak) IBOutlet NSButton *cancelVideo;
@property (weak) IBOutlet NSLayoutConstraint *cancelVideoConstraint;
@property (weak) IBOutlet NSTextField *numberTitle;
@property (weak) IBOutlet NSView *hud;
@property (weak) IBOutlet NSTextField *hudTitle;

- (void)setTimer;

@end
