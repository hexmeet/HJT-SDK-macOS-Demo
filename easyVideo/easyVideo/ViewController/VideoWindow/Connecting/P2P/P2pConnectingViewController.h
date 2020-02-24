//
//  P2pConnectingViewController.h
//  easyVideo
//
//  Created by quanhao huang on 2019/11/13.
//  Copyright © 2019 easyVideo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RippleAnimationView.h"

NS_ASSUME_NONNULL_BEGIN

@interface P2pConnectingViewController : NSViewController

@property (weak) IBOutlet NSView *localVideoView;
@property (weak) IBOutlet NSImageView *headImage;
@property (weak) IBOutlet NSTextField *userName;
@property (weak) IBOutlet NSTextField *callTitle;
@property (weak) IBOutlet NSTextField *hangUpTitle;
@property (nonatomic, assign) NSString *callNumber;

@end

NS_ASSUME_NONNULL_END
