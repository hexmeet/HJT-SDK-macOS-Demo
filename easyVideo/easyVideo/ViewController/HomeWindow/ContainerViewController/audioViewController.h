//
//  audioViewController.h
//  easyVideo
//
//  Created by quanhao huang on 2018/8/24.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface audioViewController : NSViewController

@property (weak) IBOutlet NSTextField *microphoneTitle;
@property (weak) IBOutlet NSComboBox *microphoneboBox;
@property (weak) IBOutlet NSTextField *speakerTitle;
@property (weak) IBOutlet NSComboBox *speakerboBox;
@property (weak) IBOutlet NSTextField *playTitle;
@property (weak) IBOutlet NSImageView *audioImageBg;
@property (weak) IBOutlet NSButton *playBtn;

@end
