//
//  LocalWindowController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/9/17.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "LocalWindowController.h"

static NSString *const kStoryboardName  = @"Video";
static NSString *const LocalWindowControllerIdentifier = @"LocalWindowController";
@interface LocalWindowController ()

@end

@implementation LocalWindowController

+ (instancetype)windowController{
    
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:kStoryboardName
                                                         bundle:[NSBundle mainBundle]];
    
    LocalWindowController *cc = [storyboard instantiateControllerWithIdentifier:LocalWindowControllerIdentifier];
    [cc.window setAnimationBehavior:NSWindowAnimationBehaviorDocumentWindow];
    [cc.window makeFirstResponder:nil];
    return cc;
}


- (void)windowDidLoad {
    [super windowDidLoad];
    NSRect r=[[NSScreen mainScreen] visibleFrame];
    [self.window setFrameOrigin:NSMakePoint(r.size.width/2+544-180, 375/2+80)];
}


@end
