//
//  InvitationWindowController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/9/21.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "InvitationWindowController.h"

static NSString *const kStoryboardName  = @"Main";
static NSString *const InvitationWindowControllerIdentifier = @"InvitationWindowController";
@interface InvitationWindowController ()

@end

@implementation InvitationWindowController

+ (instancetype)windowController{
    
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:kStoryboardName
                                                         bundle:[NSBundle mainBundle]];
    
    InvitationWindowController *cc = [storyboard instantiateControllerWithIdentifier:InvitationWindowControllerIdentifier];
    [cc.window setAnimationBehavior:NSWindowAnimationBehaviorDocumentWindow];
    [cc.window makeFirstResponder:nil];
    
    return cc;
}


- (void)windowDidLoad {
    [super windowDidLoad];
    
    [self.window center];
}

@end
