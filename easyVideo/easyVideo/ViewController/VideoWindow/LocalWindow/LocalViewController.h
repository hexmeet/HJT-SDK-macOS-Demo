//
//  LocalViewController.h
//  easyVideo
//
//  Created by quanhao huang on 2018/9/17.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SWSTAnswerButton.h"

@interface LocalViewController : NSViewController

@property (weak) IBOutlet NSView *topBg;
@property (weak) IBOutlet NSView *buttomBg;
@property (weak) IBOutlet NSView *topView;
@property (weak) IBOutlet NSLayoutConstraint *topHConstraint;
@property (weak) IBOutlet SWSTAnswerButton *upBtn;
@property (weak) IBOutlet SWSTAnswerButton *downBtn;
@property (weak) IBOutlet NSLayoutConstraint *buttomConstraint;

@end
