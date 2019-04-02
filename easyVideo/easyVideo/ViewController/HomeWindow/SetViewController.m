//
//  SetViewController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/8/24.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "SetViewController.h"

@interface SetViewController ()

@end

@implementation SetViewController

@synthesize leftViewBg, conventionalViewBg, conventionalBtn, conventionalTitle, audioBtn, audioTitle, audioViewBg, videoBtn, videoTitle, videoViewBg, aboutTitle, aboutBtn, aboutViewBg, conventionView, audioView, videoView, aboutView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self setRootViewAttribute];
    
    [self languageLocalization];
}

- (void)setRootViewAttribute
{
    [self.view setBackgroundColor:WHITECOLOR];
    [leftViewBg setBackgroundColor:DEFAULTBGCOLOR];
    [conventionalViewBg setBackgroundColor:JOINWINDOWBTNSELECT];
    [audioViewBg setBackgroundColor:DEFAULTBGCOLOR];
    [videoViewBg setBackgroundColor:DEFAULTBGCOLOR];
    [aboutViewBg setBackgroundColor:DEFAULTBGCOLOR];
    
    [conventionalTitle setBackgroundColor:CLEARCOLOR];
    [videoTitle setBackgroundColor:CLEARCOLOR];
    [aboutTitle setBackgroundColor:CLEARCOLOR];
    [audioTitle setBackgroundColor:CLEARCOLOR];
    
    conventionView.hidden = NO;
    audioView.hidden = YES;
    videoView.hidden = YES;
    aboutView.hidden = YES;
}

/**
 Language localization
 */
- (void)languageLocalization
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage:) name:CHANGELANGUAGE object:nil];
    //初始化应用语言
    [LanguageTool initUserLanguage];
    
    conventionalTitle.stringValue = localizationBundle(@"home.set.conventional");
    audioTitle.stringValue = localizationBundle(@"home.set.audio");
    videoTitle.stringValue = localizationBundle(@"home.set.video");
    aboutTitle.stringValue = localizationBundle(@"home.set.about");
}

#pragma mark - NSButtonMethod
- (IBAction)buttonMethod:(id)sender
{
    if (sender == conventionalBtn) {
        [conventionalViewBg setBackgroundColor:JOINWINDOWBTNSELECT];
        [audioViewBg setBackgroundColor:DEFAULTBGCOLOR];
        [videoViewBg setBackgroundColor:DEFAULTBGCOLOR];
        [aboutViewBg setBackgroundColor:DEFAULTBGCOLOR];
        
        conventionView.hidden = NO;
        audioView.hidden = YES;
        videoView.hidden = YES;
        aboutView.hidden = YES;
    }else if (sender == audioBtn) {
        [conventionalViewBg setBackgroundColor:DEFAULTBGCOLOR];
        [audioViewBg setBackgroundColor:JOINWINDOWBTNSELECT];
        [videoViewBg setBackgroundColor:DEFAULTBGCOLOR];
        [aboutViewBg setBackgroundColor:DEFAULTBGCOLOR];
        
        conventionView.hidden = YES;
        audioView.hidden = NO;
        videoView.hidden = YES;
        aboutView.hidden = YES;
    }else if (sender == videoBtn) {
        [conventionalViewBg setBackgroundColor:DEFAULTBGCOLOR];
        [audioViewBg setBackgroundColor:DEFAULTBGCOLOR];
        [videoViewBg setBackgroundColor:JOINWINDOWBTNSELECT];
        [aboutViewBg setBackgroundColor:DEFAULTBGCOLOR];
        
        [NSUSERDEFAULT setValue:@"YES" forKey:@"showvideo"];
        [NSUSERDEFAULT synchronize];
        
        conventionView.hidden = YES;
        audioView.hidden = YES;
        videoView.hidden = NO;
        aboutView.hidden = YES;
    }else if (sender == aboutBtn) {
        [conventionalViewBg setBackgroundColor:DEFAULTBGCOLOR];
        [audioViewBg setBackgroundColor:DEFAULTBGCOLOR];
        [videoViewBg setBackgroundColor:DEFAULTBGCOLOR];
        [aboutViewBg setBackgroundColor:JOINWINDOWBTNSELECT];
        
        conventionView.hidden = YES;
        audioView.hidden = YES;
        videoView.hidden = YES;
        aboutView.hidden = NO;
    }
}

#pragma mark - Notification
/**
 Toggle language
 
 @param sender Notification
 */
- (void)changeLanguage:(NSNotification *)sender
{
    conventionalTitle.stringValue = localizationBundle(@"home.set.conventional");
    audioTitle.stringValue = localizationBundle(@"home.set.audio");
    videoTitle.stringValue = localizationBundle(@"home.set.video");
    aboutTitle.stringValue = localizationBundle(@"home.set.about");
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CHANGELANGUAGE object:nil];
}

@end
