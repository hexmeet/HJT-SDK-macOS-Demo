//
//  SignalWindowController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/9/10.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "SignalWindowController.h"

static NSString *const kStoryboardName  = @"Video";
static NSString *const SignalWindowControllerIdentifier = @"SignalWindowController";
@interface SignalWindowController ()

@end

@implementation SignalWindowController

+ (instancetype)windowController{
    
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:kStoryboardName
                                                         bundle:[NSBundle mainBundle]];
    
    SignalWindowController *cc = [storyboard instantiateControllerWithIdentifier:SignalWindowControllerIdentifier];
    [cc.window setAnimationBehavior:NSWindowAnimationBehaviorDocumentWindow];
    [cc.window makeFirstResponder:nil];
    
    return cc;
}


- (void)windowDidLoad {
    [super windowDidLoad];
    
    [self.window center];
}

@end
