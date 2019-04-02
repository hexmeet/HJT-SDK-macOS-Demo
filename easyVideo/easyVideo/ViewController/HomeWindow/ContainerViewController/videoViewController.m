//
//  videoViewController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/8/24.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "videoViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface videoViewController ()
{
    AppDelegate *appDelegate;
}

@end

@implementation videoViewController

@synthesize cameraTitle, cameraboBox, videoBg;

- (void)viewWillAppear
{
    [super viewWillAppear];
    
    [self getAllEVDeviceVideoCapture];
}

- (void)viewDidDisappear
{
    [super viewDidDisappear];
    
    [appDelegate.evengine enablePreview:NO];
    [NSUSERDEFAULT setValue:@"NO" forKey:@"showvideo"];
    [NSUSERDEFAULT synchronize];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self setRootViewAttribute];
    
    [self languageLocalization];
    
}

- (void)setRootViewAttribute
{
    cameraboBox.editable = NO;
    [videoBg setBackgroundColor:BLACKCOLOR];
    
    appDelegate = APPDELEGATE;
}

- (void)getAllEVDeviceVideoCapture
{
    NSArray *devices = [appDelegate.evengine getDevices:EVDeviceVideoCapture];
    if (devices.count != 0) {
        EVDevice *device = [appDelegate.evengine getDevice:EVDeviceVideoCapture];
        //cameraboBox select the first by default
        [cameraboBox removeAllItems];
        cameraboBox.stringValue = device.name;
        for (EVDevice *device in devices) {
            [cameraboBox addItemWithObjectValue:device.name];
        }
    }
    
    if ([[NSUSERDEFAULT objectForKey:@"showvideo"]isEqualToString:@"YES"]) {
        [appDelegate.evengine enablePreview:YES];
        [appDelegate.evengine setLocalVideoWindow:(__bridge void *)(videoBg)];
    }
}

/**
 Language localization
 */
- (void)languageLocalization
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage:) name:CHANGELANGUAGE object:nil];
    
    [LanguageTool initUserLanguage];
    
    cameraTitle.stringValue = localizationBundle(@"home.set.video.camera");
}


- (IBAction)camaraboBoxAction:(id)sender
{
    NSArray *devices = [appDelegate.evengine getDevices:EVDeviceVideoCapture];
    for (EVDevice *device in devices) {
        if ([device.name isEqualToString:cameraboBox.stringValue]) {
            
            [appDelegate.evengine setDevice:EVDeviceVideoCapture withId:device.id];
        }
    }
}

#pragma mark - Notification
/**
 Toggle language
 
 @param sender Notification
 */
- (void)changeLanguage:(NSNotification *)sender
{
    cameraTitle.stringValue = localizationBundle(@"home.set.video.camera");
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CHANGELANGUAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SHOWVIDEO object:nil];
}

@end
