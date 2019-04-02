//
//  VideoController.h
//  easyVideo
//
//  Created by quanhao huang on 2018/9/11.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EVVideoInfo.h"

typedef void (^HiddenLocaVideo)(void);
@interface VideoController : NSViewController
{
    enum VideoType    evVideoType;
    CGFloat           videoWidth;
    CGFloat           videoHeight;
}

@property (weak) IBOutlet NSView *videoView;
@property (nonatomic, copy) HiddenLocaVideo hiddenLocaVideoBlock;
@property (weak) IBOutlet NSImageView *muteBg;
@property (weak) IBOutlet NSTextField *userName;
@property (weak) IBOutlet NSView *userBg;

@property (weak) IBOutlet NSLayoutConstraint *nameConstraint;
@property (weak) IBOutlet NSLayoutConstraint *nameConstraintH;

- (id)initWithViewAndType:(enum VideoType)type viewFrame:(NSRect)rect;
- (void)setActiveSpeaker;
- (void)setNormolSpeaker;

@end
