//
//  P2pConnectingWindowController.m
//  easyVideo
//
//  Created by quanhao huang on 2019/11/13.
//  Copyright © 2019 easyVideo. All rights reserved.
//

#import "P2pConnectingWindowController.h"

static NSString *const kStoryboardName  = @"P2p";
static NSString *const P2pConnectingWindowControllerIdentifier = @"P2pConnectingWindowController";
@interface P2pConnectingWindowController ()

@end

@implementation P2pConnectingWindowController

+ (instancetype)windowController{
    
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:kStoryboardName
                                                         bundle:[NSBundle mainBundle]];
    
    P2pConnectingWindowController *cc = [storyboard instantiateControllerWithIdentifier:P2pConnectingWindowControllerIdentifier];
    [cc.window setAnimationBehavior:NSWindowAnimationBehaviorDocumentWindow];
    [cc.window makeFirstResponder:nil];
    
    return cc;
}


- (void)windowDidLoad {
    [super windowDidLoad];
    
    [self.window center];
}

@end
