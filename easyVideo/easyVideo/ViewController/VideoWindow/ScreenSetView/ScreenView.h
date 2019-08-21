//
//  ScreenView.h
//  easyVideo-avc
//
//  Created by quanhao huang on 2019/4/9.
//  Copyright © 2019 EVSDK. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScreenView : NSView

@property (weak) IBOutlet NSButton *screenImage;
@property (weak) IBOutlet NSTextField *screenName;
@property (weak) IBOutlet NSButton *chooseBtn;

@end

NS_ASSUME_NONNULL_END
