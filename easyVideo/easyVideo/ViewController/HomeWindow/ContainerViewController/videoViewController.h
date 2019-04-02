//
//  videoViewController.h
//  easyVideo
//
//  Created by quanhao huang on 2018/8/24.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface videoViewController : NSViewController

@property (weak) IBOutlet NSTextField *cameraTitle;
@property (weak) IBOutlet NSComboBox *cameraboBox;
@property (weak) IBOutlet NSView *videoBg;

@end
