//
//  ManagementViewController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/8/31.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "ManagementViewController.h"

@interface ManagementViewController ()

@end

@implementation ManagementViewController

@synthesize segment, setTitle, speakerView, micphoneView, cameraView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self languageLocalization];
}

- (void)languageLocalization
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeWindow) name:CLOSEMANMAGEWINDOW object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage:) name:CHANGELANGUAGE object:nil];
    
    [LanguageTool initUserLanguage];
    
    [segment setLabel:localizationBundle(@"video.speaker") forSegment:0];
    [segment setLabel:localizationBundle(@"video.microphone") forSegment:1];
    [segment setLabel:localizationBundle(@"video.camera") forSegment:2];
    
    setTitle.stringValue = localizationBundle(@"video.selectspeaker");
}

#pragma mark - NSButtonMethod
- (IBAction)closeWindow:(id)sender
{
    [self.view.window close];
}

- (IBAction)segementAction:(id)sender
{
    if (segment.selectedSegment == 0) {
        setTitle.stringValue = localizationBundle(@"video.selectspeaker");
        speakerView.hidden = NO;
        micphoneView.hidden = YES;
        cameraView.hidden = YES;
    }else if (segment.selectedSegment == 1) {
        setTitle.stringValue = localizationBundle(@"video.selectmicrophone");
        speakerView.hidden = YES;
        micphoneView.hidden = NO;
        cameraView.hidden = YES;
    }else {
        setTitle.stringValue = localizationBundle(@"video.selectcamera");
        speakerView.hidden = YES;
        micphoneView.hidden = YES;
        cameraView.hidden = NO;
    }
}

#pragma  mark - Notification
- (void)changeLanguage:(NSNotification *)sender
{
    [segment setLabel:localizationBundle(@"video.speaker") forSegment:0];
    [segment setLabel:localizationBundle(@"video.microphone") forSegment:1];
    [segment setLabel:localizationBundle(@"video.camera") forSegment:2];
    
    if (segment.selectedSegment == 0) {
        setTitle.stringValue = localizationBundle(@"video.selectspeaker");
    }else if (segment.selectedSegment == 1) {
        setTitle.stringValue = localizationBundle(@"video.selectmicrophone");
    }else {
        setTitle.stringValue = localizationBundle(@"video.selectcamera");
    }
}

- (void)closeWindow
{
    [self.view.window close];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CLOSEMANMAGEWINDOW object:nil];
}

@end
