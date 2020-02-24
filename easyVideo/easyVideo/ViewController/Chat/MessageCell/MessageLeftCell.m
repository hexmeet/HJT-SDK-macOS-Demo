//
//  MessageLeftCell.m
//  easyVideo
//
//  Created by quanhao huang on 2019/12/18.
//  Copyright © 2019 easyVideo. All rights reserved.
//

#import "MessageLeftCell.h"
#import "NSImage+resizableImage.h"

@implementation MessageLeftCell

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    self.headImage.wantsLayer = YES;
    self.headImage.layer.cornerRadius = 18;
}

@end
