//
//  EmojiPopover.m
//  emsdk-macos
//
//  Created by quanhao huang on 2019/9/5.
//  Copyright © 2019 em. All rights reserved.
//

#import "EmojiPopover.h"

#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24);
@interface EmojiPopover ()<NSCollectionViewDataSource, NSCollectionViewDelegate>

@property (nonatomic, strong)NSMutableArray *emojiPackages;

@end

@implementation EmojiPopover

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
//    NSString *emojiBundlePath = [[NSBundle mainBundle] pathForResource:@"EmojiPackage" ofType:@"bundle"];
//    NSBundle *emojiBundle = [NSBundle bundleWithPath:emojiBundlePath];
//    NSString *emojiPath = [emojiBundle pathForResource:@"EmojiPackageList" ofType:@"plist"];
//
//    NSArray<NSDictionary *> *emojiArray = [NSArray arrayWithContentsOfFile:emojiPath];
//    NSDictionary *emojiDic = emojiArray[0];
//
    _emojiPackages = [NSMutableArray arrayWithCapacity:1];
//    NSArray *emojis = emojiDic[@"emojis"];
//    [_emojiPackages addObjectsFromArray:emojis];
    [_emojiPackages addObjectsFromArray: [self defaultEmoticons]];
    
    [_collectionView reloadData];
}

- (NSArray *)defaultEmoticons {

    NSMutableArray *array = [NSMutableArray new];

    for (int i=0x1F600; i<=0x1F64F; i++) {

        if (i < 0x1F641 || i > 0x1F644) {

            int sym = EMOJI_CODE_TO_SYMBOL(i);

            NSString *emoT = [[NSString alloc] initWithBytes:&sym length:sizeof(sym) encoding:NSUTF8StringEncoding];

            [array addObject:emoT];

        }

    }

    return array;

}

- (NSInteger)collectionView:(nonnull NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _emojiPackages.count;
}

- (nonnull NSCollectionViewItem *)collectionView:(nonnull NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(nonnull NSIndexPath *)indexPath {
    EmojiItem *item = [collectionView makeItemWithIdentifier:@"EmojiItem" forIndexPath:indexPath];
    NSString *emojiDic = _emojiPackages[indexPath.item];
    item.emojiLb.stringValue = emojiDic;
    return item;
}

- (void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths
{
    NSArray * array = [indexPaths allObjects];
    NSIndexPath *path = array[0];
    collectionView.selectable = YES;
    
    [[EMManager sharedInstance].delegates emojiStr:_emojiPackages[path.item]];
    [_collectionView reloadItemsAtIndexPaths:indexPaths];
}

+ (NSString *)bundleFile:(NSString *)file;
{
    return [[NSBundle mainBundle] pathForResource:[file stringByDeletingPathExtension] ofType:[file pathExtension]];
}

@end
