//
//  CustomCell.h
//  tasdasd
//
//  Created by quanhao huang on 2018/9/20.
//  Copyright © 2018年 asd. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^DeleteBlock)(void);
typedef void (^SelectBlock)(NSString *confId);
@interface CustomCell : NSTableCellView

@property (weak) IBOutlet NSTextField *test;
@property (weak) IBOutlet NSView *line;
@property (nonatomic, copy) DeleteBlock deleteBlock;
@property (nonatomic, copy) SelectBlock selectBlock;

@end

NS_ASSUME_NONNULL_END
