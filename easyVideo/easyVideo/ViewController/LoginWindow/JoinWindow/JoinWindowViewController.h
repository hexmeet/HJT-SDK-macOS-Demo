//
//  JoinWindowViewController.h
//  easyVideo
//
//  Created by quanhao huang on 2019/8/13.
//  Copyright © 2019 easyVideo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface JoinWindowViewController : NSViewController

@property (nonatomic, strong) NSDictionary *meetingDic;
@property (weak) IBOutlet NSTextField *meetingNumber;
@property (weak) IBOutlet NSTextField *displayNameTF;
@property (weak) IBOutlet NSButton *cancelBtn;
@property (weak) IBOutlet NSButton *joinBtn;
@property (weak) IBOutlet NSButton *cameraBtn;
@property (weak) IBOutlet NSButton *microphoneBtn;

- (void)setInfo;

@end

NS_ASSUME_NONNULL_END
