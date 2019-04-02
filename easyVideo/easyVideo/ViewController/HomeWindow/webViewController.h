//
//  webViewController.h
//  easyVideo
//
//  Created by quanhao huang on 2018/8/24.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "GifView.h"

@interface webViewController : NSViewController

@property (weak) IBOutlet WKWebView *webView;
@property (weak) IBOutlet NSView *loadViewBg;
@property (weak) IBOutlet GifView *gifView;
@property (weak) IBOutlet NSImageView *errorBg;
@property (weak) IBOutlet NSTextField *prompttitel;
@property (weak) IBOutlet NSView *loadBg;
@property (weak) IBOutlet NSButton *loadBtn;

@end
