//
//  JoinMeetingViewController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/8/24.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "JoinMeetingViewController.h"
#import "VideoHomeWindowController.h"
#import "ConnectingWindowController.h"
#import "LocalWindowController.h"
#import "PasswordWindowController.h"
#import "InvitationWindowController.h"
#import "CustomCell.h"
#import "macHUD.h"

@interface JoinMeetingViewController ()<EVEngineDelegate, NSTableViewDelegate, NSTableViewDataSource>
{
    AppDelegate *appDelegate;
    VideoHomeWindowController *windowControl;
    LocalWindowController *localWindow;
    macHUD *hub;
    EVCallInfo *callInfo;
    NSString *webpasswordStr;
    NSMutableDictionary *anonymousDic;
    NSMutableArray * _dataArray;
    NSString *confIdStr;
    NSString *displayName;
    BOOL isshow;
    BOOL issetVideo;
    BOOL iscanchoose;
}

@end

@implementation JoinMeetingViewController

@synthesize joinMeetingTitle, accoutTF, passwordTF, loginViewBg, loginBtn, videoBtn, muteBtn, tab, tabBg;

- (void)viewWillDisappear
{
    [super viewWillDisappear];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self setRootViewAttribute];
    
    [self languageLocalization];
    
    [self getUserSet];
}

- (void)setRootViewAttribute
{
    isshow = NO;
    issetVideo = NO;
    iscanchoose = YES;
    
    webpasswordStr = @"";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(anonymousLogin:) name:ANONYMOUSLOGIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(anonymouslocationLogin:) name:ANONYMOUSLOCATIONLOGIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webJoinAction:) name:WEBJOIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeVideo) name:REMOVEVIDEO object:nil];
    
    //histroy call number Array
    _dataArray = [NSMutableArray array];
    NSArray *arrayDate = [NSUSERDEFAULT objectForKey:@"HISTORYCALL"];
    if (arrayDate) {
        [_dataArray addObjectsFromArray:arrayDate];
    }
    
    tabBg.hidden = YES;
    
    [self.view setBackgroundColor:WHITECOLOR];
    
    accoutTF.focusRingType = NSFocusRingTypeNone;
    passwordTF.focusRingType = NSFocusRingTypeNone;
    
    [loginViewBg setBackgroundColor:BLUECOLOR];
    loginViewBg.layer.cornerRadius = 4.;
    
    appDelegate = APPDELEGATE;
    [appDelegate.evengine setDelegate:self];
    
    tab.delegate = self;
    tab.dataSource = self;
    tab.rowHeight = 24;
    tab.usesAlternatingRowBackgroundColors = YES;
    tab.selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone;
    
    hub = [macHUD creatMacHUD:@"" icon:@"" viewController:self];
    hub.hidden = YES;
    
    NSTrackingArea *area = [[NSTrackingArea alloc] initWithRect:accoutTF.bounds options:NSTrackingMouseEnteredAndExited|NSTrackingActiveInKeyWindow owner:self userInfo:nil];
    [accoutTF addTrackingArea:area];
}

/**
 Language localization
 */
- (void)languageLocalization
{
    //addobserver notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage:) name:CHANGELANGUAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeJoinWindow) name:CLOSEJOINWINDOW object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelCall) name:CANCELCALL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(joinconfId:) name:JOINCONFID object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMeetingpassword:) name:MEETINGPASSWORD object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(invitationJoin:) name:INVITATIONJOIN object:nil];
    
    [LanguageTool initUserLanguage];
    
    [loginBtn changeCenterButtonattribute:localizationBundle(@"login.window.join") color:WHITECOLOR];
    [videoBtn changeLeftButtonattribute:localizationBundle(@"home.join.camera") color:BLACKCOLOR];
    [muteBtn changeLeftButtonattribute:localizationBundle(@"home.join.mute") color:BLACKCOLOR];
    
    joinMeetingTitle.stringValue = localizationBundle(@"login.window.join.meeting");
    accoutTF.placeholderString = localizationBundle(@"home.joinmeetinginput");
    passwordTF.placeholderString = localizationBundle(@"alert.writeDisName");
}

//get user set info
- (void)getUserSet
{
    NSDictionary *setDic = [PlistUtils loadUserInfoPlistFilewithFileName:SETINFO];
    //open the camera
    if (setDic[@"camera"]) {
        if ([setDic[@"camera"] isEqualToString:@"YES"]) {
            videoBtn.state = NSOnState;
        }else {
            videoBtn.state = NSOffState;
        }
    }
    //open the micphone
    if (setDic[@"mute"]) {
        if ([setDic[@"mute"] isEqualToString:@"YES"]) {
            muteBtn.state = NSOnState;
        }else {
            muteBtn.state = NSOffState;
        }
    }
}

#pragma mark - mouseEnter
//if user mouse down, the tabel hidden
- (void)mouseDown:(NSEvent *)event
{
    tabBg.hidden = YES;
    isshow = NO;
}

//register the tabel cell
-(void)awakeFromNib{
    [tab registerNib:[[NSNib alloc] initWithNibNamed:@"CustomCell" bundle:nil] forIdentifier:@"customCell"];
}

#pragma mark table delegate
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return _dataArray.count;
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    return [_dataArray objectAtIndex:row];
}

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    CustomCell *cellView = [tableView makeViewWithIdentifier:@"customCell" owner:self];
    cellView.test.stringValue = _dataArray[row];
    [cellView.line setBackgroundColor:[NSColor lightGrayColor]];
    [cellView setDeleteBlock:^{
        //delete
        [self->_dataArray removeObjectAtIndex:row];
        [NSUSERDEFAULT setValue:self->_dataArray forKey:@"HISTORYCALL"];
        [NSUSERDEFAULT synchronize];
        [self->tab reloadData];
    }];
    [cellView setSelectBlock:^(NSString * _Nonnull confId) {
        self.accoutTF.stringValue = confId;
        self->tabBg.hidden = YES;
        self->isshow = NO;
    }];
    return cellView;
}

//选中的响应
-(void)tableViewSelectionDidChange:(nonnull NSNotification *)notification{
    CustomCell *tableView = notification.object;
    accoutTF.stringValue = tableView.test.stringValue;
    tabBg.hidden = YES;
}

#pragma mark - NSButtonMethod
- (IBAction)closeWindow:(id)sender
{
    [self.view.window orderOut:nil];
}

- (IBAction)buttonMethod:(id)sender
{
    [appDelegate.evengine setDelegate:self];
    if (sender == videoBtn) {
        NSMutableDictionary *setDic = [NSMutableDictionary dictionaryWithDictionary:[PlistUtils loadUserInfoPlistFilewithFileName:SETINFO]];
        if (videoBtn.state == NSOnState) {
            [setDic setValue:@"YES" forKey:@"camera"];
        }else {
            [setDic setValue:@"NO" forKey:@"camera"];
        }
        [PlistUtils saveUserInfoPlistFile:(NSDictionary *)setDic withFileName:SETINFO];
    }else if (sender == muteBtn) {
        NSMutableDictionary *setDic = [NSMutableDictionary dictionaryWithDictionary:[PlistUtils loadUserInfoPlistFilewithFileName:SETINFO]];
        if (muteBtn.state == NSOnState) {
            [setDic setValue:@"YES" forKey:@"mute"];
        }else {
            [setDic setValue:@"NO" forKey:@"mute"];
        }
        [PlistUtils saveUserInfoPlistFile:(NSDictionary *)setDic withFileName:SETINFO];
    }else if (sender == loginBtn) {
        
        confIdStr = [EVUtils removeTheStringBlankSpace:accoutTF.stringValue];
        if (confIdStr.length == 0) {
            return;
        }
        
        NSString *passwordStr;
        if([confIdStr rangeOfString:@"*"].location != NSNotFound)
        {
            NSArray*array = [confIdStr componentsSeparatedByString:@"*"];
            confIdStr     = [array firstObject];
            passwordStr   = [array lastObject];
        }
        else
        {
            passwordStr = @"";
        }
        if (webpasswordStr.length != 0) {
            passwordStr = webpasswordStr;
        }
        displayName = [EVUtils removeTheStringBlankSpace:passwordTF.stringValue];
        
        [NSUSERDEFAULT setValue:@"NO" forKey:@"anonymous"];
        [NSUSERDEFAULT synchronize];
        
        NSMutableDictionary *setDic = [NSMutableDictionary dictionaryWithDictionary:[PlistUtils loadUserInfoPlistFilewithFileName:SETINFO]];
        [setDic setValue:confIdStr forKey:@"confId"];
        [PlistUtils saveUserInfoPlistFile:(NSDictionary *)setDic withFileName:SETINFO];
        DDLogInfo(@"[Info] 10011 user join meeting Numberinfo:confId:%@, displayName:%@, password:%@", confIdStr, displayName, passwordStr);
        NSString *downloadimagepath = [[EVUtils get_current_app_path]stringByAppendingPathComponent:@"header.jpg"];
        [appDelegate.evengine setUserImage:[EVUtils bundleFile:@"bg_videomute.png"] filename:downloadimagepath];
        [appDelegate.evengine joinConference:confIdStr display_name:displayName password:passwordStr];
        
        hub.hidden = NO;
        hub.hudTitleFd.stringValue = localizationBundle(@"alert.connection");
        
        NSMutableArray *mutablearrayDate = [NSMutableArray arrayWithCapacity:1];
        NSArray *arrayDate = [NSUSERDEFAULT objectForKey:@"HISTORYCALL"];
        [mutablearrayDate addObjectsFromArray:arrayDate];
        if (mutablearrayDate.count<5) {
            BOOL isneedRemovelastObj = YES;
            for (int i = 0; i<mutablearrayDate.count; i++) {
                if ([accoutTF.stringValue isEqualToString:mutablearrayDate[i]]) {
                    [mutablearrayDate removeObjectAtIndex:i];
                    [mutablearrayDate insertObject:accoutTF.stringValue atIndex:0];
                    isneedRemovelastObj = NO;
                }
            }
            if (isneedRemovelastObj) {
                [mutablearrayDate insertObject:accoutTF.stringValue atIndex:0];
            }

            [NSUSERDEFAULT setValue:mutablearrayDate forKey:@"HISTORYCALL"];
            [NSUSERDEFAULT synchronize];
        }else {
            BOOL isneedRemovelastObj = YES;
            for (int i = 0; i<mutablearrayDate.count; i++) {
                if ([accoutTF.stringValue isEqualToString:mutablearrayDate[i]]) {
                    [mutablearrayDate removeObjectAtIndex:i];
                    [mutablearrayDate insertObject:accoutTF.stringValue atIndex:0];
                    isneedRemovelastObj = NO;
                }
            }
            if (isneedRemovelastObj) {
                [mutablearrayDate removeLastObject];
                [mutablearrayDate insertObject:accoutTF.stringValue atIndex:0];
            }

            [NSUSERDEFAULT setValue:mutablearrayDate forKey:@"HISTORYCALL"];
            [NSUSERDEFAULT synchronize];
        }
        
        ConnectingWindowController *connectingWindow = [ConnectingWindowController windowController];
        appDelegate.mainWindowController = connectingWindow;
        [connectingWindow.window orderFront:nil];
        
        if (!issetVideo) {
            DDLogInfo(@"[Info] 10031 Start Video");
            Notifications(CLOSELOCALWINDOW);
            localWindow = [LocalWindowController windowController];
            Notifications(CLOSEVIDEOHOMEWINDOW);
            windowControl = [VideoHomeWindowController windowController];
            issetVideo = YES;
        }
    }
}

- (IBAction)showOrhiddenTab:(id)sender
{
    if (!iscanchoose) {
        return;
    }
    isshow = !isshow;
    [_dataArray removeAllObjects];
    NSArray *arrayDate = [NSUSERDEFAULT objectForKey:@"HISTORYCALL"];
    if (arrayDate) {
        [_dataArray addObjectsFromArray:arrayDate];
    }
    if (isshow) {
        tabBg.hidden = NO;
    }else {
        tabBg.hidden = YES;
    }
    [tab reloadData];
}

#pragma mark - EVEngineDelegate
- (void)onError:(EVError *)err
{
    dispatch_async(dispatch_get_main_queue(), ^{
        DDLogError(@"[Error] 10029 User anonymous logins error: type: %lu, code: %u, msg: %@", (unsigned long)err.type, err.code, err.msg);
        //错误后直接关闭呼叫窗口
        Notifications(CLOSECONNECTINGWINDOW);
        [[NSNotificationCenter defaultCenter] postNotificationName:PORTMPT object:[NSString stringWithFormat:@"%lu", (unsigned long)err.code]];
    });
}

- (void)onLoginSucceed:(EVUserInfo *)user {
    dispatch_async(dispatch_get_main_queue(), ^{
        Notifications(UPDATETOKEN);
        if ([[NSUSERDEFAULT objectForKey:@"anonymous"] isEqualToString:@"YES"]) {
            Notifications(CLOSECONNECTINGWINDOW);
            DDLogInfo(@"[Info] 10030 User anonymous logins successful username:%@, displayName: %@, org: %@, cellphone: %@, email: %@", user.username, user.displayName, user.org, user.cellphone, user.email);
            ConnectingWindowController *connectingWindow = [ConnectingWindowController windowController];
            self->appDelegate.mainWindowController = connectingWindow;
            [connectingWindow.window orderFront:nil];
            
        }
    });
}

- (void)onCallConnected:(EVCallInfo * _Nonnull)info
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self->hub.hidden = YES;
        Notifications(CLOSEHOMEWINDOW);
        Notifications(CLOSELOGINWINDOW);
        Notifications(CLOSECONNECTINGWINDOW);
        Notifications(CLOSEJOINWINDOW);
        Notifications(CLOSEHEADIMAGEWINDOW);
        Notifications(CLOSEMEETINGWEBWINDOW);
        Notifications(CLOSEPASSWORDWINDOW);
        Notifications(CLOSEINVITATIONWINDOW);
        Notifications(CLOSEUSERWINDOW);
        Notifications(CLOSEPDWINDOW);
        DDLogInfo(@"[Info] 10039 user join meeting successful");
        self->appDelegate.isInTheMeeting = YES;
        self->appDelegate.mainWindowController = self->windowControl;
        [self->windowControl.window orderFront:nil];
        [self->localWindow.window orderFront:nil];
        Notifications(STARTIME);
        [self.view.window orderOut:nil];
    });
}

- (void)onCallIncoming:(EVCallInfo * _Nonnull)info
{
    
}

- (void)onCallEnd:(EVCallInfo * _Nonnull)info
{
    dispatch_async(dispatch_get_main_queue(), ^{
        EVServerError error = info.err.code;
        //1001 2001 2005 2015 2031 2033 2035
        DDLogWarn(@"[Warn] 10040 user join meeting failure errorcode:%lu", (unsigned long)error);
        if (error == EVServerInvalidToken) {
            self->hub.hidden = NO;
            self->hub.hudTitleFd.stringValue = localizationBundle(@"alert.invalidConfNumber");
        }else if (error == EVServerNotActived) {
            self->hub.hidden = NO;
            self->hub.hudTitleFd.stringValue = localizationBundle(@"alert.cloudnotactivat");
        }else if (error == EVServerNotFoundTemplateOrRoom) {
            self->hub.hidden = NO;
            self->hub.hudTitleFd.stringValue = localizationBundle(@"alert.meetingnotstart");
        }else if (error == EVServerInvalidConfRoomCapacity) {
            Notifications(CLOSEPASSWORDWINDOW);
            PasswordWindowController* passwordWindow = [PasswordWindowController windowController];
            self->appDelegate.mainWindowController = passwordWindow;
            [passwordWindow.window makeKeyAndOrderFront:self];
        }else if (error == EvServerRoomNotAllowAnonymousCall) {
            self->hub.hidden = NO;
            self->hub.hudTitleFd.stringValue = localizationBundle(@"alert.meetingdosenotanonymouscall");
        }else if (error == EvServerRoomOnlyAllowOwnerActive) {
            self->hub.hidden = NO;
            self->hub.hudTitleFd.stringValue = localizationBundle(@"alert.allowmeeting");
        }else if (error == EvServerTrialPeriodExpired) {
            self->hub.hidden = NO;
            self->hub.hudTitleFd.stringValue = localizationBundle(@"alert.trialexpired");
        }else {
            self->hub.hidden = NO;
            self->hub.hudTitleFd.stringValue = [NSString stringWithFormat:@"%@%lu", localizationBundle(@"alert.joinmeetingerr"), (unsigned long)info.err.code];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:PORTMPT object:[NSString stringWithFormat:@"%lu", (unsigned long)info.err.code]];
        
        [self persendMethod:2];
        Notifications(CLOSECONNECTINGWINDOW);
        self->appDelegate.isInTheMeeting = NO;
    });
}

- (void)onRegister:(BOOL)registered
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (registered) {
            [[NSNotificationCenter defaultCenter] postNotificationName:REGISTERED object:@"1"];
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:REGISTERED object:@"0"];
        }
    });
}

- (void)onJoinConferenceIndication:(EVCallInfo *_Nonnull)info
{
    dispatch_async(dispatch_get_main_queue(), ^{
        Notifications(CLOSEINVITATIONWINDOW);
        self->callInfo = info;
        InvitationWindowController* invitation = [InvitationWindowController windowController];
        self->appDelegate.mainWindowController = invitation;
        [invitation.window makeKeyAndOrderFront:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:JOINMEETING object:info];
    });
}

#pragma mark - Notification
- (void)closeJoinWindow
{
//    [self.view.window close];
}

- (void)cancelCall
{
    hub.hidden = YES;
}

- (void)joinconfId:(NSNotification *)sender
{
    isshow = NO;
    [_dataArray removeAllObjects];
    NSArray *arrayDate = [NSUSERDEFAULT objectForKey:@"HISTORYCALL"];
    if (arrayDate) {
        [_dataArray addObjectsFromArray:arrayDate];
    }
    if (isshow) {
        tabBg.hidden = NO;
    }else {
        tabBg.hidden = YES;
    }
    [tab reloadData];
    NSString *confid = sender.object;
    if (confid.length == 0) {
        iscanchoose = YES;
        accoutTF.enabled = YES;
        accoutTF.stringValue = @"";
        webpasswordStr = @"";
    }else {
        accoutTF.enabled = NO;
        iscanchoose = NO;
        if ([confid containsString:@"*"]) {
            accoutTF.stringValue = [[confid componentsSeparatedByString:@"*"] objectAtIndex:0];
            webpasswordStr = [[confid componentsSeparatedByString:@"*"] objectAtIndex:1];
        }else {
            accoutTF.stringValue = confid;
            webpasswordStr = @"";
        }
    }
    
}

- (void)getMeetingpassword:(NSNotification *)sender
{
    NSString *password = sender.object;
    if ([[NSUSERDEFAULT objectForKey:@"anonymous"] isEqualToString:@"YES"]) {
        [appDelegate.evengine setDelegate:self];
        [appDelegate.evengine joinConferenceWithLocation:anonymousDic[@"server"] port:[anonymousDic[@"port"] intValue] conference_number:anonymousDic[@"confId"] display_name:anonymousDic[@"disName"] password:password];
    }else {
        [appDelegate.evengine joinConference:confIdStr display_name:displayName password:password];
        hub.hidden = NO;
        hub.hudTitleFd.stringValue = localizationBundle(@"alert.connection");
    }
    
}

- (void)invitationJoin:(NSNotification *)sender
{
    callInfo = sender.object;
    [self.view.window makeKeyAndOrderFront:nil];
    
    [NSUSERDEFAULT setValue:@"NO" forKey:@"anonymous"];
    [NSUSERDEFAULT synchronize];
    
    NSMutableDictionary *setDic = [NSMutableDictionary dictionaryWithDictionary:[PlistUtils loadUserInfoPlistFilewithFileName:SETINFO]];
    [setDic setValue:callInfo.conference_number forKey:@"confId"];
    [PlistUtils saveUserInfoPlistFile:(NSDictionary *)setDic withFileName:SETINFO];
    
    NSString *downloadimagepath = [[EVUtils get_current_app_path]stringByAppendingPathComponent:@"header.jpg"];
    [appDelegate.evengine setUserImage:[EVUtils bundleFile:@"bg_videomute.png"] filename:downloadimagepath];
    
    ConnectingWindowController *connectingWindow = [ConnectingWindowController windowController];
    
    appDelegate.mainWindowController = connectingWindow;
    
    [connectingWindow.window orderFront:nil];
    
    if (!issetVideo) {
        
        DDLogInfo(@"[Info] 10031 Start Video");
        
        Notifications(CLOSELOCALWINDOW);
        localWindow = [LocalWindowController windowController];
        
        Notifications(CLOSEVIDEOHOMEWINDOW);
        windowControl = [VideoHomeWindowController windowController];
        issetVideo = YES;
    }
    
    [appDelegate.evengine setDelegate:self];
    [appDelegate.evengine joinConference:callInfo.conference_number display_name:@"" password:callInfo.password];
    hub.hidden = NO;
    hub.hudTitleFd.stringValue = localizationBundle(@"alert.connection");
}

- (void)anonymousLogin:(NSNotification *)sender
{
    [self openVideo];

    anonymousDic = sender.object;
    NSMutableDictionary *setDic = [NSMutableDictionary dictionaryWithDictionary:[PlistUtils loadUserInfoPlistFilewithFileName:SETINFO]];
    [setDic setValue:anonymousDic[@"confId"] forKey:@"confId"];
    [PlistUtils saveUserInfoPlistFile:(NSDictionary *)setDic withFileName:SETINFO];
    [appDelegate.evengine setDelegate:self];
    [appDelegate.evengine joinConference:anonymousDic[@"server"] port:[anonymousDic[@"port"] intValue] conference_number:anonymousDic[@"confId"] display_name:anonymousDic[@"disName"] password:anonymousDic[@"password"]];
    [NSUSERDEFAULT setValue:@"YES" forKey:@"anonymous"];
    [NSUSERDEFAULT synchronize];
}

- (void)anonymouslocationLogin:(NSNotification *)sender
{
    [self openVideo];
    
    anonymousDic = sender.object;
    NSMutableDictionary *setDic = [NSMutableDictionary dictionaryWithDictionary:[PlistUtils loadUserInfoPlistFilewithFileName:SETINFO]];
    [setDic setValue:anonymousDic[@"confId"] forKey:@"confId"];
    [PlistUtils saveUserInfoPlistFile:(NSDictionary *)setDic withFileName:SETINFO];
    [appDelegate.evengine setDelegate:self];
    [appDelegate.evengine joinConferenceWithLocation:anonymousDic[@"server"] port:[anonymousDic[@"port"] intValue] conference_number:anonymousDic[@"confId"] display_name:anonymousDic[@"disName"] password:anonymousDic[@"password"]];
    [NSUSERDEFAULT setValue:@"YES" forKey:@"anonymous"];
    [NSUSERDEFAULT synchronize];
}

- (void)webJoinAction:(NSNotification *)sender
{
    NSMutableDictionary *dic = sender.object;
    NSMutableDictionary *setDic = [NSMutableDictionary dictionaryWithDictionary:[PlistUtils loadUserInfoPlistFilewithFileName:SETINFO]];
    [setDic setValue:dic[@"confid"] forKey:@"confId"];
    [PlistUtils saveUserInfoPlistFile:(NSDictionary *)setDic withFileName:SETINFO];
    
    NSString *downloadimagepath = [[EVUtils get_current_app_path]stringByAppendingPathComponent:@"header.jpg"];
    [appDelegate.evengine setUserImage:[EVUtils bundleFile:@"bg_videomute.png"] filename:downloadimagepath];
    
    Notifications(CLOSECONNECTINGWINDOW);
    ConnectingWindowController *connectingWindow = [ConnectingWindowController windowController];
    appDelegate.mainWindowController = connectingWindow;
    [connectingWindow.window orderFront:nil];
    
    if (!issetVideo) {
        
        DDLogInfo(@"[Info] 10031 Start Video");
        
        Notifications(CLOSELOCALWINDOW);
        localWindow = [LocalWindowController windowController];
        
        Notifications(CLOSEVIDEOHOMEWINDOW);
        windowControl = [VideoHomeWindowController windowController];
        issetVideo = YES;
    }
    
    [NSUSERDEFAULT setValue:@"NO" forKey:@"anonymous"];
    [NSUSERDEFAULT synchronize];
    
    HLog(@"1111111111111AUTOWEBJOIN%@", [NSUSERDEFAULT objectForKey:@"anonymous"]);
    
    [appDelegate.evengine setDelegate:self];
//    NSString *disName = dic[@"displayname"];
//    if (disName.length == 0) {
//        disName = [EVUtils judgeString:NSUserName()];
//    }
    [appDelegate.evengine joinConference:dic[@"confid"] display_name:@"" password:dic[@"password"]];
}

- (void)removeVideo
{
    issetVideo = NO;
    DDLogInfo(@"[Info] 10032 Remove Video");
}

- (void)openVideo
{
    if (!issetVideo) {
        
        DDLogInfo(@"[Info] 10031 Start Video");
        
        Notifications(CLOSELOCALWINDOW);
        localWindow = [LocalWindowController windowController];
        
        Notifications(CLOSEVIDEOHOMEWINDOW);
        windowControl = [VideoHomeWindowController windowController];
        issetVideo = YES;
    }
}

/**
 Toggle language
 
 @param sender Notification
 */
- (void)changeLanguage:(NSNotification *)sender
{
    [loginBtn changeCenterButtonattribute:localizationBundle(@"login.window.join") color:WHITECOLOR];
    [videoBtn changeLeftButtonattribute:localizationBundle(@"home.join.camera") color:TITLECOLOR];
    [muteBtn changeLeftButtonattribute:localizationBundle(@"home.join.mute") color:TITLECOLOR];
    
    joinMeetingTitle.stringValue = localizationBundle(@"login.window.join.meeting");
    accoutTF.placeholderString = localizationBundle(@"home.joinmeetinginput");
    passwordTF.placeholderString = localizationBundle(@"alert.writeDisName");
    
}

#pragma mark - KEYDOWN
- (IBAction)keydown:(id)sender
{
    [appDelegate.evengine setDelegate:self];
    confIdStr = [EVUtils removeTheStringBlankSpace:accoutTF.stringValue];
    if (confIdStr.length == 0) {
        return;
    }
    
    NSString *passwordStr;
    if([confIdStr rangeOfString:@"*"].location != NSNotFound)
    {
        NSArray*array = [confIdStr componentsSeparatedByString:@"*"];
        confIdStr     = [array firstObject];
        passwordStr   = [array lastObject];
    }
    else
    {
        passwordStr = @"";
    }
    displayName = [EVUtils removeTheStringBlankSpace:passwordTF.stringValue];
    
    [NSUSERDEFAULT setValue:@"NO" forKey:@"anonymous"];
    [NSUSERDEFAULT synchronize];
    
    NSMutableDictionary *setDic = [NSMutableDictionary dictionaryWithDictionary:[PlistUtils loadUserInfoPlistFilewithFileName:SETINFO]];
    [setDic setValue:confIdStr forKey:@"confId"];
    [PlistUtils saveUserInfoPlistFile:(NSDictionary *)setDic withFileName:SETINFO];
    DDLogInfo(@"[Info] 10011 user join meeting Numberinfo:confId:%@, displayName:%@, password:%@", confIdStr, displayName, passwordStr);
    NSString *downloadimagepath = [[EVUtils get_current_app_path]stringByAppendingPathComponent:@"header.jpg"];
    [appDelegate.evengine setUserImage:[EVUtils bundleFile:@"bg_videomute.png"] filename:downloadimagepath];
    [appDelegate.evengine joinConference:confIdStr display_name:displayName password:passwordStr];
    
    hub.hidden = NO;
    hub.hudTitleFd.stringValue = localizationBundle(@"alert.connection");
    
    NSMutableArray *mutablearrayDate = [NSMutableArray arrayWithCapacity:1];
    NSArray *arrayDate = [NSUSERDEFAULT objectForKey:@"HISTORYCALL"];
    [mutablearrayDate addObjectsFromArray:arrayDate];
    if (mutablearrayDate.count<5) {
        BOOL isneedRemovelastObj = YES;
        for (int i = 0; i<mutablearrayDate.count; i++) {
            if ([accoutTF.stringValue isEqualToString:mutablearrayDate[i]]) {
                [mutablearrayDate removeObjectAtIndex:i];
                [mutablearrayDate insertObject:accoutTF.stringValue atIndex:0];
                isneedRemovelastObj = NO;
            }
        }
        if (isneedRemovelastObj) {
            [mutablearrayDate insertObject:accoutTF.stringValue atIndex:0];
        }
        
        [NSUSERDEFAULT setValue:mutablearrayDate forKey:@"HISTORYCALL"];
        [NSUSERDEFAULT synchronize];
    }else {
        BOOL isneedRemovelastObj = YES;
        for (int i = 0; i<mutablearrayDate.count; i++) {
            if ([accoutTF.stringValue isEqualToString:mutablearrayDate[i]]) {
                [mutablearrayDate removeObjectAtIndex:i];
                [mutablearrayDate insertObject:accoutTF.stringValue atIndex:0];
                isneedRemovelastObj = NO;
            }
        }
        if (isneedRemovelastObj) {
            [mutablearrayDate removeLastObject];
            [mutablearrayDate insertObject:accoutTF.stringValue atIndex:0];
        }
        
        [NSUSERDEFAULT setValue:mutablearrayDate forKey:@"HISTORYCALL"];
        [NSUSERDEFAULT synchronize];
    }
    
    ConnectingWindowController *connectingWindow = [ConnectingWindowController windowController];
    appDelegate.mainWindowController = connectingWindow;
    [connectingWindow.window orderFront:nil];
    
    if (!issetVideo) {
        DDLogInfo(@"[Info] 10031 Start Video");
        Notifications(CLOSELOCALWINDOW);
        localWindow = [LocalWindowController windowController];
        Notifications(CLOSEVIDEOHOMEWINDOW);
        windowControl = [VideoHomeWindowController windowController];
        issetVideo = YES;
    }
}

#pragma mark - HUDHIDDEN
- (void)persendMethod:(NSInteger)time
{
    [self performSelector:@selector(hiddenHUD) withObject:self afterDelay:time];
}

- (void)hiddenHUD
{
    hub.hidden = YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CHANGELANGUAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CLOSEJOINWINDOW object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CANCELCALL object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:JOINCONFID object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MEETINGPASSWORD object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:INVITATIONJOIN object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ANONYMOUSLOGIN object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ANONYMOUSLOCATIONLOGIN object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WEBJOIN object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:OPENVIDEO object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:REMOVEVIDEO object:nil];
}

@end
