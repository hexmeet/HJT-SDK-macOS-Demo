//
//  EmojiPopover.h
//  emsdk-macos
//
//  Created by quanhao huang on 2019/9/5.
//  Copyright © 2019 em. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EmojiItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface EmojiPopover : NSViewController

@property (weak) IBOutlet NSCollectionView *collectionView;

@end

NS_ASSUME_NONNULL_END
