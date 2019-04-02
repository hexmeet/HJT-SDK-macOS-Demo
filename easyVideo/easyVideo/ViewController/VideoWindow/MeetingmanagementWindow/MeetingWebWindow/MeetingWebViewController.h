//
//  MeetingWebViewController.h
//  easyVideo
//
//  Created by quanhao huang on 2018/9/19.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MeetingWebViewController : NSViewController

@property (weak) IBOutlet WKWebView *webView;
@property (weak) IBOutlet NSButton *reloadBtn;
@property (weak) IBOutlet NSView *bgView;

@end

NS_ASSUME_NONNULL_END
