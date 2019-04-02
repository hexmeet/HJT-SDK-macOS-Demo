//
//  ConnectingWindowController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/9/17.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "ConnectingWindowController.h"

static NSString *const kStoryboardName  = @"Video";
static NSString *const ConnectingWindowControllerIdentifier = @"ConnectingWindowController";
@interface ConnectingWindowController ()

@end

@implementation ConnectingWindowController

+ (instancetype)windowController{
    
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:kStoryboardName
                                                         bundle:[NSBundle mainBundle]];
    
    ConnectingWindowController *cc = [storyboard instantiateControllerWithIdentifier:ConnectingWindowControllerIdentifier];
    [cc.window setAnimationBehavior:NSWindowAnimationBehaviorDocumentWindow];
    [cc.window makeFirstResponder:nil];
    
    return cc;
}


- (void)windowDidLoad {
    [super windowDidLoad];
    
    [self.window center];
}

@end
