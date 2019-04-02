//
//  UploadViewController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/10/17.
//  Copyright © 2018 easyVideo. All rights reserved.
//

#import "UploadViewController.h"

@interface UploadViewController ()

@end

@implementation UploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self.view setBackgroundColor:WHITECOLOR];
    self.uploadTitle.stringValue = localizationBundle(@"alert.upload");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadSu) name:UPLOADSU object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadf) name:UPLOADFAIL object:nil];
}

- (void)viewWillDisappear
{
    [super viewWillDisappear];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UPLOADSU object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UPLOADFAIL object:nil];
}

#pragma mark - Notification
- (void)uploadSu
{
    self.uploadTitle.stringValue = localizationBundle(@"alert.uploaded.successfully");
}

- (void)uploadf
{
    self.uploadTitle.stringValue = localizationBundle(@"alert.uploaded.failed");
}

@end
