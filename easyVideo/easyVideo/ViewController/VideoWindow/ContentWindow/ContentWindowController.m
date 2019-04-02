//
//  ContentWindowController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/9/19.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "ContentWindowController.h"

static NSString *const kStoryboardName  = @"Video";
static NSString *const ContentWindowControllerIdentifier = @"ContentWindowController";
@interface ContentWindowController ()

@end

@implementation ContentWindowController

+ (instancetype)windowController{
    
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:kStoryboardName
                                                         bundle:[NSBundle mainBundle]];
    
    ContentWindowController *cc = [storyboard instantiateControllerWithIdentifier:ContentWindowControllerIdentifier];
    [cc.window setAnimationBehavior:NSWindowAnimationBehaviorDocumentWindow];
    [cc.window makeFirstResponder:nil];
    return cc;
}


- (void)windowDidLoad {
    [super windowDidLoad];
    
    [self.window center];
}

@end
