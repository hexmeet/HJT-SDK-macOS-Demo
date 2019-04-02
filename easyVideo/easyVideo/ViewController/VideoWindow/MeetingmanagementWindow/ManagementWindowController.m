//
//  ManagementWindowController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/8/31.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "ManagementWindowController.h"

static NSString *const kStoryboardName  = @"Video";
static NSString *const ManagementWindowControllerIdentifier = @"ManagementWindowController";
@interface ManagementWindowController ()

@end

@implementation ManagementWindowController

+ (instancetype)windowController{
    
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:kStoryboardName
                                                         bundle:[NSBundle mainBundle]];
    
    ManagementWindowController *cc = [storyboard instantiateControllerWithIdentifier:ManagementWindowControllerIdentifier];
    [cc.window setAnimationBehavior:NSWindowAnimationBehaviorDocumentWindow];
    [cc.window makeFirstResponder:nil];
    
    return cc;
}


- (void)windowDidLoad {
    [super windowDidLoad];
    
    [self.window center];
}

@end
