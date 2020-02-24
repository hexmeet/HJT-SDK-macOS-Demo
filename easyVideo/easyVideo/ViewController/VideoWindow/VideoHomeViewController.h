//
//  VideoHomeViewController.h
//  easyVideo
//
//  Created by quanhao huang on 2018/8/30.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SWSTAnswerButton.h"
#import "ChatPageWindowC.h"

@interface VideoHomeViewController : NSViewController

@property (weak) IBOutlet NSImageView *signalImage;
@property (weak) IBOutlet NSTextField *timerLb;
@property (weak) IBOutlet NSTextField *meetingNumber;

@property (weak) IBOutlet NSView *topViewBg;
@property (weak) IBOutlet NSView *buttomViewBg;
@property (weak) IBOutlet NSView *menuViewBg;
@property (weak) IBOutlet NSView *handUpViewBg;
@property (weak) IBOutlet NSView *audioViewBg;
@property (weak) IBOutlet NSButton *handUpBtn;

/** Button */
@property (weak) IBOutlet NSButton *hangUpBtn;
@property (weak) IBOutlet SWSTAnswerButton *muteBtn;
@property (weak) IBOutlet SWSTAnswerButton *cameraBtn;
@property (weak) IBOutlet NSButton *shareBtn;
@property (weak) IBOutlet NSButton *setBtn;
@property (weak) IBOutlet NSButton *meetingBtn;
@property (weak) IBOutlet NSButton *chatBtn;
@property (weak) IBOutlet SWSTAnswerButton *videoLayoutBtn;
@property (weak) IBOutlet NSButton *moreBtn;
@property (weak) IBOutlet NSButton *callendBtn;
@property (weak) IBOutlet NSButton *exitAudioBtn;
@property (weak) IBOutlet NSButton *showLocalBtn;
@property (weak) IBOutlet NSTextField *showLocalTitle;
@property (weak) IBOutlet NSView *showLocalView;

/** Title */
@property (weak) IBOutlet NSTextField *muteTitle;
@property (weak) IBOutlet NSTextField *cameraTitle;
@property (weak) IBOutlet NSTextField *shareTitle;
@property (weak) IBOutlet NSTextField *setTitle;
@property (weak) IBOutlet NSTextField *meetingTitle;
@property (weak) IBOutlet NSTextField *chatTitle;
@property (weak) IBOutlet NSTextField *moreTitle;
@property (weak) IBOutlet NSTextField *videoTitle;
@property (weak) IBOutlet NSTextField *exitAudioTitle;
@property (weak) IBOutlet NSLayoutConstraint *showContentConstraint;
@property (weak) IBOutlet NSButton *showContentVideo;
@property (weak) IBOutlet NSTextField *showContentTitle;
@property (weak) IBOutlet NSView *showContentView;

/** Menu View Bg*/
@property (weak) IBOutlet SWSTAnswerButton *closeLocalBtn;
@property (weak) IBOutlet SWSTAnswerButton *handBtn;
@property (weak) IBOutlet SWSTAnswerButton *switchAudioBtn;
@property (weak) IBOutlet SWSTAnswerButton *changeNameBtn;
@property (weak) IBOutlet NSLayoutConstraint *menuuViewConstraint;

/** Constraint */
@property (weak) IBOutlet NSLayoutConstraint *centerLine;
@property (weak) IBOutlet NSLayoutConstraint *moreBtnLeftConstraint;// 108 40 176
@property (weak) IBOutlet NSLayoutConstraint *audioConstraint;//259 108
@property (weak) IBOutlet NSLayoutConstraint *videoLayoutConstraint;//108 40

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
/** 正在发言*/
@property (weak) IBOutlet NSView *speakerViewBg;
@property (weak) IBOutlet NSTextField *speakerName;
@property (weak) IBOutlet NSTextField *speakerTitle;
@property (weak) IBOutlet NSLayoutConstraint *speakerConstraint;
/** 修改名字*/
@property (weak) IBOutlet NSView *changeNameViewBg;
@property (weak) IBOutlet NSTextField *changeNameTitle;
@property (weak) IBOutlet NSTextField *inputNameTitle;
@property (weak) IBOutlet NSTextField *inputNameField;
@property (weak) IBOutlet NSButton *nameCancelBtn;
@property (weak) IBOutlet NSButton *nameSureBtn;

@property (weak) IBOutlet NSView *zheView;

/**
 聊天界面
 */
@property (nonatomic, strong) ChatPageWindowC *chatPageWindow;
@property (weak) IBOutlet NSLayoutConstraint *alertViewConstraint;

- (void)setTimer;

@end
