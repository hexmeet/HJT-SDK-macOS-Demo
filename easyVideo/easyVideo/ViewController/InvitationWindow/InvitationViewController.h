//
//  InvitationViewController.h
//  easyVideo
//
//  Created by quanhao huang on 2018/9/21.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface InvitationViewController : NSViewController

@property (weak) IBOutlet NSTextField *meetingName;
@property (weak) IBOutlet NSView *joinBg;
@property (weak) IBOutlet NSView *cancelBg;
@property (weak) IBOutlet NSButton *joinBtn;
@property (weak) IBOutlet NSButton *cancelBtn;

@end

NS_ASSUME_NONNULL_END
