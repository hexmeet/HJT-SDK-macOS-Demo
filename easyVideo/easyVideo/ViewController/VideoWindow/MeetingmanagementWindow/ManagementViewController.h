//
//  ManagementViewController.h
//  easyVideo
//
//  Created by quanhao huang on 2018/8/31.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ManagementViewController : NSViewController

@property (weak) IBOutlet NSSegmentedControl *segment;
@property (weak) IBOutlet NSTextField *setTitle;
@property (weak) IBOutlet NSView *speakerView;
@property (weak) IBOutlet NSView *micphoneView;
@property (weak) IBOutlet NSView *cameraView;

@end
