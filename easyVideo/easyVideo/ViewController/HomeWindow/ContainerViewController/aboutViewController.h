//
//  aboutViewController.h
//  easyVideo
//
//  Created by quanhao huang on 2018/8/24.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface aboutViewController : NSViewController

@property (weak) IBOutlet NSImageView *aboutImageBg;
@property (weak) IBOutlet NSTextField *appName;
@property (weak) IBOutlet NSTextField *cRightTtitle;
@property (weak) IBOutlet NSTextField *version;
@property (weak) IBOutlet NSButton *checkBtn;

@end
