//
//  HomeViewController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/8/17.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "HomeViewController.h"
#import "UserWindowController.h"
#import "InvitationWindowController.h"
#import <AVFoundation/AVCaptureDevice.h>
#import "macHUD.h"

@interface HomeViewController ()<EVEngineDelegate>
{
    AppDelegate *appDelegate;
    macHUD *hub;
}
@end

@implementation HomeViewController

//Left Custom View
@synthesize leftMenuView, meetingline, setView, meetingView, setline, meetingViewImage, meetingViewTitle, meetingBtn, setViewImage, setViewTitle, setBtn, userImageBtn, userName, registerTitle, registerImage, closeBtn, miniBtn, fullBtn, chatBtn, chatViewImage, chatViewTitle, Chatline, ChatView, contactsBtn, contactsline, contactsView, contactsImage, contactsTitle;
//Top Custom View
@synthesize topMenuView, topMenuViewTitle;
//Other
@synthesize setContainerView, webContainerView, chatContainerView, contactsContainerView;
@synthesize chatConstraint, contactsConstraint, setConstraint;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    if ([[NSUSERDEFAULT objectForKey:@"isonce"] isEqualToString:@"YES"]) {
        [NSUSERDEFAULT setValue:@"NO" forKey:@"isonce"];
        [NSUSERDEFAULT synchronize];
        Notifications(LOGINGSUCCEED);
    }
    
    [self setRootViewAttribute];
    
    [self setLeftMenuViewAttribute];
    
    [self setTopMenuViewAttribute];
    
    [self languageLocalization];
    
    [self getUserInfo];
}

- (void)viewDidAppear
{
    [super viewDidAppear];
}

- (void)viewDidLayout
{
    [super viewDidLayout];
    hub.frame  = self.view.frame;
    hub.hidden = YES;
    self.view.window.title = infoPlistStringBundle(@"CFBundleName");
}

/**
 Set the RootView Attribute
 */
- (void)setRootViewAttribute
{
    hub = [macHUD creatMacHUD:@"" icon:@"" viewController:self];
    hub.hidden = YES;
    
    [meetingView setBackgroundColor:WHITECOLOR];
    meetingViewImage.image = [NSImage imageNamed:@"nav_meetings_c"];
    meetingViewTitle.textColor = BLUECOLOR;
    
    [ChatView setBackgroundColor:BLUECOLOR];
    chatViewImage.image = [NSImage imageNamed:@"nav_chat_n"];
    chatViewTitle.textColor = WHITECOLOR;
    
    [contactsView setBackgroundColor:BLUECOLOR];
    contactsImage.image = [NSImage imageNamed:@"nav_contacts_n"];
    contactsTitle.textColor = WHITECOLOR;
    
    [setView setBackgroundColor:BLUECOLOR];
    setViewImage.image = [NSImage imageNamed:@"nav_setting_n"];
    setViewTitle.textColor = WHITECOLOR;
    
    webContainerView.hidden = NO;
    chatContainerView.hidden = YES;
    contactsContainerView.hidden = YES;
    setContainerView.hidden = YES;
    
    [EVUtils saveNewLogWhenOldLogTooBig];
    
    [self.view setBackgroundColor:WHITECOLOR];
    webContainerView.hidden = NO;
    chatContainerView.hidden = YES;
    contactsContainerView.hidden = YES;
    setContainerView.hidden = YES;
    
    appDelegate = APPDELEGATE;
    [appDelegate.evengine setDelegate:self];
    
    NSString *downloadimagepath = [[EVUtils get_current_app_path]stringByAppendingPathComponent:@"header.jpg"];
    userImageBtn.image = [[NSImage alloc]initWithContentsOfFile:downloadimagepath];
//    [self performSelector:@selector(getuserImage) withObject:self afterDelay:3];
    
    userImageBtn.wantsLayer = YES;
    userImageBtn.layer.cornerRadius = 25;
    
    ///hidden chatView
    ChatView.hidden = YES;
    
    if ([EVUtils queryUserPlist:@"contactWebPage"]) {
        //包含联系人
        contactsConstraint.constant = 63;
        setConstraint.constant = 118;
    }else {
        //不包含联系人
        contactsView.hidden = YES;
        setConstraint.constant = 63;
    }
}

/**
 Set the LeftMenuView Attribute
 */
- (void)setLeftMenuViewAttribute
{
    [leftMenuView setBackgroundColor:BLUECOLOR];
    [meetingView setBackgroundColor:WHITECOLOR];
    [meetingline setBackgroundColor:BLUECOLOR];
    [ChatView setBackgroundColor:BLUECOLOR];
    [Chatline setBackgroundColor:BLUECOLOR];
    [contactsView setBackgroundColor:BLUECOLOR];
    [contactsline setBackgroundColor:BLUECOLOR];
    [setView setBackgroundColor:BLUECOLOR];
    [setline setBackgroundColor:BLUECOLOR];
}

/**
 Set the TopMenuView Attribute
 */
- (void)setTopMenuViewAttribute
{
    [topMenuView setBackgroundColor:[NSColor whiteColor]];
    [topMenuView setAddshadow];
}

/**
 Language localization
 */
- (void)languageLocalization
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage:) name:CHANGELANGUAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clouseHomeWindow) name:CLOSEHOMEWINDOW object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clouseDisplayName) name:CHANGEDISPLAYNAME object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upladImage) name:UPLOADIMAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut:) name:LOGINGOUT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registered:) name:REGISTERED object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterFull:)name:NSWindowWillEnterFullScreenNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(willExitFull:)name:NSWindowWillExitFullScreenNotification object:nil];
    
    //初始化应用语言
    [LanguageTool initUserLanguage];
    
    meetingViewTitle.stringValue = localizationBundle(@"home.left.meetingtitle");
    chatViewTitle.stringValue = localizationBundle(@"home.left.chattitle");
    contactsTitle.stringValue = localizationBundle(@"home.left.contactstitle");
    setViewTitle.stringValue     = localizationBundle(@"home.left.settitle");
    registerTitle.stringValue    = localizationBundle(@"home.left.registeredtitle");
    [registerTitle sizeToFit];
    if (registerTitle.stringValue.length != 3) {
        registerTitle.font = [NSFont systemFontOfSize:11];
    }else{
        registerTitle.font = [NSFont systemFontOfSize:14];
    }
    topMenuViewTitle.stringValue = localizationBundle(@"home.top.servertitle");
}

- (void)getUserInfo
{
    NSDictionary *setInfo = [PlistUtils loadUserInfoPlistFilewithFileName:SETINFO];
    if ([setInfo[@"iscloudLogin"]isEqualToString:@"YES"]) {
        NSDictionary *userinfo = [PlistUtils loadUserInfoPlistFilewithFileName:CLOUDUSERINFO];
        userName.stringValue = userinfo[@"displayName"];
    }else {
        NSDictionary *userinfo = [PlistUtils loadUserInfoPlistFilewithFileName:PRIVATEUSERINFO];
        userName.stringValue = userinfo[@"displayName"];
    }
}

#pragma mark - NSButtonMethod
- (IBAction)hideWindow:(id)sender
{
    [[NSApplication sharedApplication] hide:self];
}

- (IBAction)miniaturizeWindow:(id)sender
{
    [self.view.window miniaturize:self];
}

- (IBAction)zoomWindow:(id)sender {
    [self.view.window toggleFullScreen:self];
}

/**
 left MenuBtn Action

 @param sender NSButton
 */
- (IBAction)leftMenuBtnAction:(id)sender
{
    if (sender == meetingBtn) {
        [meetingView setBackgroundColor:WHITECOLOR];
        meetingViewImage.image = [NSImage imageNamed:@"nav_meetings_c"];
        meetingViewTitle.textColor = BLUECOLOR;
        
        [ChatView setBackgroundColor:BLUECOLOR];
        chatViewImage.image = [NSImage imageNamed:@"nav_chat_n"];
        chatViewTitle.textColor = WHITECOLOR;
        
        [contactsView setBackgroundColor:BLUECOLOR];
        contactsImage.image = [NSImage imageNamed:@"nav_contacts_n"];
        contactsTitle.textColor = WHITECOLOR;
        
        [setView setBackgroundColor:BLUECOLOR];
        setViewImage.image = [NSImage imageNamed:@"nav_setting_n"];
        setViewTitle.textColor = WHITECOLOR;
        
        webContainerView.hidden = NO;
        chatContainerView.hidden = YES;
        contactsContainerView.hidden = YES;
        setContainerView.hidden = YES;
    }else if (sender == chatBtn) {
        [meetingView setBackgroundColor:BLUECOLOR];
        meetingViewImage.image = [NSImage imageNamed:@"nav_meetings_n"];
        meetingViewTitle.textColor = WHITECOLOR;
        
        [ChatView setBackgroundColor:WHITECOLOR];
        chatViewImage.image = [NSImage imageNamed:@"nav_chat_c"];
        chatViewTitle.textColor = BLUECOLOR;
        
        [contactsView setBackgroundColor:BLUECOLOR];
        contactsImage.image = [NSImage imageNamed:@"nav_contacts_n"];
        contactsTitle.textColor = WHITECOLOR;
        
        [setView setBackgroundColor:BLUECOLOR];
        setViewImage.image = [NSImage imageNamed:@"nav_setting_n"];
        setViewTitle.textColor = WHITECOLOR;
        
        webContainerView.hidden = YES;
        chatContainerView.hidden = NO;
        contactsContainerView.hidden = YES;
        setContainerView.hidden = YES;
    }else if (sender == contactsBtn) {
        [meetingView setBackgroundColor:BLUECOLOR];
        meetingViewImage.image = [NSImage imageNamed:@"nav_meetings_n"];
        meetingViewTitle.textColor = WHITECOLOR;
        
        [ChatView setBackgroundColor:BLUECOLOR];
        chatViewImage.image = [NSImage imageNamed:@"nav_chat_n"];
        chatViewTitle.textColor = WHITECOLOR;
        
        [contactsView setBackgroundColor:WHITECOLOR];
        contactsImage.image = [NSImage imageNamed:@"nav_contacts_c"];
        contactsTitle.textColor = BLUECOLOR;
        
        [setView setBackgroundColor:BLUECOLOR];
        setViewImage.image = [NSImage imageNamed:@"nav_setting_n"];
        setViewTitle.textColor = WHITECOLOR;
        
        webContainerView.hidden = YES;
        chatContainerView.hidden = YES;
        contactsContainerView.hidden = NO;
        setContainerView.hidden = YES;
    }else if (sender == setBtn) {
        [meetingView setBackgroundColor:BLUECOLOR];
        meetingViewImage.image = [NSImage imageNamed:@"nav_meetings_n"];
        meetingViewTitle.textColor = WHITECOLOR;
        
        [ChatView setBackgroundColor:BLUECOLOR];
        chatViewImage.image = [NSImage imageNamed:@"nav_chat_n"];
        chatViewTitle.textColor = WHITECOLOR;
        
        [contactsView setBackgroundColor:BLUECOLOR];
        contactsImage.image = [NSImage imageNamed:@"nav_contacts_n"];
        contactsTitle.textColor = WHITECOLOR;
        
        [setView setBackgroundColor:WHITECOLOR];
        setViewImage.image = [NSImage imageNamed:@"nav_setting_c"];
        setViewTitle.textColor = BLUECOLOR;
        
        webContainerView.hidden = YES;
        chatContainerView.hidden = YES;
        contactsContainerView.hidden = YES;
        setContainerView.hidden = NO;
    }
}

/**
 change user info

 @param sender userImageBtn
 */
- (IBAction)userImageBtnAction:(id)sender
{
    Notifications(CLOSEUSERWINDOW);
    
    UserWindowController* windowControl = [UserWindowController windowController];
    
    [windowControl.window makeKeyAndOrderFront:self];
    
}
- (IBAction)myselfAction:(id)sender
{
    EVUserInfo *userInfo = [appDelegate.evengine getUserInfo];
    DDLogInfo(@"[Info] 10046 My self Server URL:%@", [NSString stringWithFormat:@"%@/mymeetings/?token=%@", userInfo.customizedH5UrlPrefix, userInfo.token]);
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/mymeetings/?token=%@", userInfo.customizedH5UrlPrefix, userInfo.token]]];
}

#pragma mark - Notification
/**
 Toggle language
 
 @param sender Notification
 */
- (void)changeLanguage:(NSNotification *)sender
{
    meetingViewTitle.stringValue = localizationBundle(@"home.left.meetingtitle");
    chatViewTitle.stringValue = localizationBundle(@"home.left.chattitle");
    contactsTitle.stringValue = localizationBundle(@"home.left.contactstitle");
    setViewTitle.stringValue     = localizationBundle(@"home.left.settitle");
    registerTitle.stringValue    = localizationBundle(@"home.left.registeredtitle");
    [registerTitle sizeToFit];
    if (registerTitle.stringValue.length != 3) {
        registerTitle.font = [NSFont systemFontOfSize:11];
    }else{
        registerTitle.font = [NSFont systemFontOfSize:14];
    }
    topMenuViewTitle.stringValue = localizationBundle(@"home.top.servertitle");
}

- (void)clouseHomeWindow
{
    [self.view.window close];
}

- (void)clouseDisplayName
{
    [self getUserInfo];
}

- (void)upladImage
{
    NSString *downloadimagepath = [[EVUtils get_current_app_path]stringByAppendingPathComponent:@"header.jpg"];
    userImageBtn.image = [[NSImage alloc]initWithContentsOfFile:downloadimagepath];
}

- (void)loginOut:(NSNotification *)sender
{
    NSDictionary *dic = sender.object;
    appDelegate.islogin = NO;

    [appDelegate.evengine logout];

    [[NSNotificationCenter defaultCenter] postNotificationName:SHOWLOGINWINDOW object:dic];
    Notifications(CLOSEHOMEWINDOW);
    Notifications(CLOSEPDWINDOW);
    Notifications(CLOSEJOINWINDOW);
    Notifications(CLOSEHEADIMAGEWINDOW);
    Notifications(CLOSEMEETINGWEBWINDOW);
    Notifications(CLOSEPASSWORDWINDOW);
    Notifications(CLOSEINVITATIONWINDOW);

    HLog(@"[LogOut]");

    [self.view.window close];
//    NSAlert *alert = [NSAlert new];
//    [alert addButtonWithTitle:localizationBundle(@"alert.sure")];
//    [alert addButtonWithTitle:localizationBundle(@"alert.cancel")];
//    [alert setMessageText:localizationBundle(@"alert.error")];
//    [alert setInformativeText:localizationBundle(@"alert.serverisinconsistent")];
//    [alert setAlertStyle:NSAlertStyleInformational];
//    [alert beginSheetModalForWindow:[self.view window] completionHandler:^(NSModalResponse returnCode) {
//        if(returnCode == NSAlertFirstButtonReturn){
//
//        }else if(returnCode == NSAlertSecondButtonReturn){
//
//        }
//    }];
}

- (void)registered:(NSNotification *)sender
{
    NSString *registered = sender.object;
    if ([registered isEqualToString:@"1"]) {
        self->registerImage.image = [NSImage imageNamed:@"status_success"];
        self->registerTitle.stringValue = localizationBundle(@"home.left.registeredtitle");
    }else {
        self->registerImage.image = [NSImage imageNamed:@"status_fail"];
        self->registerTitle.stringValue = localizationBundle(@"home.left.noregisteredtitle");
    }
}

- (void)willEnterFull:(NSNotification*)notification{
    closeBtn.hidden = YES;
    miniBtn.hidden  = YES;
    fullBtn.hidden  = YES;
    Notifications(CLOSEJOINWINDOW);
}

- (void)willExitFull:(NSNotification*)notification {
    closeBtn.hidden = NO;
    miniBtn.hidden  = NO;
    fullBtn.hidden  = NO;
    Notifications(CLOSEJOINWINDOW);
}

#pragma mark - HIDDENHUD
- (void)persendMethod:(NSInteger)time
{
    [self performSelector:@selector(hiddenHUD) withObject:self afterDelay:time];
}

- (void)hiddenHUD
{
    hub.hidden = YES;
}

#pragma mark - EVEngineDelegate
- (void)onDownloadUserImageComplete:(NSString *)path {
    DDLogInfo(@"[Info]evsdk-macos: onDownloadUserImageComplete path: %@", path);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSImage *image = [[NSImage alloc]initWithContentsOfFile:path];
        self->userImageBtn.image = image;
    });
}

- (void)onError:(EVError *)err {
    DDLogError(@"[Error]: onError type: %lu, code%du,  msg: %@", (unsigned long)err.type, err.code, err.msg);
}

- (void)onRegister:(BOOL)registered
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (registered) {
            self->registerImage.image = [NSImage imageNamed:@"status_success"];
            self->registerTitle.stringValue = localizationBundle(@"home.left.registeredtitle");
            DDLogInfo(@"[UI] 注册成功");
        }else {
            self->registerImage.image = [NSImage imageNamed:@"status_fail"];
            self->registerTitle.stringValue = localizationBundle(@"home.left.noregisteredtitle");
            DDLogInfo(@"[UI] 注册失败");
        }
    });
}

- (void)onJoinConferenceIndication:(EVCallInfo *_Nonnull)info
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableDictionary *setDic = [NSMutableDictionary dictionaryWithDictionary:[PlistUtils loadUserInfoPlistFilewithFileName:SETINFO]];
        if (info.svcCallType == EVSvcCallP2P) {
            [setDic setValue:info.conference_number forKey:@"confId"];
            [setDic setValue:@"p2p" forKey:@"conftype"];
        }else {
            [setDic setValue:info.conference_number forKey:@"confId"];
            [setDic setValue:@"conf" forKey:@"conftype"];
        }
        [PlistUtils saveUserInfoPlistFile:(NSDictionary *)setDic withFileName:SETINFO];
        if (info.svcCallAction == EVSvcIncomingCallRing) {
            [EVUtils playSound];
            InvitationWindowController* invitation = [InvitationWindowController windowController];
            [invitation.window orderFront:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:JOINMEETING object:info];
        }else{
            [EVUtils stopSound];
            [self->appDelegate.evengine declineIncommingCall:info.conference_number];
            Notifications(CLOSEINVITATIONWINDOW);
        }
        
    });
}

- (void)onPeerImageUrl:(NSString *)imageUrl
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:INVITATIONIMG object:imageUrl];
    });
}

- (void)getuserImage
{
    NSString *downloadimagepath = [[EVUtils get_current_app_path]stringByAppendingPathComponent:@"header.jpg"];
    [appDelegate.evengine downloadUserImage:downloadimagepath];
    userImageBtn.image = [[NSImage alloc]initWithContentsOfFile:downloadimagepath];
    [appDelegate.evengine setUserImage:[EVUtils bundleFile:@"bg_videomute.png"] filename:downloadimagepath];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CHANGELANGUAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CLOSEHOMEWINDOW object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CHANGEDISPLAYNAME object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UPLOADIMAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:REGISTERED object:nil];
}

@end
