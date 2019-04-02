//
//  HeadImageWindowController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/8/29.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "HeadImageWindowController.h"

static NSString *const kStoryboardName  = @"Main";
static NSString *const HeadImageWindowControllerIdentifier = @"HeadImageWindowController";
@interface HeadImageWindowController ()

@end

@implementation HeadImageWindowController

+ (instancetype)windowController{
    
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:kStoryboardName
                                                         bundle:[NSBundle mainBundle]];
    
    HeadImageWindowController *cc = [storyboard instantiateControllerWithIdentifier:HeadImageWindowControllerIdentifier];
    [cc.window setAnimationBehavior:NSWindowAnimationBehaviorDocumentWindow];
    [cc.window makeFirstResponder:nil];
    
    return cc;
}


- (void)windowDidLoad {
    [super windowDidLoad];
    
    [self.window center];
}

@end
