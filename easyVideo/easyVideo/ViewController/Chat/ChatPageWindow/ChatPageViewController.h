//
//  ChatPageViewController.h
//  easyVideo
//
//  Created by quanhao huang on 2019/12/18.
//  Copyright © 2019 easyVideo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MessageLeftCell.h"
#import "MessageRightCell.h"
#import "MessageModel.h"
#import "EmojiPopover.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatPageViewController : NSViewController

//TopView
@property (weak) IBOutlet NSView *topView;
@property (weak) IBOutlet NSButton *hiddenBtn;

//MainTab
@property (weak) IBOutlet NSTableView *mainTab;

//BottomView
@property (weak) IBOutlet NSView *bottomView;
@property (weak) IBOutlet NSButton *emojiBtn;
@property (unsafe_unretained) IBOutlet NSTextView *inputView;

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *groupStr;

@end

NS_ASSUME_NONNULL_END
