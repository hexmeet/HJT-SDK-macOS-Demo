//
//  CustomFieldCell.m
//  easyVideo
//
//  Created by quanhao huang on 2019/11/29.
//  Copyright © 2019 easyVideo. All rights reserved.
//

#import "CustomFieldCell.h"

@implementation CustomFieldCell

- (NSRect)adjustedFrameToVerticallyCenterText:(NSRect)frame {
    // super would normally draw text at the top of the cell
    CGFloat fontSize = self.font.boundingRectForFont.size.height;
    NSInteger offset = floor((NSHeight(frame) - ceilf(fontSize))/2)-5;
    NSRect centeredRect = NSInsetRect(frame, 0, offset);
    return centeredRect;
}

 - (void)editWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)editor delegate:(id)delegate event:(NSEvent *)event {
     [super editWithFrame:[self adjustedFrameToVerticallyCenterText:aRect]
                  inView:controlView editor:editor delegate:delegate event:event];
}

- (void)selectWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)editor delegate:(id)delegate start:(NSInteger)start length:(NSInteger)length {

    [super selectWithFrame:[self adjustedFrameToVerticallyCenterText:aRect]
                inView:controlView editor:editor delegate:delegate
                 start:start length:length];
}

 - (void)drawInteriorWithFrame:(NSRect)frame inView:(NSView *)view {
     [super drawInteriorWithFrame:[self adjustedFrameToVerticallyCenterText:frame] inView:view];
}

@end
