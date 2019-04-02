//
//  SpeakerViewController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/9/10.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "SpeakerViewController.h"
#import "speakerView.h"
#import "SWSTAnswerButton.h"
#import "macHUD.h"

@interface SpeakerViewController ()
{
    AppDelegate *appDelegate;
    macHUD *hub;
}
@end

@implementation SpeakerViewController

@synthesize scrollView, scrollViewConstraint;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self setRootViewAttribute];
    
}

- (void)setRootViewAttribute
{
    [self.view setBackgroundColor:WHITECOLOR];
    appDelegate = APPDELEGATE;
    
    hub = [macHUD creatMacHUD:@"" icon:@"" viewController:self];
    hub.hidden = YES;
    
    NSArray *deviceArr = [appDelegate.evengine getDevices:EVDeviceAudioCapture];
    EVDevice *selectDevice = [appDelegate.evengine getDevice:EVDeviceAudioCapture];
    if (deviceArr.count == 1) {
        EVDevice *device = deviceArr[0];
        speakerView *speaker = [self creatSpeakerView];
        speaker.frame = CGRectMake(144, 0, 143, 224);
        speaker.selectBtn.tag = 0;
        speaker.selectImage.hidden = NO;
        speaker.speakerName.stringValue = device.name;
        [speaker.selectBtn setTarget:self];
        [speaker.selectBtn setAction:@selector(chooseSpeaker:)];
        scrollViewConstraint.constant = 143;
        [scrollView.contentView addSubview:speaker];
        
    }else if (deviceArr.count == 2) {
        for (int i = 0; i<deviceArr.count; i++) {
            EVDevice *device = deviceArr[i];
            speakerView *speaker = [self creatSpeakerView];
            if ([device.name isEqualToString:selectDevice.name]) {
                speaker.selectImage.hidden = NO;
            }
            speaker.frame = CGRectMake(143*i+72, 0, 143, 224);
            speaker.selectBtn.tag = i;
            speaker.speakerName.stringValue = device.name;
            [speaker.selectBtn setTarget:self];
            [speaker.selectBtn setAction:@selector(chooseSpeaker:)];
            scrollViewConstraint.constant = 143*i;
            [scrollView.contentView addSubview:speaker];
        }
    }else {
        for (int i = 0; i<deviceArr.count; i++) {
            EVDevice *device = deviceArr[i];
            speakerView *speaker = [self creatSpeakerView];
            if ([device.name isEqualToString:selectDevice.name]) {
                speaker.selectImage.hidden = NO;
            }
            speaker.frame = CGRectMake(143*i, 0, 143, 224);
            speaker.selectBtn.tag = i;
            speaker.speakerName.stringValue = device.name;
            [speaker.selectBtn setTarget:self];
            [speaker.selectBtn setAction:@selector(chooseSpeaker:)];
            scrollViewConstraint.constant = 143*i;
            [scrollView.contentView addSubview:speaker];
        }
    }
}

- (speakerView *)creatSpeakerView
{
    NSBundle*            aBundle = [NSBundle mainBundle];
    NSMutableArray*      topLevelObjs = [NSMutableArray array];
    NSDictionary*        nameTable = [NSDictionary dictionaryWithObjectsAndKeys:
                                      self, NSNibOwner,
                                      topLevelObjs, NSNibTopLevelObjects,
                                      nil];
    
    if (![aBundle loadNibFile:@"speakerView" externalNameTable:nameTable withZone:nil])
    {
        
    }
    
    speakerView *myView = nil;
    
    for (id classtpye in topLevelObjs) {
        if ([classtpye isKindOfClass:[speakerView class]]) {
            myView = classtpye;
        }
    }
    
    return myView;
}

#pragma mark - ButtonMethod
- (void)chooseSpeaker:(SWSTAnswerButton *)sender
{
    NSArray *deviceArr = [appDelegate.evengine getDevices:EVDeviceAudioCapture];
    EVDevice *device = deviceArr[sender.tag];
    [appDelegate.evengine setDevice:EVDeviceAudioCapture withId:device.id];
    hub.hidden = NO;
    hub.hudTitleFd.stringValue = localizationBundle(@"alert.modifysuccess");
    [self persendMethod:1];
}

#pragma mark - HUDHIDDEN
- (void)persendMethod:(NSInteger)time
{
    [self performSelector:@selector(hiddenHUD) withObject:self afterDelay:time];
}

- (void)hiddenHUD
{
    hub.hidden = YES;
    [self.view.window close];
}


@end
