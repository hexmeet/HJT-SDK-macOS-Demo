//
//  UploadWindowController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/10/17.
//  Copyright © 2018 easyVideo. All rights reserved.
//

#import "UploadWindowController.h"

static NSString *const kStoryboardName  = @"Main";
static NSString *const UploadWindowControllerIdentifier = @"UploadWindowController";
@interface UploadWindowController ()

@end

@implementation UploadWindowController

+ (instancetype)windowController{
    
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:kStoryboardName
                                                         bundle:[NSBundle mainBundle]];
    
    UploadWindowController *cc = [storyboard instantiateControllerWithIdentifier:UploadWindowControllerIdentifier];
    [cc.window setAnimationBehavior:NSWindowAnimationBehaviorDocumentWindow];
    [cc.window makeFirstResponder:nil];
    
    return cc;
}


- (void)windowDidLoad {
    [super windowDidLoad];
    
    [self.window center];
}

@end
