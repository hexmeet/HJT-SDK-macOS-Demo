//
//  NSView+addShadow.m
//  easyVideo
//
//  Created by quanhao huang on 2018/8/13.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "NSView+addShadow.h"

@implementation NSView (addShadow)

- (void)setAddshadow{
    NSShadow *dropShadow = [[NSShadow alloc] init];
    
    [dropShadow setShadowColor:[NSColor redColor]];
    [dropShadow setShadowOffset:NSMakeSize(44, 44)];
    
    [self setWantsLayer: YES];
    [self setShadow: dropShadow];
}

- (void)setAroundshadow
{
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowColor:[NSColor colorWithRed:0/255. green:0/255. blue:0/255. alpha:1]];
    [shadow setShadowOffset:NSMakeSize(4, 4)];
    [self setWantsLayer:YES];
    [self setShadow:shadow];
}

@end
