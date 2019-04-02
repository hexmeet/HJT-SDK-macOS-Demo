//
//  micphoneView.m
//  easyVideo
//
//  Created by quanhao huang on 2018/9/10.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "micphoneView.h"

@implementation micphoneView

- (void)awakeFromNib
{
    
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    [self setBackgroundColor:WHITECOLOR];
    self.layer.cornerRadius = 4.;
}

@end
