//
//  VideoController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/9/11.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "VideoController.h"

@interface VideoController ()

@end

@implementation VideoController

- (id)initWithViewAndType:(enum VideoType)type viewFrame:(NSRect)rect
{
    self = [super initWithNibName:@"VideoController" bundle:nil];
    if (self)
    {
        evVideoType = type;
        [self.view setFrame:rect];
        [self.view setBackgroundColor:BLACKCOLOR];
        
        [self.userBg setBackgroundColor:BLACKCOLOR withAlpha:0.6];
        self.userBg.layer.cornerRadius = 2.f;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)setActiveSpeaker
{
    [_videoView setBackgroundColor:BLACKCOLOR];
    _videoView.layer.borderWidth = 1;
    _videoView.layer.borderColor = HEXCOLOR(0xffae00).CGColor;

}

- (void)setNormolSpeaker
{
    [_videoView setBackgroundColor:BLACKCOLOR];
    _videoView.layer.borderWidth = 1;
    _videoView.layer.borderColor = CLEARCOLOR.CGColor;

}

#pragma mark - ButtonMethod
- (IBAction)hiddenViewAction:(id)sender
{
    if (self.hiddenLocaVideoBlock) {
        self.hiddenLocaVideoBlock();
    }
    [self.view setHidden:YES];
}

@end
