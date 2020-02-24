//
//  ConnectingViewController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/9/17.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "ConnectingViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ConnectingViewController ()<AVAudioPlayerDelegate>
{
    AVAudioPlayer *musicPlayer;
}
@end

@implementation ConnectingViewController

@synthesize confId, imageBg;

- (void)viewWillDisappear
{
    [super viewWillDisappear];
    
    [musicPlayer stop];
    musicPlayer = nil;
    musicPlayer.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self.view setBackgroundColor:WHITECOLOR];
    [confId setBackgroundColor:CLEARCOLOR];
    
    NSMutableDictionary *setDic = [NSMutableDictionary dictionaryWithDictionary:[PlistUtils loadUserInfoPlistFilewithFileName:SETINFO]];
    confId.stringValue = setDic[@"confId"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeWindow) name:CLOSECONNECTINGWINDOW object:nil];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ringtone" ofType:@"wav"];
    NSURL *fileUrl = [NSURL URLWithString:filePath];
    musicPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileUrl error:nil];
    musicPlayer.delegate = self;
    
    if (![musicPlayer isPlaying]){
        [musicPlayer prepareToPlay];
        [musicPlayer play];
    }
}

- (void)viewDidLayout
{
    [super viewDidLayout];
    NSImage *image = [NSImage imageNamed:@"bg_calling"];
    imageBg.image = [EVUtils resizeImage:image size:imageBg.frame.size];
}

#pragma mark - AVAudioPlayerDelegate
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [musicPlayer prepareToPlay];
    [musicPlayer play];
}

#pragma mark - ButtonMethod
- (IBAction)callcancelAction:(id)sender
{
    [self.view.window close];
    Notifications(CANCELCALL);
}

#pragma mark - Notification
- (void)closeWindow
{
    [self.view.window close];
}

@end
