//
//  LocalContentWindowController.m
//  easyVideo-avc
//
//  Created by quanhao huang on 2019/4/8.
//  Copyright © 2019 EVSDK. All rights reserved.
//

#import "LocalContentWindowController.h"

static NSString *const kStoryboardName  = @"Content";
static NSString *const LocalContentWindowControllerIdentifier = @"LocalContentWindowController";
@interface LocalContentWindowController ()

@end

@implementation LocalContentWindowController

+ (instancetype)windowController{
    
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:kStoryboardName
                                                         bundle:[NSBundle mainBundle]];
    LocalContentWindowController *cc = [storyboard instantiateControllerWithIdentifier:LocalContentWindowControllerIdentifier];
    [cc.window setAnimationBehavior:NSWindowAnimationBehaviorDocumentWindow];
    [cc.window makeFirstResponder:nil];
    return cc;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self.window center];
}

@end
