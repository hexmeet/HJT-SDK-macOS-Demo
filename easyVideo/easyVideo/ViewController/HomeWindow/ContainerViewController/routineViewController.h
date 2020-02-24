//
//  routineViewController.h
//  easyVideo
//
//  Created by quanhao huang on 2018/8/24.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface routineViewController : NSViewController

@property (weak) IBOutlet NSTextField *languageTitle;
@property (weak) IBOutlet NSComboBox *languagecomboBox;
@property (weak) IBOutlet NSTextField *diagnosisTitle;
@property (weak) IBOutlet NSButton *diagnosisBtn;
@property (weak) IBOutlet NSTextField *applicationTitle;
@property (weak) IBOutlet NSButton *autoLoginBtn;
@property (weak) IBOutlet NSButton *autoAnserBtn;
@property (weak) IBOutlet NSButton *highFrameRateBtn;
@property (weak) IBOutlet NSButton *enableHD;
@property (weak) IBOutlet NSButton *closeTipBtn;
@property (weak) IBOutlet NSTextField *hd_prompt;
@property (weak) IBOutlet NSTextField *close_tip_prompt;

@end
