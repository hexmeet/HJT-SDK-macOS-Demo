//
//  UserWindowController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/8/21.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "UserWindowController.h"

static NSString *const kStoryboardName  = @"Main";
static NSString *const UserWindowControllerIdentifier = @"UserWindowController";
@interface UserWindowController ()

@end

@implementation UserWindowController

+ (instancetype)windowController{
    
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:kStoryboardName
                                                         bundle:[NSBundle mainBundle]];
    
    UserWindowController *cc = [storyboard instantiateControllerWithIdentifier:UserWindowControllerIdentifier];
    [cc.window setAnimationBehavior:NSWindowAnimationBehaviorDocumentWindow];
    [cc.window makeFirstResponder:nil];
    
    return cc;
}


- (void)windowDidLoad {
    [super windowDidLoad];
    
    [self.window center];
}

@end
