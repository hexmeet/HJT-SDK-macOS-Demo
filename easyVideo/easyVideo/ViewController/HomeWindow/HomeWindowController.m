//
//  HomeWindowController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/8/17.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "HomeWindowController.h"

static NSString *const kStoryboardName  = @"Main";
static NSString *const HomeWindowControllerIdentifier = @"HomeWindowController";
@interface HomeWindowController ()<NSWindowDelegate>

@end

@implementation HomeWindowController

+ (instancetype)windowController{
    
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:kStoryboardName
                                                         bundle:[NSBundle mainBundle]];
    
    HomeWindowController *cc = [storyboard instantiateControllerWithIdentifier:HomeWindowControllerIdentifier];
    [cc.window setAnimationBehavior:NSWindowAnimationBehaviorDocumentWindow];
    [cc.window makeFirstResponder:nil];
    return cc;
}


- (void)windowDidLoad {
    [super windowDidLoad];

    [self.window center];
}

@end
