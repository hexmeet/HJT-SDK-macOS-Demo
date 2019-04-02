//
//  CustomCell.m
//  tasdasd
//
//  Created by quanhao huang on 2018/9/20.
//  Copyright © 2018年 asd. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}
- (IBAction)deleteAction:(id)sender
{
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

- (IBAction)selectAction:(id)sender
{
    if (self.selectBlock) {
        self.selectBlock(self.test.stringValue);
    }
}

@end
