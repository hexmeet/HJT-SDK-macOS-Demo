//
//  ChangePasswordWindowController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/8/23.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "ChangePasswordWindowController.h"

static NSString *const kStoryboardName  = @"Main";
static NSString *const ChangePasswordWindowControllerIdentifier = @"ChangePasswordWindowController";
@interface ChangePasswordWindowController ()

@end

@implementation ChangePasswordWindowController

+ (instancetype)windowController{
    
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:kStoryboardName
                                                         bundle:[NSBundle mainBundle]];
    
    ChangePasswordWindowController *cc = [storyboard instantiateControllerWithIdentifier:ChangePasswordWindowControllerIdentifier];
    [cc.window setAnimationBehavior:NSWindowAnimationBehaviorDocumentWindow];
    [cc.window makeFirstResponder:nil];
    
    return cc;
}


- (void)windowDidLoad {
    [super windowDidLoad];
    
    [self.window center];
}

@end
