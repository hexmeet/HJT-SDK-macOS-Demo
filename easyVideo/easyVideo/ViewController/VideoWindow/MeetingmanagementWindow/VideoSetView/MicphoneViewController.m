//
//  MicphoneViewController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/9/10.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "MicphoneViewController.h"
#import "micphoneView.h"
#import "SWSTAnswerButton.h"
#import "macHUD.h"

@interface MicphoneViewController ()
{
    AppDelegate *appDelegate;
    macHUD *hub;
}
@end

@implementation MicphoneViewController

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
    
    NSArray *deviceArr = [appDelegate.evengine getDevices:EVDeviceAudioPlayback];
    EVDevice *selectDevice = [appDelegate.evengine getDevice:EVDeviceAudioPlayback];
    if (deviceArr.count == 1) {
        EVDevice *device = deviceArr[0];
        micphoneView *micphone = [self creatMicphoneView];
        micphone.frame = CGRectMake(144, 0, 143, 224);
        micphone.selectBtn.tag = 0;
        micphone.selectImage.hidden = NO;
        micphone.micphoneName.stringValue = device.name;
        [micphone.selectBtn setTarget:self];
        [micphone.selectBtn setAction:@selector(chooseMicphone:)];
        scrollViewConstraint.constant = 143;
        [scrollView.contentView addSubview:micphone];
        
    }else if (deviceArr.count == 2) {
        for (int i = 0; i<deviceArr.count; i++) {
            EVDevice *device = deviceArr[i];
            micphoneView *micphone = [self creatMicphoneView];
            if ([device.name isEqualToString:selectDevice.name]) {
                micphone.selectImage.hidden = NO;
            }
            micphone.frame = CGRectMake(143*i+72, 0, 143, 224);
            [micphone.selectBtn setTarget:self];
            micphone.selectBtn.tag = i;
            micphone.micphoneName.stringValue = device.name;
            [micphone.selectBtn setAction:@selector(chooseMicphone:)];
            scrollViewConstraint.constant = 143*i;
            [scrollView.contentView addSubview:micphone];
        }
    }else {
        for (int i = 0; i<deviceArr.count; i++) {
            EVDevice *device = deviceArr[i];
            micphoneView *micphone = [self creatMicphoneView];
            micphone.frame = CGRectMake(143*i, 0, 143, 224);
            if ([device.name isEqualToString:selectDevice.name]) {
                micphone.selectImage.hidden = NO;
            }
            micphone.selectBtn.tag = i;
            micphone.micphoneName.stringValue = device.name;
            [micphone.selectBtn setTarget:self];
            [micphone.selectBtn setAction:@selector(chooseMicphone:)];
            scrollViewConstraint.constant = 143*i;
            [scrollView.contentView addSubview:micphone];
        }
    }
}

- (micphoneView *)creatMicphoneView
{
    NSBundle*            aBundle = [NSBundle mainBundle];
    NSMutableArray*      topLevelObjs = [NSMutableArray array];
    NSDictionary*        nameTable = [NSDictionary dictionaryWithObjectsAndKeys:
                                      self, NSNibOwner,
                                      topLevelObjs, NSNibTopLevelObjects,
                                      nil];
    
    if (![aBundle loadNibFile:@"micphoneView" externalNameTable:nameTable withZone:nil])
    {
        
    }
    
    micphoneView *myView = nil;
    
    for (id classtpye in topLevelObjs) {
        if ([classtpye isKindOfClass:[micphoneView class]]) {
            myView = classtpye;
        }
    }
    
    return myView;
}

#pragma mark - ButtonMethod
- (void)chooseMicphone:(SWSTAnswerButton *)sender
{
    NSArray *deviceArr = [appDelegate.evengine getDevices:EVDeviceAudioPlayback];
    EVDevice *device = deviceArr[sender.tag];
    [appDelegate.evengine setDevice:EVDeviceAudioPlayback withId:device.id];
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
