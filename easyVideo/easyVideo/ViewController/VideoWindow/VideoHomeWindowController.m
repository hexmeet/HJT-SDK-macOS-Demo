//
//  VideoHomeWindowController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/8/30.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "VideoHomeWindowController.h"

static NSString *const kStoryboardName  = @"Video";
static NSString *const VideoHomeWindowControllerIdentifier = @"VideoHomeWindowController";
@interface VideoHomeWindowController ()

@end

@implementation VideoHomeWindowController

+ (instancetype)windowController{
    
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:kStoryboardName
                                                         bundle:[NSBundle mainBundle]];
    
    VideoHomeWindowController *cc = [storyboard instantiateControllerWithIdentifier:VideoHomeWindowControllerIdentifier];
    [cc.window setAnimationBehavior:NSWindowAnimationBehaviorDocumentWindow];
    [cc.window makeFirstResponder:nil];
    
    return cc;
}


- (void)windowDidLoad {
    [super windowDidLoad];
    
    [self.window center];
}

@end
