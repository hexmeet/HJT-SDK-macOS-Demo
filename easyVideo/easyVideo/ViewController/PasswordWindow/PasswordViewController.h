//
//  PasswordViewController.h
//  easyVideo
//
//  Created by quanhao huang on 2018/9/21.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface PasswordViewController : NSViewController

@property (weak) IBOutlet NSTextField *passwordTitle;
@property (weak) IBOutlet NSTextField *passwordTF;
@property (weak) IBOutlet NSView *joinBg;
@property (weak) IBOutlet NSButton *joinBtn;

@end

NS_ASSUME_NONNULL_END
