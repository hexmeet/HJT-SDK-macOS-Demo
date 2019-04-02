//
//  MeetingWebWindowController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/9/19.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "MeetingWebWindowController.h"

static NSString *const kStoryboardName  = @"Video";
static NSString *const MeetingWebWindowControllerIdentifier = @"MeetingWebWindowController";
@interface MeetingWebWindowController ()

@end

@implementation MeetingWebWindowController

+ (instancetype)windowController{
    
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:kStoryboardName
                                                         bundle:[NSBundle mainBundle]];
    
    MeetingWebWindowController *cc = [storyboard instantiateControllerWithIdentifier:MeetingWebWindowControllerIdentifier];
    [cc.window setAnimationBehavior:NSWindowAnimationBehaviorDocumentWindow];
    [cc.window makeFirstResponder:nil];
    
    return cc;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    [self.window center];
}

@end
