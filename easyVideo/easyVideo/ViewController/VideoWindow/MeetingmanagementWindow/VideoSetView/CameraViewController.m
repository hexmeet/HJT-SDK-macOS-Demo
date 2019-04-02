//
//  CameraViewController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/9/10.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "CameraViewController.h"
#import "cameraView.h"
#import "SWSTAnswerButton.h"
#import "macHUD.h"

@interface CameraViewController ()
{
    AppDelegate *appDelegate;
    macHUD *hub;
}
@end

@implementation CameraViewController

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
    
    NSArray *deviceArr = [appDelegate.evengine getDevices:EVDeviceVideoCapture];
    EVDevice *selectDevice = [appDelegate.evengine getDevice:EVDeviceVideoCapture];
    if (deviceArr.count == 1) {
        EVDevice *device = deviceArr[0];
        cameraView *camera = [self creatCameraView];
        camera.frame = CGRectMake(144, 0, 143, 224);
        camera.selectBtn.tag = 0;
        camera.selectImage.hidden = NO;
        camera.cameraName.stringValue = device.name;
        [camera.selectBtn setTarget:self];
        [camera.selectBtn setAction:@selector(chooseCamera:)];
        scrollViewConstraint.constant = 143;
        [scrollView.contentView addSubview:camera];
    }else if (deviceArr.count == 2) {
        for (int i = 0; i<deviceArr.count; i++) {
            EVDevice *device = deviceArr[i];
            cameraView *camera = [self creatCameraView];
            if ([device.name isEqualToString:selectDevice.name]) {
                camera.selectImage.hidden = NO;
            }
            camera.frame = CGRectMake(143*i+72, 0, 143, 224);
            camera.selectBtn.tag = i;
            camera.cameraName.stringValue = device.name;
            [camera.selectBtn setTarget:self];
            [camera.selectBtn setAction:@selector(chooseCamera:)];
            scrollViewConstraint.constant = 143*i;
            [scrollView.contentView addSubview:camera];
        }
    }else {
        for (int i = 0; i<deviceArr.count; i++) {
            EVDevice *device = deviceArr[i];
            cameraView *camera = [self creatCameraView];
            if ([device.name isEqualToString:selectDevice.name]) {
                camera.selectImage.hidden = NO;
            }
            camera.frame = CGRectMake(143*i, 0, 143, 224);
            camera.selectBtn.tag = i;
            camera.cameraName.stringValue = device.name;
            [camera.selectBtn setTarget:self];
            [camera.selectBtn setAction:@selector(chooseCamera:)];
            scrollViewConstraint.constant = 143*i;
            [scrollView.contentView addSubview:camera];
        }
    }
}

- (cameraView *)creatCameraView
{
    NSBundle*            aBundle = [NSBundle mainBundle];
    NSMutableArray*      topLevelObjs = [NSMutableArray array];
    NSDictionary*        nameTable = [NSDictionary dictionaryWithObjectsAndKeys:
                                      self, NSNibOwner,
                                      topLevelObjs, NSNibTopLevelObjects,
                                      nil];
    
    if (![aBundle loadNibFile:@"cameraView" externalNameTable:nameTable withZone:nil])
    {
        
    }
    
    cameraView *myView = nil;
    
    for (id classtpye in topLevelObjs) {
        if ([classtpye isKindOfClass:[cameraView class]]) {
            myView = classtpye;
        }
    }
    
    return myView;
}

#pragma mark - ButtonMethod
- (void)chooseCamera:(SWSTAnswerButton *)sender
{
    NSArray *deviceArr = [appDelegate.evengine getDevices:EVDeviceVideoCapture];
    EVDevice *device = deviceArr[sender.tag];
    [appDelegate.evengine setDevice:EVDeviceVideoCapture withId:device.id];
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
