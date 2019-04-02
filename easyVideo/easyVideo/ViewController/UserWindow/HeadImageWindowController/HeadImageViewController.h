//
//  HeadImageViewController.h
//  easyVideo
//
//  Created by quanhao huang on 2018/8/29.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HeadImageViewController : NSViewController

@property (weak) IBOutlet NSView *topViewBg;
@property (weak) IBOutlet NSTextField *editHeadTitle;
@property (weak) IBOutlet NSImageView *headImageView;
@property (weak) IBOutlet NSView *imageBg;
@property (weak) IBOutlet NSTextField *imagePromptTitle;
@property (weak) IBOutlet NSView *openBg;
@property (weak) IBOutlet NSButton *openBtn;
@property (weak) IBOutlet NSView *updataBg;
@property (weak) IBOutlet NSButton *updataBtn;

@property (weak) IBOutlet NSButton *smallerBtn;
@property (weak) IBOutlet NSButton *biggerBtn;
@property (weak) IBOutlet NSView *sliderBg;
@property (weak) IBOutlet NSLayoutConstraint *sliderConstraint;
@property (nonatomic, assign) NSInteger sliderValue;
@property (weak) IBOutlet NSImageView *slidervalueBg;

@end
