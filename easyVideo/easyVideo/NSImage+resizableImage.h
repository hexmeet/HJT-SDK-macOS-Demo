//
//  NSImage+resizableImage.h
//  easyVideo
//
//  Created by quanhao huang on 2019/12/18.
//  Copyright © 2019 easyVideo. All rights reserved.
//
#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSImage (resizableImage)

//保持四周一定区域像素不拉伸，将图像扩散到一定的大小
- (NSImage *)stretchableImageWithSize:(NSSize)size edgeInsets:(NSEdgeInsets)insets;
//保持leftWidth,rightWidth这左右一定区域不拉伸，将图片宽度拉伸到(leftWidth+middleWidth+rightWidth)
- (NSImage *)stretchableImageWithLeftCapWidth:(float)leftWidth middleWidth:(float)middleWidth rightCapWidth:(float)rightWidth;

@end

NS_ASSUME_NONNULL_END
