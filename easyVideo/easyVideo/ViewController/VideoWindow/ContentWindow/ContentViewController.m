//
//  ContentViewController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/9/19.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "ContentViewController.h"
#import "VideoController.h"

@interface ContentViewController ()
{
    VideoController *contentVideoController;
    AppDelegate *appDelegate;
}
@end

@implementation ContentViewController

- (void)viewWillDisappear
{
    [super viewWillDisappear];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CLOSECONTENTWINDOW object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self.view setBackgroundColor:WHITECOLOR];
    
    appDelegate = APPDELEGATE;
    
    contentVideoController = [[VideoController alloc] initWithViewAndType:CONTENT viewFrame:self.view.frame];
    [appDelegate.evengine setRemoteContentWindow:(__bridge void *)(contentVideoController.videoView)];
    DDLogInfo(@"[Info] 10031 Set Content Video Window");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeWindow) name:CLOSECONTENTWINDOW object:nil];
    
    [self.view addSubview:contentVideoController.view];
    
}

- (void)viewDidLayout
{
    contentVideoController.view.frame = self.view.frame;
    self.view.window.title = infoPlistStringBundle(@"CFBundleName");
}

#pragma mark - Notifacation
- (void)closeWindow
{
    [self.view.window close];
}

@end
