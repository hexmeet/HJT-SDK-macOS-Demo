//
//  ScreenWindowController.m
//  easyVideo-avc
//
//  Created by quanhao huang on 2019/4/9.
//  Copyright © 2019 EVSDK. All rights reserved.
//

#import "ScreenWindowController.h"

static NSString *const kStoryboardName  = @"Video";
static NSString *const ScreenWindowControllerIdentifier = @"ScreenWindowController";
@interface ScreenWindowController ()

@end

@implementation ScreenWindowController

+ (instancetype)windowController{
    
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:kStoryboardName
                                                         bundle:[NSBundle mainBundle]];
    
    ScreenWindowController *cc = [storyboard instantiateControllerWithIdentifier:ScreenWindowControllerIdentifier];
    [cc.window setAnimationBehavior:NSWindowAnimationBehaviorDocumentWindow];
    [cc.window makeFirstResponder:nil];
    
    return cc;
}


- (void)windowDidLoad {
    [super windowDidLoad];
    
    [self.window center];
}
@end
