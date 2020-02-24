//
//  MessageLeftCell.h
//  easyVideo
//
//  Created by quanhao huang on 2019/12/18.
//  Copyright © 2019 easyVideo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageLeftCell : NSTableCellView

@property (weak) IBOutlet NSTextField *time;
@property (weak) IBOutlet NSTextField *name;
@property (weak) IBOutlet NSImageView *headImage;
@property (weak) IBOutlet NSTextField *content;

@end

NS_ASSUME_NONNULL_END
