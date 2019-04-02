//
//  NSImage+SubImage.m
//  easyVideo
//
//  Created by quanhao huang on 2018/9/12.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "NSImage+SubImage.h"

@implementation NSImage (SubImage)

- (NSImage *)subImageWithRect:(CGRect)rect
{
    NSImage* newImage = nil;
    [newImage lockFocus];
    [self drawInRect:rect fromRect:rect operation:NSCompositingOperationSourceOver fraction:1.0];
    [newImage unlockFocus];
    return newImage;
}

@end
