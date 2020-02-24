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
    RippleAnimationView *animationView;
}
@end

@implementation InvitationViewController

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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:INVITATIONIMG object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:JOINMEETING object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CLOSEINVITATIONWINDOW object:nil];
}

- (void)viewDidLayout
{
    [super viewDidLayout];
    
    animationView.frame = _callImg.frame;
    
    _callImg.wantsLayer = YES;
    _callImg.layer.cornerRadius = 70;
    
    _inviteBg.image = [EVUtils resizeImage:[NSImage imageNamed:@"bg_calling"] size:_inviteBg.frame.size];
}

- (void)setRootViewAttribute
{
    [EVUtils playSound];
    
    // Init SDK
    appDelegate = APPDELEGATE;
    
    [self.view setBackgroundColor:WHITECOLOR];
    
    if (!animationView) {
        animationView = [[RippleAnimationView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) animationType:AnimationTypeWithBackground];
        animationView.layer.masksToBounds = NO;
        animationView.frame = _callImg.frame;
    }
    [self.view addSubview:animationView positioned:NSWindowBelow relativeTo:_callImg];
    
    // add Observer Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(joinMeeting:) name:JOINMEETING object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(invitationImg:) name:INVITATIONIMG object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeWindow) name:CLOSEINVITATIONWINDOW object:nil];
}

- (void)languageLocalization
{
    [LanguageTool initUserLanguage];
    
    _joinVideoTitle.stringValue = localizationBundle(@"home.invitation.videojoin");
    _cancelTitle.stringValue = localizationBundle(@"home.invitation.cancel");
}

#pragma mark - ButtonMethod
- (IBAction)buttonAction:(id)sender
{
    [EVUtils stopSound];
    if (sender == _cancelBtn) {
        [appDelegate.evengine declineIncommingCall:callInfo.conference_number];
    }else if (sender == _joinBtn) {
        [[NSNotificationCenter defaultCenter] postNotificationName:INVITATIONJOIN object:callInfo];
        
    }
    [self.view.window close];
}

- (IBAction)closeTheWindow:(id)sender
{
    [EVUtils stopSound];
    [appDelegate.evengine declineIncommingCall:callInfo.conference_number];
    [self.view.window close];
}

#pragma mark - Notification
- (void)joinMeeting:(NSNotification *)sender
{
    callInfo = sender.object;
    _inviteName.stringValue = callInfo.peer;
    if (callInfo.svcCallType == EVSvcCallP2P) {
        _inviteTitle.stringValue = localizationBundle(@"home.invited.p2pinvited");
    }else {
        _inviteTitle.stringValue = [NSString stringWithFormat:@"%@%@", localizationBundle(@"home.invited.Meeting"), callInfo.conference_number];
    }
    
    //if user choose auto answer,the call auto answer.
    NSDictionary *infoDic = [PlistUtils loadUserInfoPlistFilewithFileName:SETINFO];
    if (infoDic[@"autoAnswer"]) {
        if ([infoDic[@"autoAnswer"] isEqualToString:@"YES"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:INVITATIONJOIN object:callInfo];
            [self.view.window close];
        }
    }
}

- (void)invitationImg:(NSNotification *)sender
{
    self.callImg.image = [[NSImage alloc]initWithContentsOfURL:[NSURL URLWithString:sender.object]];
    self.callImg.image = [EVUtils resizeImage:self.callImg.image size:self.callImg.frame.size];
}

- (void)closeWindow
{
    [EVUtils stopSound];

    [self.view.window close];
}

@end
