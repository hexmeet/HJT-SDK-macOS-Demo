//
//  ScreenViewController.h
//  easyVideo-avc
//
//  Created by quanhao huang on 2019/4/9.
//  Copyright © 2019 EVSDK. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScreenViewController : NSViewController

@property (weak) IBOutlet NSScrollView *scrollView;
@property (weak) IBOutlet NSButton *sureBtn;
@property (weak) IBOutlet NSTextField *chooseTitle;
@property (weak) IBOutlet NSLayoutConstraint *scrollViewConstraint;

@end

NS_ASSUME_NONNULL_END
