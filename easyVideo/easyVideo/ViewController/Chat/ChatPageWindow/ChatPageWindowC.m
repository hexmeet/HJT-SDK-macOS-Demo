//
//  ChatPageWindowC.m
//  easyVideo
//
//  Created by quanhao huang on 2019/12/18.
//  Copyright © 2019 easyVideo. All rights reserved.
//

#import "ChatPageWindowC.h"

static NSString *const kStoryboardName  = @"Chat";
static NSString *const ChatPageWindowCIdentifier = @"ChatPageWindowC";
@interface ChatPageWindowC ()

@end

@implementation ChatPageWindowC

+ (instancetype)windowController{
    
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:kStoryboardName
                                                         bundle:[NSBundle mainBundle]];
    
    ChatPageWindowC *cc = [storyboard instantiateControllerWithIdentifier:ChatPageWindowCIdentifier];
    [cc.window setAnimationBehavior:NSWindowAnimationBehaviorDocumentWindow];
    [cc.window makeFirstResponder:nil];
    
    ChatPageViewController *viewC = (ChatPageViewController *)cc.window.contentViewController;
    [[cc window] makeFirstResponder:viewC.inputView];
    
    return cc;
}


- (void)windowDidLoad {
    
    [super windowDidLoad];

    [self.window center];
}
@end
