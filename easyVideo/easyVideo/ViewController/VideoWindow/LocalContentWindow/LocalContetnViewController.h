//
//  LocalContetnViewController.h
//  easyVideo-avc
//
//  Created by quanhao huang on 2019/4/8.
//  Copyright © 2019 EVSDK. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocalContetnViewController : NSViewController

/** View */
@property (weak) IBOutlet NSView *localView;

/** Button */
@property (weak) IBOutlet NSButton *saveBtn;
@property (weak) IBOutlet NSButton *stopBtn;

/** Title */
@property (weak) IBOutlet NSTextField *saveTitle;
@property (weak) IBOutlet NSTextField *stopTitle;

@end

NS_ASSUME_NONNULL_END
