//
//  InvitationViewController.h
//  easyVideo
//
//  Created by quanhao huang on 2018/9/21.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RippleAnimationView.h"

NS_ASSUME_NONNULL_BEGIN

@interface InvitationViewController : NSViewController

@property (weak) IBOutlet NSImageView *inviteBg;
@property (weak) IBOutlet NSImageView *callImg;
@property (weak) IBOutlet NSTextField *inviteName;
@property (weak) IBOutlet NSTextField *inviteTitle;
@property (weak) IBOutlet NSButton *cancelBtn;
@property (weak) IBOutlet NSTextField *cancelTitle;
@property (weak) IBOutlet NSButton *joinBtn;
@property (weak) IBOutlet NSTextField *joinVideoTitle;

@end

NS_ASSUME_NONNULL_END
