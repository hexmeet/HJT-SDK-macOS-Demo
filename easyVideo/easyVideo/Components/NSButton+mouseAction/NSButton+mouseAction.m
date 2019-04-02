//
//  NSButton+mouseAction.m
//  easyVideo
//
//  Created by quanhao huang on 2018/8/22.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "NSButton+mouseAction.h"

@implementation NSButton (mouseAction)

- (void)buttonAddMouseAction
{
    NSTrackingArea *area = [[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingMouseEnteredAndExited|NSTrackingActiveInKeyWindow owner:self userInfo:nil];
    
    [self addTrackingArea:area];
}

@end
