//
//  JoinWindowViewController.m
//  easyVideo
//
//  Created by quanhao huang on 2019/8/13.
//  Copyright © 2019 easyVideo. All rights reserved.
//

#import "JoinWindowViewController.h"

@interface JoinWindowViewController ()<EVEngineDelegate>
{
    AppDelegate *appDelegate;
}
@end

@implementation JoinWindowViewController

@synthesize meetingDic, meetingNumber, displayNameTF, cancelBtn, joinBtn, microphoneBtn, cameraBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self.view setBackgroundColor:WHITECOLOR];
    
    displayNameTF.focusRingType = NSFocusRingTypeNone;
    
    appDelegate = APPDELEGATE;
    
    [joinBtn changeCenterButtonattribute:localizationBundle(@"login.window.join") color:WHITECOLOR];
    [cancelBtn changeCenterButtonattribute:localizationBundle(@"alert.cancel") color:TITLECOLOR];
    [microphoneBtn changeLeftButtonattribute:localizationBundle(@"home.join.mute") color:BLACKCOLOR];
    [cameraBtn changeLeftButtonattribute:localizationBundle(@"home.join.camera") color:BLACKCOLOR];
    displayNameTF.placeholderString = localizationBundle(@"login.window.displayname");
    
    NSDictionary *setDic = [PlistUtils loadUserInfoPlistFilewithFileName:SETINFO];
    //open the camera
    if (setDic[@"camera"]) {
        if ([setDic[@"camera"] isEqualToString:@"YES"]) {
            cameraBtn.state = NSOnState;
        }else {
            cameraBtn.state = NSOffState;
        }
    }
    //open the micphone
    if (setDic[@"mute"]) {
        if ([setDic[@"mute"] isEqualToString:@"YES"]) {
            microphoneBtn.state = NSOnState;
        }else {
            microphoneBtn.state = NSOffState;
        }
    }
    //user name
    NSString *displaynameStr = [NSUSERDEFAULT objectForKey:@"DISPLAYNAME"];
    if (displaynameStr) {
        displayNameTF.stringValue = displaynameStr;
    }
}

- (void)setInfo
{
    meetingNumber.stringValue = [NSString stringWithFormat:@"%@ %@", localizationBundle(@"home.joinmeeting"), meetingDic[@"confid"]];
}

- (IBAction)backAction:(id)sender
{
     [self.view.window close];
}

- (IBAction)buttonAction:(id)sender
{
    if (sender == cancelBtn) {
         [self.view.window close];
    }else if (sender == joinBtn) {
        NSString *displayname = displayNameTF.stringValue;
        if (displayname.length == 0) {
            displayname = [EVUtils judgeString:NSUserName()];
        }
        if ([meetingDic[@"protocol"] isEqualToString:@"http"]) {
            [appDelegate.evengine enableSecure:NO];
        }else {
            [appDelegate.evengine enableSecure:YES];
        }
        [NSUSERDEFAULT setValue:@"YES" forKey:@"anonymous"];
        [NSUSERDEFAULT synchronize];
        [NSUSERDEFAULT setObject:displayNameTF.stringValue forKey:@"DISPLAYNAME"];
        [NSUSERDEFAULT synchronize];
        [appDelegate.evengine setDelegate:self];
        Notifications(OPENVIDEO);
        [appDelegate.evengine setUserImage:[EVUtils bundleFile:@"bg_videomute.png"] filename:[EVUtils bundleFile:@"image_defaultuser.png"]];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:meetingDic[@"server"] forKey:@"server"];
        [dic setValue:meetingDic[@"port"] forKey:@"port"];
        [dic setValue:displayname forKey:@"disName"];
        [dic setValue:meetingDic[@"confid"] forKey:@"confId"];
        [dic setValue:meetingDic[@"password"] forKey:@"password"];
        [[NSNotificationCenter defaultCenter] postNotificationName:ANONYMOUSLOCATIONLOGIN object:dic];
        
        [self.view.window close];

    }else if (sender == microphoneBtn) {
        NSMutableDictionary *setDic = [NSMutableDictionary dictionaryWithDictionary:[PlistUtils loadUserInfoPlistFilewithFileName:SETINFO]];
        if (microphoneBtn.state == NSOnState) {
            [setDic setValue:@"YES" forKey:@"mute"];
        }else {
            [setDic setValue:@"NO" forKey:@"mute"];
        }
        [PlistUtils saveUserInfoPlistFile:(NSDictionary *)setDic withFileName:SETINFO];
    }else if (sender == cameraBtn) {
        NSMutableDictionary *setDic = [NSMutableDictionary dictionaryWithDictionary:[PlistUtils loadUserInfoPlistFilewithFileName:SETINFO]];
        if (cameraBtn.state == NSOnState) {
            [setDic setValue:@"YES" forKey:@"camera"];
        }else {
            [setDic setValue:@"NO" forKey:@"camera"];
        }
        [PlistUtils saveUserInfoPlistFile:(NSDictionary *)setDic withFileName:SETINFO];
    }
}

@end
