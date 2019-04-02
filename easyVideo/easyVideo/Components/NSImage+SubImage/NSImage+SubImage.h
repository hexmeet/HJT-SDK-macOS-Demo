//
//  NSImage+SubImage.h
//  easyVideo
//
//  Created by quanhao huang on 2018/9/12.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (SubImage)
#pragma mark - 截取当前image对象rect区域内的图像
- (NSImage *)subImageWithRect:(CGRect)rect;

@end
