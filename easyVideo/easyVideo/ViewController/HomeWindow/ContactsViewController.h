//
//  ContactsViewController.h
//  easyVideo
//
//  Created by quanhao huang on 2019/11/12.
//  Copyright © 2019 easyVideo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "GifView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContactsViewController : NSViewController

@property (weak) IBOutlet WKWebView *webView;
@property (weak) IBOutlet NSView *loadViewBg;
@property (weak) IBOutlet GifView *gifView;
@property (weak) IBOutlet NSImageView *errorBg;
@property (weak) IBOutlet NSTextField *prompttitel;
@property (weak) IBOutlet NSView *loadBg;
@property (weak) IBOutlet NSButton *loadBtn;

@end

NS_ASSUME_NONNULL_END
