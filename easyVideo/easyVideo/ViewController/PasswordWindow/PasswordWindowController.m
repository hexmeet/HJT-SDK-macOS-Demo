//
//  PasswordWindowController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/9/21.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "PasswordWindowController.h"

static NSString *const kStoryboardName  = @"Main";
static NSString *const PasswordWindowControllerIdentifier = @"PasswordWindowController";
@interface PasswordWindowController ()

@end

@implementation PasswordWindowController

+ (instancetype)windowController{
    
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:kStoryboardName
                                                         bundle:[NSBundle mainBundle]];
    
    PasswordWindowController *cc = [storyboard instantiateControllerWithIdentifier:PasswordWindowControllerIdentifier];
    [cc.window setAnimationBehavior:NSWindowAnimationBehaviorDocumentWindow];
    [cc.window makeFirstResponder:nil];
    
    return cc;
}


- (void)windowDidLoad {
    [super windowDidLoad];
    
    [self.window center];
}

@end
