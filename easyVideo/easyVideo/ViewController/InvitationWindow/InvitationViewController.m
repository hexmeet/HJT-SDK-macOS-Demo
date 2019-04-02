//
//  InvitationViewController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/9/21.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "InvitationViewController.h"

@interface InvitationViewController ()
{
    EVCallInfo *callInfo;
    AppDelegate *appDelegate;
}
@end

@implementation InvitationViewController

@synthesize meetingName, joinBtn, joinBg, cancelBg, cancelBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self setRootViewAttribute];
    
    [self languageLocalization];
}

- (void)viewDidDisappear
{
    [super viewDidDisappear];
    // remove Notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:JOINMEETING object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CLOSEINVITATIONWINDOW object:nil];
}

- (void)setRootViewAttribute
{
    // Init SDK
    appDelegate = APPDELEGATE;
    
    [self.view setBackgroundColor:WHITECOLOR];
    [joinBg setBackgroundColor:HEXCOLOR(0x28c983)];
    joinBg.layer.cornerRadius = 4.f;
    [cancelBg setBackgroundColor:DEFAULREDCOLOR];
    cancelBg.layer.cornerRadius = 4.f;
    
    // add Observer Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(joinMeeting:) name:JOINMEETING object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeWindow) name:CLOSEINVITATIONWINDOW object:nil];
}

- (void)languageLocalization
{
    [LanguageTool initUserLanguage];
    [joinBtn changeCenterButtonattribute:localizationBundle(@"home.invitation.join") color:WHITECOLOR];
    [cancelBtn changeCenterButtonattribute:localizationBundle(@"home.invitation.cancel") color:WHITECOLOR];
}

#pragma mark - ButtonMethod
- (IBAction)buttonAction:(id)sender
{
    if (sender == cancelBtn) {
        // close the winodow
        [self.view.window close];
    }else if (sender == joinBtn) {
        [[NSNotificationCenter defaultCenter] postNotificationName:INVITATIONJOIN object:callInfo];
        [self.view.window close];
    }
}

- (IBAction)closeTheWindow:(id)sender
{
    [self.view.window close];
}

#pragma mark - Notification
- (void)joinMeeting:(NSNotification *)sender
{
    callInfo = sender.object;
    meetingName.stringValue = [NSString stringWithFormat:@"%@%@", localizationBundle(@"home.invited.Meeting"), callInfo.conference_number];
    
    //if user choose auto answer,the call auto answer.
    NSDictionary *infoDic = [PlistUtils loadUserInfoPlistFilewithFileName:SETINFO];
    if (infoDic[@"autoAnswer"]) {
        if ([infoDic[@"autoAnswer"] isEqualToString:@"YES"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:INVITATIONJOIN object:callInfo];
            [self.view.window close];
        }
    }
}

- (void)closeWindow
{
    [self.view.window close];
}

@end
