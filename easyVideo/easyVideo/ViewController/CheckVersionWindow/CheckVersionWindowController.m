//
//  CheckVersionWindowController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/11/14.
//  Copyright © 2018 easyVideo. All rights reserved.
//

#import "CheckVersionWindowController.h"

static NSString *const kStoryboardName  = @"Main";
static NSString *const CheckVersionWindowControllerIdentifier = @"CheckVersionWindowController";
@interface CheckVersionWindowController ()

@end

@implementation CheckVersionWindowController

+ (instancetype)windowController{
    
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:kStoryboardName
                                                         bundle:[NSBundle mainBundle]];
    
    CheckVersionWindowController *cc = [storyboard instantiateControllerWithIdentifier:CheckVersionWindowControllerIdentifier];
    [cc.window setAnimationBehavior:NSWindowAnimationBehaviorDocumentWindow];
    [cc.window makeFirstResponder:nil];
    
    return cc;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    [self.window center];
}

@end
