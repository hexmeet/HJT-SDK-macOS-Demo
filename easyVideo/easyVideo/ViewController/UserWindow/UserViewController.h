//
//  UserViewController.h
//  easyVideo
//
//  Created by quanhao huang on 2018/8/21.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef void (^CloseUserWindowBlock)(BOOL isclose);
@interface UserViewController : NSViewController

/** topView */
@property (weak) IBOutlet NSView *topCustomViewBg;
@property (weak) IBOutlet NSImageView *userHeadImage;
@property (weak) IBOutlet NSView *userHeadBg;
@property (weak) IBOutlet NSButton *userHeadImageBtn;
@property (weak) IBOutlet NSTextField *userNameTitle;
@property (weak) IBOutlet NSButton *editUserNameBtn;
@property (weak) IBOutlet NSLayoutConstraint *editConstraint;

/** middleView */
@property (weak) IBOutlet NSView *middleCustomViewBg;
@property (weak) IBOutlet NSTextField *phoneTitle;
@property (weak) IBOutlet NSTextField *landlineTitle;
@property (weak) IBOutlet NSTextField *emailTitle;
@property (weak) IBOutlet NSTextField *departmentTitle;
@property (weak) IBOutlet NSTextField *companyTitle;
@property (weak) IBOutlet NSTextField *phoneTF;
@property (weak) IBOutlet NSTextField *landlineTF;
@property (weak) IBOutlet NSTextField *emailTF;
@property (weak) IBOutlet NSTextField *departmentTF;
@property (weak) IBOutlet NSTextField *companyTF;

/** bottomView */
@property (weak) IBOutlet NSView *bottomPBg;
@property (weak) IBOutlet NSView *bottomLBg;
@property (weak) IBOutlet NSButton *changePasswordBtn;
@property (weak) IBOutlet NSButton *loginOutBtn;

@end
