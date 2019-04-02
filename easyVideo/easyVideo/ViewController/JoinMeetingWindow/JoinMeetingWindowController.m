//
//  JoinMeetingWindowController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/8/24.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "JoinMeetingWindowController.h"

static NSString *const kStoryboardName  = @"Main";
static NSString *const JoinMeetingWindowControllerIdentifier = @"JoinMeetingWindowController";
@interface JoinMeetingWindowController ()

@end

@implementation JoinMeetingWindowController

+ (instancetype)windowController{
    
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:kStoryboardName
                                                         bundle:[NSBundle mainBundle]];
    
    JoinMeetingWindowController *cc = [storyboard instantiateControllerWithIdentifier:JoinMeetingWindowControllerIdentifier];
    [cc.window setAnimationBehavior:NSWindowAnimationBehaviorDocumentWindow];
    [cc.window makeFirstResponder:nil];
    
    return cc;
}


- (void)windowDidLoad {
    [super windowDidLoad];
    
    [self.window center];
}

@end
