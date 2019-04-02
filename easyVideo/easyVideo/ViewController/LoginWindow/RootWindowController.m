//
//  RootWindowController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/8/10.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "RootWindowController.h"

static NSString *const kStoryboardName  = @"Main";
static NSString *const RootWindowControllerIdentifier = @"RootWindowController";
@interface RootWindowController ()<NSWindowDelegate>

@end

@implementation RootWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    AppDelegate *appDelegate = APPDELEGATE;
    appDelegate.mainWindowController = self;
    
    [self.window center];
}


+ (instancetype)windowController{
    
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:kStoryboardName
                                                         bundle:[NSBundle mainBundle]];
    
    RootWindowController *loginWC = [storyboard instantiateControllerWithIdentifier:RootWindowControllerIdentifier];
    
    [loginWC.window setAnimationBehavior:NSWindowAnimationBehaviorDocumentWindow];
    return loginWC;
}

@end
