//
//  LoginRootViewController.h
//  easyVideo
//
//  Created by quanhao huang on 2018/8/10.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LoginRootViewController : NSViewController

@property (weak) IBOutlet NSView *homeView;
/** loginView */
@property (weak) IBOutlet NSButton *enterpriseBtn;
@property (weak) IBOutlet NSButton *cloudBtn;
@property (weak) IBOutlet NSTextField *privateDeploymentTitle;
@property (weak) IBOutlet NSTextField *cloudTitle;
@property (weak) IBOutlet NSImageView *loginImageTitle;
@property (weak) IBOutlet NSImageView *enterpriseBg;
@property (weak) IBOutlet NSImageView *cloudBg;

/** Enterprise Login View */
@property (weak) IBOutlet NSView *enterpriseLoginView;
@property (weak) IBOutlet NSLayoutConstraint *enterpriseLoginConstraint;
@property (weak) IBOutlet NSButton *enterpriseLoginbackButton;
@property (weak) IBOutlet NSView *joinView;
@property (weak) IBOutlet NSView *loginView;
@property (weak) IBOutlet NSButton *joinMeetingBtn;
@property (weak) IBOutlet NSButton *loginBtn;
@property (weak) IBOutlet NSTextField *loginViewTitle;
@property (weak) IBOutlet NSImageView *enterpriseImageTitle;
@property (weak) IBOutlet NSButton *applyBtn;

/** User Login View */
@property (weak) IBOutlet NSTextField *userLoginViewTitle;
@property (weak) IBOutlet NSView *userLoginView;
@property (weak) IBOutlet NSLayoutConstraint *userTextFdConstraint;
@property (weak) IBOutlet NSLayoutConstraint *userLoginViewConstraint;
@property (weak) IBOutlet NSButton *userLoginBackBtn;
@property (weak) IBOutlet NSTextField *serverTextFd;
@property (weak) IBOutlet NSTextField *userTextFd;
@property (weak) IBOutlet NSTextField *passwordTextFd;
@property (weak) IBOutlet NSButton *userLoginViewLoginBtn;
@property (weak) IBOutlet NSView *userLoginViewBg;
@property (weak) IBOutlet NSButton *advancedsetBtn;

/** Advanced Settings View */
@property (weak) IBOutlet NSView *AdvancedSetView;
@property (weak) IBOutlet NSLayoutConstraint *AdvancedsetViewConstraint;
@property (weak) IBOutlet NSButton *advancedBackBtn;
@property (weak) IBOutlet NSTextField *advanceTitleFd;
@property (weak) IBOutlet NSTextField *portTextFd;
@property (weak) IBOutlet NSButton *httpBtn;
@property (weak) IBOutlet NSView *advancedsureView;
@property (weak) IBOutlet NSView *advancedcancelView;
@property (weak) IBOutlet NSButton *advancedsureBtn;
@property (weak) IBOutlet NSButton *advancedcancelBtn;

/** Join Meeting View */
@property (weak) IBOutlet NSView *joinMeetingView;
@property (weak) IBOutlet NSLayoutConstraint *joinMeetingchangeConstraint;
@property (weak) IBOutlet NSLayoutConstraint *joinMeetingViewConstraint;
@property (weak) IBOutlet NSButton *joinadvancedsetBtn;
@property (weak) IBOutlet NSTextField *joinMeetingTitleFd;
@property (weak) IBOutlet NSTextField *joinMeetingserverFd;
@property (weak) IBOutlet NSTextField *joinMeetingConfIdFd;
@property (weak) IBOutlet NSTextField *joinMeetingDisNameFd;
@property (weak) IBOutlet NSView *joinMeetingBg;
@property (weak) IBOutlet NSButton *joinMeetingBackBtn;
@property (weak) IBOutlet NSButton *anonymousjoinMeetingBtn;
@property (weak) IBOutlet NSButton *videoBtn;
@property (weak) IBOutlet NSButton *muteBtn;
@property (weak) IBOutlet NSButton *settingBtn;

@end
