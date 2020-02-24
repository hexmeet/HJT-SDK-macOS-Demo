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
#import "P2pConnectingWindowController.h"
#import "P2pConnectingViewController.h"
#import "CustomCell.h"
#import "macHUD.h"
#import "ConnectingViewController.h"

@interface JoinMeetingViewController ()<EVEngineDelegate, NSTableViewDelegate, NSTableViewDataSource, EMEngineDelegate>
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
    NSDictionary *p2pDic;
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

- (void)viewWillAppear
{
    [super viewWillAppear];
    
    [self getUserSet];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self setRootViewAttribute];
    
    NSMutableDictionary *setDic = [NSMutableDictionary dictionaryWithDictionary:[PlistUtils loadUserInfoPlistFilewithFileName:SETINFO]];
    [setDic setValue:@"conf" forKey:@"conftype"];
    [PlistUtils saveUserInfoPlistFile:(NSDictionary *)setDic withFileName:SETINFO];
    
    
    [self languageLocalization];
}

- (void)setRootViewAttribute
{
    isshow = NO;
    issetVideo = NO;
    iscanchoose = YES;
    
    webpasswordStr = @"";
    
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p2pCall:) name:P2PCALL object:nil];
    
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
        
        NSMutableArray *mutablearrayDate = [NSMutableArray arrayWithCapacity:1];
        NSArray *arrayDate = [NSUSERDEFAULT objectForKey:@"HISTORYCALL"];
        [mutablearrayDate addObjectsFromArray:arrayDate];
        if (mutablearrayDate.count<5) {
            BOOL isneedRemovelastObj = YES;
            for (int i = 0; i<mutablearrayDate.count; i++) {
                if ([confIdStr isEqualToString:mutablearrayDate[i]]) {
                    [mutablearrayDate removeObjectAtIndex:i];
                    [mutablearrayDate insertObject:confIdStr atIndex:0];
                    isneedRemovelastObj = NO;
                }
            }
            if (isneedRemovelastObj) {
                [mutablearrayDate insertObject:confIdStr atIndex:0];
            }

            [NSUSERDEFAULT setValue:mutablearrayDate forKey:@"HISTORYCALL"];
            [NSUSERDEFAULT synchronize];
        }else {
            BOOL isneedRemovelastObj = YES;
            for (int i = 0; i<mutablearrayDate.count; i++) {
                if ([confIdStr isEqualToString:mutablearrayDate[i]]) {
                    [mutablearrayDate removeObjectAtIndex:i];
                    [mutablearrayDate insertObject:confIdStr atIndex:0];
                    isneedRemovelastObj = NO;
                }
            }
            if (isneedRemovelastObj) {
                [mutablearrayDate removeLastObject];
                [mutablearrayDate insertObject:confIdStr atIndex:0];
            }

            [NSUSERDEFAULT setValue:mutablearrayDate forKey:@"HISTORYCALL"];
            [NSUSERDEFAULT synchronize];
        }
        
        [appDelegate.evengine joinConference:confIdStr display_name:displayName password:passwordStr];
        
        hub.hidden = NO;
        hub.hudTitleFd.stringValue = localizationBundle(@"alert.connection");
        
        ConnectingWindowController *connectingWindow = [ConnectingWindowController windowController];
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
        
        NSMutableDictionary *setDic = [NSMutableDictionary dictionaryWithDictionary:[PlistUtils loadUserInfoPlistFilewithFileName:SETINFO]];
        [setDic setValue:@"YES" forKey:@"iscloudLogin"];
        NSNumber * boolContactWebPage = [NSNumber numberWithBool:user.featureSupport.contactWebPage];
        [setDic setValue:boolContactWebPage forKey:@"contactWebPage"];
        NSNumber * boolP2pCall = [NSNumber numberWithBool:user.featureSupport.p2pCall];
        [setDic setValue:boolP2pCall forKey:@"p2pCall"];
        NSNumber * boolChatInConference = [NSNumber numberWithBool:user.featureSupport.chatInConference];
        [setDic setValue:boolChatInConference forKey:@"chatInConference"];
        NSNumber * boolSwitchingToAudioConference = [NSNumber numberWithBool:user.featureSupport.switchingToAudioConference];
        [setDic setValue:boolSwitchingToAudioConference forKey:@"switchingToAudioConference"];
        [PlistUtils saveUserInfoPlistFile:setDic withFileName:SETINFO];
        
        if ([EVUtils queryUserPlist:@"chatInConference"]) {
            [[EMMessageManager sharedInstance] selectEntity:nil ascending:YES filterString:nil success:^(NSArray *results) {
                NSLog(@"数据---%@",results);
                //全部删除
                for (NSManagedObject *obj in results){
                    [[EMMessageManager sharedInstance] deleteEntity:obj success:^{
                    } fail:^(NSError *error) {
                    }];
                }
            } fail:^(NSError *error) {
                
            }];
            
            [[EVUserIdManager sharedInstance] selectEntity:nil ascending:YES filterString:nil success:^(NSArray *results) {
                NSLog(@"数据---%@",results);
                //全部删除
                for (NSManagedObject *obj in results){
                    [[EVUserIdManager sharedInstance] deleteEntity:obj success:^{
                    } fail:^(NSError *error) {
                    }];
                }
            } fail:^(NSError *error) {
                
            }];
        }
        
        Notifications(UPDATETOKEN);
        if ([[NSUSERDEFAULT objectForKey:@"anonymous"] isEqualToString:@"YES"]) {
            Notifications(CLOSECONNECTINGWINDOW);
            DDLogInfo(@"[Info] 10030 User anonymous logins successful username:%@, displayName: %@, org: %@, cellphone: %@, email: %@", user.username, user.displayName, user.org, user.cellphone, user.email);
            ConnectingWindowController *connectingWindow = [ConnectingWindowController windowController];
            [connectingWindow.window orderFront:nil];
            
        }
    });
}

- (void)onCallConnected:(EVCallInfo * _Nonnull)info
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (info.svcCallType == EVSvcCallConf) {
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
            
            if ([EVUtils queryUserPlist:@"chatInConference"]) {
                [self->appDelegate.emengine setDelegate:self];
                //imlogin server
                NSMutableDictionary *setDic = [NSMutableDictionary dictionaryWithDictionary:[PlistUtils loadUserInfoPlistFilewithFileName:SETINFO]];
                NSURL *url = [NSURL URLWithString:[self->appDelegate.evengine getIMAddress]];
                if ([url absoluteString].length != 0) {
                    [self->appDelegate.emengine anonymousLogin:url.host port:[url.port intValue] displayname:[self->appDelegate.evengine getDisplayName] external_info:[NSString stringWithFormat:@"%llu", [self->appDelegate.evengine getUserInfo].userId]];
                    NSNumber * boolChatInConference = [NSNumber numberWithBool:true];
                    [setDic setValue:boolChatInConference forKey:@"getIMAddress"];
                }else{
                    NSNumber * boolChatInConference = [NSNumber numberWithBool:false];
                    [setDic setValue:boolChatInConference forKey:@"getIMAddress"];
                }
                [PlistUtils saveUserInfoPlistFile:(NSDictionary *)setDic withFileName:SETINFO];
            }
            
        }else if (info.svcCallType == EVSvcCallP2P) {
            
            NSMutableDictionary *setDic = [NSMutableDictionary dictionaryWithDictionary:[PlistUtils loadUserInfoPlistFilewithFileName:SETINFO]];
            NSNumber * boolChatInConference = [NSNumber numberWithBool:false];
            [setDic setValue:boolChatInConference forKey:@"chatInConference"];
            [PlistUtils saveUserInfoPlistFile:(NSDictionary *)setDic withFileName:SETINFO];
            
            Notifications(CLOSEP2PCONNECTINGWINDOW);
            P2pConnectingWindowController *connectingWindow = [P2pConnectingWindowController windowController];
            P2pConnectingViewController *view = (P2pConnectingViewController *)connectingWindow.contentViewController;
            view.userName.stringValue = self->p2pDic[@"displayName"];
            view.headImage.image = [[NSImage alloc]initWithContentsOfURL:[NSURL URLWithString:self->p2pDic[@"imageUrl"]]];
            view.callNumber = info.conference_number;
//            view.headImage.image = [[NSImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL url]]];
            view.headImage.image = [EVUtils resizeImage:view.headImage.image size:view.headImage.frame.size];
            [connectingWindow.window orderFront:nil];
        }
    });
}

- (void)onCallPeerConnected:(EVCallInfo * _Nonnull)info
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
        Notifications(CLOSEP2PCONNECTINGWINDOW);
        DDLogInfo(@"[Info] 10039 user join meeting successful");
        Notifications(CLOSELOCALWINDOW);
        
        NSMutableDictionary *setDic = [NSMutableDictionary dictionaryWithDictionary:[PlistUtils loadUserInfoPlistFilewithFileName:SETINFO]];
        [setDic setValue:info.conference_number forKey:@"confId"];
        [setDic setValue:@"p2p" forKey:@"conftype"];
        [PlistUtils saveUserInfoPlistFile:(NSDictionary *)setDic withFileName:SETINFO];
        
        self->localWindow = [LocalWindowController windowController];
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
        //1001   2005 2015 2031 2033 2035
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
            [passwordWindow.window makeKeyAndOrderFront:self];
        }else if (error == EvServerRoomNotAllowAnonymousCall) {
            self->hub.hidden = NO;
            self->hub.hudTitleFd.stringValue = localizationBundle(@"alert.allowmeeting");
        }else if (error == EvServerRoomOnlyAllowOwnerActive) {
            self->hub.hidden = NO;
            self->hub.hudTitleFd.stringValue = localizationBundle(@"alert.meetingdosenotanonymouscall");
        }else if (error == EvServerTrialPeriodExpired) {
            self->hub.hidden = NO;
            self->hub.hudTitleFd.stringValue = localizationBundle(@"alert.trialexpired");
        }else if (error == 2011) {
            self->hub.hidden = NO;
            self->hub.hudTitleFd.stringValue = localizationBundle(@"error.2011");
        }else if (error == 2009) {
            self->hub.hidden = NO;
            self->hub.hudTitleFd.stringValue = localizationBundle(@"error.2009");
        }else if (error == 2024) {
            self->hub.hidden = NO;
            self->hub.hudTitleFd.stringValue = localizationBundle(@"error.2024");
        }else if (error == 2025) {
            self->hub.hidden = NO;
            self->hub.hudTitleFd.stringValue = localizationBundle(@"error.2025");
        }else if (error == 2007) {
            self->hub.hidden = NO;
            self->hub.hudTitleFd.stringValue = localizationBundle(@"error.2007");
        }else if (error == 2023) {
            self->hub.hidden = NO;
            self->hub.hudTitleFd.stringValue = localizationBundle(@"alert.limit");
        }else if (error == 4055) {
            self->hub.hidden = NO;
            self->hub.hudTitleFd.stringValue = localizationBundle(@"error.4055");
        }else if (error == 4051) {
            self->hub.hidden = NO;
            self->hub.hudTitleFd.stringValue = localizationBundle(@"error.4051");
        }else if (error == 4049) {
            self->hub.hidden = NO;
            self->hub.hudTitleFd.stringValue = localizationBundle(@"error.4049");
        }else if (error == 10) {
            [EVUtils stopSound];
            self->hub.hidden = NO;
            self->hub.hudTitleFd.stringValue = localizationBundle(@"error.10");
            
            self->localWindow = [LocalWindowController windowController];
            Notifications(CLOSEP2PCONNECTINGWINDOW);
        }else if (error == 101) {
            [EVUtils stopSound];
            self->hub.hidden = NO;
            self->hub.hudTitleFd.stringValue = localizationBundle(@"error.101");
            
            self->localWindow = [LocalWindowController windowController];
            Notifications(CLOSEP2PCONNECTINGWINDOW);
        }else if (error == 14) {
            [EVUtils stopSound];
            self->hub.hidden = NO;
            self->hub.hudTitleFd.stringValue = localizationBundle(@"error.14");
            
            self->localWindow = [LocalWindowController windowController];
            Notifications(CLOSEP2PCONNECTINGWINDOW);
        }else if (error == 0) {
            [EVUtils stopSound];
            self->hub.hidden = NO;
            self->hub.hudTitleFd.stringValue = localizationBundle(@"error.14");
            
            self->localWindow = [LocalWindowController windowController];
            Notifications(CLOSEP2PCONNECTINGWINDOW);
        }else {
            self->hub.hidden = NO;
            self->hub.hudTitleFd.stringValue = [NSString stringWithFormat:@"%@%lu", localizationBundle(@"alert.joinmeetingerr"), (unsigned long)info.err.code];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:PORTMPT object:[NSString stringWithFormat:@"%lu", (unsigned long)info.err.code]];
        
        [self persendMethod:3];
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
        NSMutableDictionary *setDic = [NSMutableDictionary dictionaryWithDictionary:[PlistUtils loadUserInfoPlistFilewithFileName:SETINFO]];
        if (info.svcCallType == EVSvcCallP2P) {
            [setDic setValue:info.conference_number forKey:@"confId"];
            [setDic setValue:@"p2p" forKey:@"conftype"];
        }else {
            [setDic setValue:info.conference_number forKey:@"confId"];
            [setDic setValue:@"conf" forKey:@"conftype"];
        }
        [PlistUtils saveUserInfoPlistFile:(NSDictionary *)setDic withFileName:SETINFO];
        self->callInfo = info;
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

#pragma mark - EMEngineDelegate
- (void)onMessageReciveData:(MessageBody *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        message.time = [EVUtils userVisibleDateTimeStringForRFC3339DateTimeString:message.time];
        [[EMMessageManager sharedInstance] insertNewEntity:message success:^{
            NSLog(@"数据储存成功");
        } fail:^(NSError *error) {
            NSLog(@"失败");
        }];
        
        [[EMManager sharedInstance].delegates onMessageReciveData:message];
        
    });
}

- (void)onEMError:(EMError *)err {
    dispatch_async(dispatch_get_main_queue(), ^{
        DDLogInfo(@"IM onEMError:%@", err.reason);
        [[EMManager sharedInstance].delegates onEMError:err];
    });
}

- (void)onLoginSucceed {
    dispatch_async(dispatch_get_main_queue(), ^{
        DDLogInfo(@"IM onLoginSucceed");
        //加群
        [self->appDelegate.emengine joinNewGroup:[self->appDelegate.evengine getIMGroupID]];
    });
}

- (void)onMessageSendSucceed:(MessageState *_Nonnull)messageState
{
    dispatch_async(dispatch_get_main_queue(), ^{
        DDLogInfo(@"IM onMessageSendSucceed");
        [[EMManager sharedInstance].delegates onMessageSendSucceed:messageState];
    });
}

- (void)onGroupMemberInfo:(EMGroupMemberInfo *)groupMemberInfo
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        EVContactInfo *info = [self->appDelegate.evengine getContactInfo:[groupMemberInfo.evuserId UTF8String] timeout:3];
        dispatch_async(dispatch_get_main_queue(), ^{
            DDLogInfo(@"IM onGroupMemberInfo");
            if (info.evstatus == 0) {
                groupMemberInfo.imageUrl = info.imageUrl;
                groupMemberInfo.name = info.displayName;
                [[EVUserIdManager sharedInstance] insertNewEntity:groupMemberInfo success:nil fail:nil];
                
                [[EMManager sharedInstance].delegates onGroupMemberInfo:groupMemberInfo];
                NSLog(@"groupMemberInfo+++++++++%@", groupMemberInfo.evuserId);
            }
        });
    });
    
}


#pragma mark - Notification
- (void)closeJoinWindow
{
    [EVUtils stopSound];
    [self.view.window orderOut:nil];
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
        NSMutableArray *mutablearrayDate = [NSMutableArray arrayWithCapacity:1];
        NSArray *arrayDate = [NSUSERDEFAULT objectForKey:@"HISTORYCALL"];
        [mutablearrayDate addObjectsFromArray:arrayDate];
        if (mutablearrayDate.count<5) {
            BOOL isneedRemovelastObj = YES;
            for (int i = 0; i<mutablearrayDate.count; i++) {
                if ([anonymousDic[@"confId"] isEqualToString:mutablearrayDate[i]]) {
                    [mutablearrayDate removeObjectAtIndex:i];
                    [mutablearrayDate insertObject:anonymousDic[@"confId"] atIndex:0];
                    isneedRemovelastObj = NO;
                }
            }
            if (isneedRemovelastObj) {
                [mutablearrayDate insertObject:anonymousDic[@"confId"] atIndex:0];
            }

            [NSUSERDEFAULT setValue:mutablearrayDate forKey:@"HISTORYCALL"];
            [NSUSERDEFAULT synchronize];
        }else {
            BOOL isneedRemovelastObj = YES;
            for (int i = 0; i<mutablearrayDate.count; i++) {
                if ([anonymousDic[@"confId"] isEqualToString:mutablearrayDate[i]]) {
                    [mutablearrayDate removeObjectAtIndex:i];
                    [mutablearrayDate insertObject:anonymousDic[@"confId"] atIndex:0];
                    isneedRemovelastObj = NO;
                }
            }
            if (isneedRemovelastObj) {
                [mutablearrayDate removeLastObject];
                [mutablearrayDate insertObject:anonymousDic[@"confId"] atIndex:0];
            }

            [NSUSERDEFAULT setValue:mutablearrayDate forKey:@"HISTORYCALL"];
            [NSUSERDEFAULT synchronize];
        }
        [appDelegate.evengine joinConferenceWithLocation:anonymousDic[@"server"] port:[anonymousDic[@"port"] intValue] conference_number:anonymousDic[@"confId"] display_name:anonymousDic[@"disName"] password:password];
    }else {
        NSMutableArray *mutablearrayDate = [NSMutableArray arrayWithCapacity:1];
        NSArray *arrayDate = [NSUSERDEFAULT objectForKey:@"HISTORYCALL"];
        [mutablearrayDate addObjectsFromArray:arrayDate];
        if (mutablearrayDate.count<5) {
            BOOL isneedRemovelastObj = YES;
            for (int i = 0; i<mutablearrayDate.count; i++) {
                if ([confIdStr isEqualToString:mutablearrayDate[i]]) {
                    [mutablearrayDate removeObjectAtIndex:i];
                    [mutablearrayDate insertObject:confIdStr atIndex:0];
                    isneedRemovelastObj = NO;
                }
            }
            if (isneedRemovelastObj) {
                [mutablearrayDate insertObject:confIdStr atIndex:0];
            }

            [NSUSERDEFAULT setValue:mutablearrayDate forKey:@"HISTORYCALL"];
            [NSUSERDEFAULT synchronize];
        }else {
            BOOL isneedRemovelastObj = YES;
            for (int i = 0; i<mutablearrayDate.count; i++) {
                if ([confIdStr isEqualToString:mutablearrayDate[i]]) {
                    [mutablearrayDate removeObjectAtIndex:i];
                    [mutablearrayDate insertObject:confIdStr atIndex:0];
                    isneedRemovelastObj = NO;
                }
            }
            if (isneedRemovelastObj) {
                [mutablearrayDate removeLastObject];
                [mutablearrayDate insertObject:confIdStr atIndex:0];
            }

            [NSUSERDEFAULT setValue:mutablearrayDate forKey:@"HISTORYCALL"];
            [NSUSERDEFAULT synchronize];
        }
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
    ConnectingViewController *view = (ConnectingViewController *)connectingWindow.contentViewController;
    if (callInfo.svcCallType == EVSvcCallP2P) {
        view.confId.stringValue = callInfo.peer;
    }
    
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
    NSMutableArray *mutablearrayDate = [NSMutableArray arrayWithCapacity:1];
    NSArray *arrayDate = [NSUSERDEFAULT objectForKey:@"HISTORYCALL"];
    [mutablearrayDate addObjectsFromArray:arrayDate];
    if (mutablearrayDate.count<5) {
        BOOL isneedRemovelastObj = YES;
        for (int i = 0; i<mutablearrayDate.count; i++) {
            if ([callInfo.conference_number isEqualToString:mutablearrayDate[i]]) {
                [mutablearrayDate removeObjectAtIndex:i];
                [mutablearrayDate insertObject:callInfo.conference_number atIndex:0];
                isneedRemovelastObj = NO;
            }
        }
        if (isneedRemovelastObj) {
            [mutablearrayDate insertObject:callInfo.conference_number atIndex:0];
        }

        [NSUSERDEFAULT setValue:mutablearrayDate forKey:@"HISTORYCALL"];
        [NSUSERDEFAULT synchronize];
    }else {
        BOOL isneedRemovelastObj = YES;
        for (int i = 0; i<mutablearrayDate.count; i++) {
            if ([callInfo.conference_number isEqualToString:mutablearrayDate[i]]) {
                [mutablearrayDate removeObjectAtIndex:i];
                [mutablearrayDate insertObject:callInfo.conference_number atIndex:0];
                isneedRemovelastObj = NO;
            }
        }
        if (isneedRemovelastObj) {
            [mutablearrayDate removeLastObject];
            [mutablearrayDate insertObject:callInfo.conference_number atIndex:0];
        }

        [NSUSERDEFAULT setValue:mutablearrayDate forKey:@"HISTORYCALL"];
        [NSUSERDEFAULT synchronize];
    }
    [appDelegate.evengine joinConference:callInfo.conference_number display_name:@"" password:callInfo.password];
    hub.hidden = NO;
    hub.hudTitleFd.stringValue = localizationBundle(@"alert.connection");
}

- (void)p2pCall:(NSNotification *)sender
{
    [self openVideo];
    NSMutableDictionary *setDic = [NSMutableDictionary dictionaryWithDictionary:[PlistUtils loadUserInfoPlistFilewithFileName:SETINFO]];
    [setDic setValue:callInfo.conference_number forKey:@"confId"];
    [PlistUtils saveUserInfoPlistFile:(NSDictionary *)setDic withFileName:SETINFO];
    
    NSString *downloadimagepath = [[EVUtils get_current_app_path]stringByAppendingPathComponent:@"header.jpg"];
    [appDelegate.evengine setUserImage:[EVUtils bundleFile:@"bg_videomute.png"] filename:downloadimagepath];
    [appDelegate.evengine setDelegate:self];
    p2pDic = sender.userInfo;
    NSString *userId = [NSString stringWithFormat:@"%@", sender.userInfo[@"userId"]];

    [appDelegate.evengine joinConference:userId display_name:[appDelegate.evengine getUserInfo].displayName password:@"" svcCallType:EVSvcCallP2P];
}

- (void)anonymouslocationLogin:(NSNotification *)sender
{
    [self openVideo];
    
    anonymousDic = sender.object;
    NSMutableDictionary *setDic = [NSMutableDictionary dictionaryWithDictionary:[PlistUtils loadUserInfoPlistFilewithFileName:SETINFO]];
    [setDic setValue:anonymousDic[@"confId"] forKey:@"confId"];
    [PlistUtils saveUserInfoPlistFile:(NSDictionary *)setDic withFileName:SETINFO];
    [appDelegate.evengine setDelegate:self];
    
    NSMutableArray *mutablearrayDate = [NSMutableArray arrayWithCapacity:1];
    NSArray *arrayDate = [NSUSERDEFAULT objectForKey:@"HISTORYCALL"];
    [mutablearrayDate addObjectsFromArray:arrayDate];
    if (mutablearrayDate.count<5) {
        BOOL isneedRemovelastObj = YES;
        for (int i = 0; i<mutablearrayDate.count; i++) {
            if ([anonymousDic[@"confId"] isEqualToString:mutablearrayDate[i]]) {
                [mutablearrayDate removeObjectAtIndex:i];
                [mutablearrayDate insertObject:anonymousDic[@"confId"] atIndex:0];
                isneedRemovelastObj = NO;
            }
        }
        if (isneedRemovelastObj) {
            [mutablearrayDate insertObject:anonymousDic[@"confId"] atIndex:0];
        }

        [NSUSERDEFAULT setValue:mutablearrayDate forKey:@"HISTORYCALL"];
        [NSUSERDEFAULT synchronize];
    }else {
        BOOL isneedRemovelastObj = YES;
        for (int i = 0; i<mutablearrayDate.count; i++) {
            if ([anonymousDic[@"confId"] isEqualToString:mutablearrayDate[i]]) {
                [mutablearrayDate removeObjectAtIndex:i];
                [mutablearrayDate insertObject:anonymousDic[@"confId"] atIndex:0];
                isneedRemovelastObj = NO;
            }
        }
        if (isneedRemovelastObj) {
            [mutablearrayDate removeLastObject];
            [mutablearrayDate insertObject:anonymousDic[@"confId"] atIndex:0];
        }

        [NSUSERDEFAULT setValue:mutablearrayDate forKey:@"HISTORYCALL"];
        [NSUSERDEFAULT synchronize];
    }
    
    [appDelegate.evengine joinConferenceWithLocation:anonymousDic[@"server"] port:[anonymousDic[@"port"] intValue] conference_number:anonymousDic[@"confId"] display_name:anonymousDic[@"disName"] password:anonymousDic[@"password"]];
    [NSUSERDEFAULT setValue:@"YES" forKey:@"anonymous"];
    [NSUSERDEFAULT synchronize];
}

- (void)webJoinAction:(NSNotification *)sender
{
    NSMutableDictionary *dic = sender.object;
    [self.view.window makeKeyAndOrderFront:nil];
    self.accoutTF.stringValue = dic[@"confid"];
    NSString *pd = dic[@"password"] ? dic[@"password"] : @"";
    if (pd.length != 0) {
        self.accoutTF.stringValue = [NSString stringWithFormat:@"%@*%@", dic[@"confid"], pd];
    }
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
            if ([confIdStr isEqualToString:mutablearrayDate[i]]) {
                [mutablearrayDate removeObjectAtIndex:i];
                [mutablearrayDate insertObject:confIdStr atIndex:0];
                isneedRemovelastObj = NO;
            }
        }
        if (isneedRemovelastObj) {
            [mutablearrayDate insertObject:confIdStr atIndex:0];
        }
        
        [NSUSERDEFAULT setValue:mutablearrayDate forKey:@"HISTORYCALL"];
        [NSUSERDEFAULT synchronize];
    }else {
        BOOL isneedRemovelastObj = YES;
        for (int i = 0; i<mutablearrayDate.count; i++) {
            if ([confIdStr isEqualToString:mutablearrayDate[i]]) {
                [mutablearrayDate removeObjectAtIndex:i];
                [mutablearrayDate insertObject:confIdStr atIndex:0];
                isneedRemovelastObj = NO;
            }
        }
        if (isneedRemovelastObj) {
            [mutablearrayDate removeLastObject];
            [mutablearrayDate insertObject:confIdStr atIndex:0];
        }
        
        [NSUSERDEFAULT setValue:mutablearrayDate forKey:@"HISTORYCALL"];
        [NSUSERDEFAULT synchronize];
    }
    
    ConnectingWindowController *connectingWindow = [ConnectingWindowController windowController];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:P2PCALL object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ANONYMOUSLOCATIONLOGIN object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WEBJOIN object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:OPENVIDEO object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:REMOVEVIDEO object:nil];
}

@end
