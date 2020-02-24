//
//  LoginRootViewController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/8/10.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "LoginRootViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "NSView+addShadow.h"
#import "macHUD.h"
#import "RootWindowController.h"
#import "HomeWindowController.h"
#import "VideoHomeWindowController.h"
#import "LocalWindowController.h"
#import "ConnectingWindowController.h"
#import <IOKit/IOKitLib.h>
#import "JoinWindowViewController.h"
#import "JoinWindowController.h"
#import "CustomCell.h"

@interface LoginRootViewController ()<EVEngineDelegate, NSTextFieldDelegate, NSTableViewDelegate, NSTableViewDataSource>
{
@private
    BOOL isCloundLogin;//is it a cloud login
    BOOL isSet;
    BOOL isLoginOranonymousLogin;
    BOOL isOnloginPage;
    BOOL isOnJoinPage;
    macHUD *hub;
    AppDelegate *appDelegate;
    NSString *passwordStr;
    NSMutableDictionary *anonymousDic;
    NSString *serverStr;
    
    BOOL isshow;
    BOOL iscanchoose;
    NSMutableArray * _dataArray;
}

@end

@implementation LoginRootViewController

@synthesize enterpriseLoginView, enterpriseLoginConstraint, enterpriseBtn, cloudBtn, enterpriseLoginbackButton, joinView, loginView, joinMeetingBtn, loginBtn, loginViewTitle, userLoginView, userLoginViewConstraint, homeView, userLoginBackBtn, serverTextFd, userTextFd, passwordTextFd, userLoginViewBg, userLoginViewLoginBtn, userLoginViewTitle, userTextFdConstraint, loginImageTitle, enterpriseImageTitle, advancedsetBtn, AdvancedSetView, AdvancedsetViewConstraint, advancedBackBtn, advanceTitleFd, portTextFd, httpBtn, advancedsureView, advancedcancelView, advancedsureBtn, advancedcancelBtn, joinMeetingView, joinMeetingViewConstraint, joinadvancedsetBtn, joinMeetingTitleFd, joinMeetingserverFd, joinMeetingConfIdFd, joinMeetingDisNameFd, joinMeetingBg, joinMeetingBackBtn, anonymousjoinMeetingBtn, joinMeetingchangeConstraint, applyBtn, videoBtn, muteBtn, settingBtn, tab, tabBg;

- (void)viewWillAppear
{
    [super viewWillAppear];
    [self getUserSet];
}

- (void)viewDidAppear {
    [super viewDidAppear];
    
    [self isValidToVisitCamera];
    
    [self isValidToVisitMicroPhone];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self setRootViewControllerBackGroundColor];
    
    [self setEnterpriseLoginViewAttribute];
    
    [self setUserLoginViewAttribute];
    
    [self setAdvancedSetViewAttribute];
    
    [self setJoinMeetingViewAttribute];
    
    [self languageLocalization];
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

//Init SDK
- (void)getEVSDK
{
    [appDelegate.evengine setDelegate:self];
}

/**
 Set the background color to white
 */
- (void)setRootViewControllerBackGroundColor
{
    [self.view setWantsLayer:YES];
    
    [self.view.layer setBackgroundColor:[WHITECOLOR CGColor]];
    
    appDelegate = APPDELEGATE;
    
    hub = [macHUD creatMacHUD:@"" icon:@"" viewController:self];
    hub.hidden = YES;
    
    //hover the cloudButton or privateButton
    NSTrackingAreaOptions options = NSTrackingInVisibleRect|NSTrackingMouseEnteredAndExited|NSTrackingActiveAlways;
    NSDictionary *dic1 = @{@"area":@"1"};
    NSTrackingArea *area1 = [[NSTrackingArea alloc] initWithRect:self.enterpriseBtn.bounds options:options owner:self userInfo:dic1];
    [self.enterpriseBtn addTrackingArea:area1];
    
    NSDictionary *dic2 = @{@"area":@"2"};
    NSTrackingArea *area2 = [[NSTrackingArea alloc] initWithRect:self.cloudBtn.bounds options:options owner:self userInfo:dic2];
    [self.cloudBtn addTrackingArea:area2];
    
    isOnloginPage = NO;
    isOnJoinPage  = NO;
    isshow = NO;
    iscanchoose = YES;
    
    //histroy call number Array
    _dataArray = [NSMutableArray array];
    NSArray *arrayDate = [NSUSERDEFAULT objectForKey:@"HISTORYCALL"];
    if (arrayDate) {
        [_dataArray addObjectsFromArray:arrayDate];
    }
    
    tabBg.hidden = YES;
    tab.delegate = self;
    tab.dataSource = self;
    tab.rowHeight = 24;
    tab.usesAlternatingRowBackgroundColors = YES;
    tab.selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone;
    
    joinMeetingConfIdFd.cell.usesSingleLineMode = YES;
    joinMeetingConfIdFd.delegate = self;
}

- (void)mouseDown:(NSEvent *)event
{
    tabBg.hidden = YES;
    isshow = NO;
}

- (void)awakeFromNib{
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
        self.joinMeetingConfIdFd.stringValue = confId;
        self->tabBg.hidden = YES;
        self->isshow = NO;
    }];
    return cellView;
}

//选中的响应
-(void)tableViewSelectionDidChange:(nonnull NSNotification *)notification{
    CustomCell *tableView = notification.object;
    joinMeetingConfIdFd.stringValue = tableView.test.stringValue;
    tabBg.hidden = YES;
}

//Get user set info
- (void)getSetInfo
{
    NSDictionary *infoDic = [PlistUtils loadUserInfoPlistFilewithFileName:SETINFO];
    if (infoDic[@"port"]) {
        portTextFd.stringValue = infoDic[@"port"];
    }
    if (infoDic[@"http"]) {
        if ([infoDic[@"http"] isEqualToString:@"https"]) {
            httpBtn.state = NSOnState;
        }else {
            httpBtn.state = NSOffState;
        }
    }
}

/**
 Set the EnterpriseLoginView Attribute
 */
- (void)setEnterpriseLoginViewAttribute
{
    [enterpriseLoginView setWantsLayer:YES];
    enterpriseLoginView.layer.backgroundColor = WHITECOLOR.CGColor;
    [enterpriseLoginView setAroundshadow];
    
    [joinView setWantsLayer:YES];
    [loginView setWantsLayer:YES];
    joinView.layer.backgroundColor = YELLOWCOLOR.CGColor;
    loginView.layer.backgroundColor = BLUECOLOR.CGColor;
    joinView.layer.cornerRadius = 4;
    loginView.layer.cornerRadius = 4;
}

/**
 Set the UserLoginView Attribute
 */
- (void)setUserLoginViewAttribute
{
    [userLoginView setWantsLayer:YES];
    userLoginView.layer.backgroundColor = WHITECOLOR.CGColor;
    [userLoginView setAroundshadow];
    
    serverTextFd.focusRingType = NSFocusRingTypeNone;
    [serverTextFd setBackgroundColor:DEFAULREDCOLOR];
    userTextFd.focusRingType = NSFocusRingTypeNone;
    passwordTextFd.focusRingType = NSFocusRingTypeNone;
    
    [userLoginViewBg setWantsLayer:YES];
    userLoginViewBg.layer.backgroundColor = BLUECOLOR.CGColor;
    userLoginViewBg.layer.cornerRadius = 4;
}

/**
 Set the AdvancedSetView Attribute
 */
- (void)setAdvancedSetViewAttribute
{
    [AdvancedSetView setWantsLayer:YES];
    AdvancedSetView.layer.backgroundColor = WHITECOLOR.CGColor;
    [AdvancedSetView setAroundshadow];
    
    portTextFd.focusRingType = NSFocusRingTypeNone;
    
    advancedsureView.wantsLayer = YES;
    advancedsureView.layer.cornerRadius = 4;
    advancedsureView.layer.backgroundColor = BLUECOLOR.CGColor;
    
    advancedcancelView.wantsLayer = YES;
    advancedcancelView.layer.cornerRadius = 4;
    advancedcancelView.layer.borderWidth = 0.5;
    advancedcancelView.layer.borderColor = TITLECOLOR.CGColor;
}

/**
 Set the JoinMeetingView Attribute
 */
- (void)setJoinMeetingViewAttribute
{
    joinMeetingView.wantsLayer = YES;
    joinMeetingView.layer.backgroundColor = WHITECOLOR.CGColor;
    [joinMeetingView setAroundshadow];
    
    joinMeetingserverFd.focusRingType = NSFocusRingTypeNone;
    joinMeetingConfIdFd.focusRingType = NSFocusRingTypeNone;
    joinMeetingDisNameFd.focusRingType = NSFocusRingTypeNone;
    joinMeetingDisNameFd.delegate = self;
    
    joinMeetingBg.wantsLayer = YES;
    joinMeetingBg.layer.cornerRadius = 4;
    joinMeetingBg.layer.backgroundColor = BLUECOLOR.CGColor;
}

/**
 Language localization
 */
- (void)languageLocalization
{
    //addObserver
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage:) name:CHANGELANGUAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getuserAutoLoginInfo) name:AUTOLOGIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeWindow) name:CLOSELOGINWINDOW object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showWindow:) name:SHOWLOGINWINDOW object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(anonymouslocationWebLogin:) name:ANONYMOUSLOCATIONWEBLOGIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autoWebLogin:) name:AUTOWEBLOGINJOIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(portmpt:) name:PORTMPT object:nil];
    //初始化应用语言
    [LanguageTool initUserLanguage];
    
    _privateDeploymentTitle.stringValue = localizationBundle(@"login.window.private.cloud");
    _cloudTitle.stringValue = localizationBundle(@"login.window.cloud.user");
    [enterpriseLoginbackButton changeLeftButtonattribute:localizationBundle(@"alert.back") color:TITLECOLOR];
    [joinMeetingBtn changeCenterButtonattribute:localizationBundle(@"login.window.join.meeting") color:WHITECOLOR];
    [loginBtn changeCenterButtonattribute:localizationBundle(@"login.window.login") color:WHITECOLOR];
    [userLoginViewLoginBtn changeCenterButtonattribute:localizationBundle(@"login.window.login") color:WHITECOLOR];
    [userLoginBackBtn changeLeftButtonattribute:localizationBundle(@"alert.back") color:TITLECOLOR];
    [advancedsetBtn changeCenterButtonattribute:localizationBundle(@"login.window.advanced.settings") color:BLUECOLOR];
    [advancedBackBtn changeLeftButtonattribute:localizationBundle(@"alert.back") color:TITLECOLOR];
    [settingBtn changeLeftButtonattribute:localizationBundle(@"home.left.settitle") color:BLUECOLOR];
    [advancedsureBtn changeCenterButtonattribute:localizationBundle(@"alert.sure") color:WHITECOLOR];
    [advancedcancelBtn changeCenterButtonattribute:localizationBundle(@"alert.cancel") color:CONTENTCOLOR];
    [joinadvancedsetBtn changeCenterButtonattribute:localizationBundle(@"login.window.advanced.settings") color:TITLECOLOR];
    [joinMeetingBackBtn changeLeftButtonattribute:localizationBundle(@"alert.back") color:TITLECOLOR];
    [anonymousjoinMeetingBtn changeCenterButtonattribute:localizationBundle(@"login.window.join") color:WHITECOLOR];
    [applyBtn changeCenterButtonattribute:localizationBundle(@"login.window.applyfortrial") color:BLUECOLOR];
    [videoBtn changeLeftButtonattribute:localizationBundle(@"home.join.camera") color:BLACKCOLOR];
    [muteBtn changeLeftButtonattribute:localizationBundle(@"home.join.mute") color:BLACKCOLOR];
    
    portTextFd.placeholderString = localizationBundle(@"login.window.advanced.port");
    advanceTitleFd.stringValue = localizationBundle(@"login.window.advanced.settings");
    serverTextFd.placeholderString = localizationBundle(@"login.window.servertf");
    userTextFd.placeholderString = localizationBundle(@"login.window.usertf");
    passwordTextFd.placeholderString = localizationBundle(@"login.window.passwordtf");
    loginImageTitle.image = [NSImage imageNamed:localizationBundle(@"Image.Company")];
    enterpriseImageTitle.image = [NSImage imageNamed:localizationBundle(@"Image.Company")];
    joinMeetingserverFd.placeholderString = localizationBundle(@"login.window.servertf");
    joinMeetingConfIdFd.placeholderString = localizationBundle(@"login.window.confid");
    joinMeetingDisNameFd.placeholderString = localizationBundle(@"login.window.displayname");
    joinMeetingTitleFd.stringValue = localizationBundle(@"login.window.join.meeting");
}

// if user choose auto login. app can auto login.
- (void)getuserAutoLoginInfo
{
    if ([[NSUSERDEFAULT objectForKey:@"canautoLogin"] isEqualToString:@"1"]) {
        [NSUSERDEFAULT setValue:@"2" forKey:@"canautoLogin"];
        [NSUSERDEFAULT synchronize];
        return;
    }
    NSDictionary *infoDic = [PlistUtils loadUserInfoPlistFilewithFileName:SETINFO];
    if (infoDic[@"autoLog"]) {
        if ([infoDic[@"autoLog"] isEqualToString:@"YES"]) {
            if ([infoDic[@"iscloudLogin"] isEqualToString:@"YES"]) {
                //autocloudlogin
                isCloundLogin = YES;
            }else {
                isCloundLogin = NO;
            }
            [self loginAction:nil];
            [self userLoginAction:nil];
        }
    }
    
}

#pragma mark - NSButton Method
/** Enterprise Login View */
- (IBAction)backAction:(id)sender
{
    if (sender == enterpriseLoginbackButton) {
        homeView.hidden = NO;
        [self setRightAnimation:enterpriseLoginView];
        enterpriseLoginConstraint.constant = SCREENWIDTH;
    }else if (sender == userLoginBackBtn) {
        isOnloginPage = NO;
        enterpriseLoginView.hidden = NO;
        [self setRightAnimation:userLoginView];
        userLoginViewConstraint.constant = SCREENWIDTH;
    }else if (sender == advancedBackBtn) {
        if (isSet) {
            userLoginView.hidden = NO;
            [self setRightAnimation:AdvancedSetView];
            AdvancedsetViewConstraint.constant = SCREENWIDTH;
        }else {
            joinMeetingView.hidden = NO;
            [self setRightAnimation:AdvancedSetView];
            AdvancedsetViewConstraint.constant = SCREENWIDTH;
        }
    }else if (sender == joinMeetingBackBtn) {
        isOnJoinPage = NO;
        enterpriseLoginView.hidden = NO;
        [self setRightAnimation:joinMeetingView];
        joinMeetingViewConstraint.constant = SCREENWIDTH;
    }else if (sender == videoBtn) {
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
    }
}

/** LoginView */
- (IBAction)JumpenterpriseAction:(id)sender
{
    isCloundLogin = NO;
    applyBtn.hidden = YES;
    advancedsetBtn.hidden = NO;
    
    [self getUserDataInfo];
    
    loginViewTitle.stringValue = localizationBundle(@"login.window.private.cloud");
    [self setLeftAnimation:enterpriseLoginView];
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        self->homeView.hidden = YES;
    });

    enterpriseLoginConstraint.constant = 0;
}

- (IBAction)jumpcloudAction:(id)sender
{
    isCloundLogin = YES;
    applyBtn.hidden = NO;
    advancedsetBtn.hidden = YES;
    
    [self getUserDataInfo];
    
    loginViewTitle.stringValue = localizationBundle(@"login.window.cloud.user");
    [self setLeftAnimation:enterpriseLoginView];
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        self->homeView.hidden = YES;
    });
    
    enterpriseLoginConstraint.constant = 0;
}

/**
 Join meeting Action (Private deployment and Clound)

 @param sender joinMeetingBtn
 */
- (IBAction)joinMeetingAciton:(id)sender
{
    NSDictionary * dic = [NSUSERDEFAULT objectForKey:@"AnonymousInformation"];
    isLoginOranonymousLogin = NO;
    isOnJoinPage = YES;
    [joinMeetingConfIdFd becomeFirstResponder];
    if (isCloundLogin) {
        if (dic) {
            joinMeetingConfIdFd.stringValue = dic[@"confId"];
            joinMeetingDisNameFd.stringValue = dic[@"disName"];
        }
        joinMeetingserverFd.hidden = YES;
        joinadvancedsetBtn.hidden = YES;
        joinMeetingchangeConstraint.constant = 30;
    }else{
        if (dic) {
            joinMeetingserverFd.stringValue = dic[@"server"];
            joinMeetingConfIdFd.stringValue = dic[@"confId"];
            joinMeetingDisNameFd.stringValue = dic[@"disName"];
        }
        joinMeetingserverFd.hidden = NO;
        joinadvancedsetBtn.hidden = NO;
        joinMeetingchangeConstraint.constant = 60;
    }
    
    isSet = NO;
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        self->enterpriseLoginView.hidden = YES;
    });
    joinMeetingViewConstraint.constant = 0;
    
    [self setLeftAnimation:joinMeetingView];
}

/**
 Login Action (Private deployment and Clound)
 
 @param sender loginBtn
 */
- (IBAction)loginAction:(id)sender
{
    isSet = YES;
    isLoginOranonymousLogin = YES;
    [userTextFd becomeFirstResponder];
    isOnloginPage = YES;
    if (isCloundLogin) {
        
        NSMutableDictionary *pdic = [NSUSERDEFAULT objectForKey:@"Ylogin"];
        if (pdic) {
            userTextFd.stringValue = pdic[@"accout"];
            passwordTextFd.stringValue = pdic[@"password"];
        }
        
    }else {
        NSMutableDictionary *pdic = [NSUSERDEFAULT objectForKey:@"Qlogin"];
        if (pdic) {
            serverTextFd.stringValue = pdic[@"server"];
            userTextFd.stringValue = pdic[@"accout"];
            passwordTextFd.stringValue = pdic[@"password"];
        }
    }
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        self->enterpriseLoginView.hidden = YES;
    });
    
    
    if (isCloundLogin) {
        [self setLeftAnimation:userLoginView];
        userLoginViewConstraint.constant = 0;
        userLoginViewTitle.stringValue = localizationBundle(@"login.window.cloud.login");
        userTextFdConstraint.constant = 30;
        serverTextFd.hidden = YES;
    }else{
        [self setLeftAnimation:userLoginView];
        userLoginViewConstraint.constant = 0;
        userLoginViewTitle.stringValue = localizationBundle(@"login.window.private.login");
        userTextFdConstraint.constant = 60;
        serverTextFd.hidden = NO;
    }
}

/**
 User Login Action

 @param sender User Login View Login Btn
 */
- (IBAction)userLoginAction:(id)sender
{
    //remove the blank space
    //Delay of 1 second,sometimes sdk have no reaction.
    hub.hidden = NO;
    hub.hudTitleFd.stringValue = localizationBundle(@"alert.connection");
    [self persendMethod:30];
    [self performSelector:@selector(login) withObject:self afterDelay:1];
}

- (void)login
{
    [self getEVSDK];
    serverStr   = [EVUtils removeTheStringBlankSpace:serverTextFd.stringValue];
    NSString *userStr     = [EVUtils removeTheStringBlankSpace:userTextFd.stringValue];
    passwordStr           = [EVUtils removeTheStringBlankSpace:passwordTextFd.stringValue];
    if (isCloundLogin) {
        [appDelegate.evengine enableSecure:NO];
    }else {
        NSDictionary *infoDic = [PlistUtils loadUserInfoPlistFilewithFileName:SETINFO];
        
        if ([infoDic[@"http"] isEqualToString:@"https"]) {
            [appDelegate.evengine enableSecure:YES];
        }else {
            [appDelegate.evengine enableSecure:NO];
        }
    }
    
    if (!isCloundLogin) {
        if (serverStr.length == 0) {
            hub.hidden = NO;
            hub.hudTitleFd.stringValue = localizationBundle(@"alert.writeServerAddress");
            [self persendMethod:2];
            userLoginViewBg.alphaValue = 0.5;
            userLoginViewLoginBtn.enabled = NO;
            double delayInSeconds = 3;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                self->userLoginViewBg.alphaValue = 1;
                self->userLoginViewLoginBtn.enabled = YES;
            });
            return;
        }
    }
    if (userStr.length == 0 || passwordStr.length == 0) {
        hub.hidden = NO;
        hub.hudTitleFd.stringValue = localizationBundle(@"alert.writePassWord");
        [self persendMethod:2];
        userLoginViewBg.alphaValue = 0.5;
        userLoginViewLoginBtn.enabled = NO;
        double delayInSeconds = 3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self->userLoginViewBg.alphaValue = 1;
            self->userLoginViewLoginBtn.enabled = YES;
        });
        return;
    }
    
    passwordStr = [appDelegate.evengine encryptPassword:passwordStr];
    
    //获取port
    NSString *portStr = [PlistUtils loadUserInfoPlistFilewithFileName:SETINFO][@"port"];
    
    if (isCloundLogin) {
        //CloundLogin
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        DDLogInfo(@"[Info] 10001 loginInfo server:%@ port:%@ name:%@ password:%@", infoDictionary[@"CLOUD_LOCATION_SERVER_ADDRESS"], portStr, userStr, passwordStr);
        [appDelegate.evengine enableSecure:YES];
        serverStr = infoDictionary[@"CLOUD_LOCATION_SERVER_ADDRESS"];
        [appDelegate.evengine loginWithLocation:serverStr port:0 name:userStr password:passwordStr];
    }else {
        //EnterpriseLogin
        [appDelegate.evengine loginWithLocation:serverStr port:[portStr intValue] name:userStr password:passwordStr];
        DDLogInfo(@"[Info] 10001 loginInfo server:%@ port:%@ name:%@ password:%@", serverStr, portStr, userStr, passwordStr);
    }
}

/**
 advanced setting action

 @param sender Advanced Setting
 */
- (IBAction)setAction:(id)sender
{
    [self setLeftAnimation:AdvancedSetView];
    
    [self getSetInfo];
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        if (self->isSet) {
            self->userLoginView.hidden = YES;
        }else {
            self->joinMeetingView.hidden = YES;
        }
    });
    
    AdvancedsetViewConstraint.constant = 0;
}

/**
 anonymous join meeting Action

 @param sender anonymousBtn
 */
- (IBAction)anonymousJoinMeetingAction:(id)sender
{
    serverStr  = [EVUtils removeTheStringBlankSpace:joinMeetingserverFd.stringValue];
    NSString *confIdStr  = [EVUtils removeTheStringBlankSpace:joinMeetingConfIdFd.stringValue];
    NSString *disNameStr = [EVUtils removeTheStringBlankSpace:joinMeetingDisNameFd.stringValue];
    
    NSString *port;
    
    if (!isCloundLogin) {
        
        NSDictionary *infoDic = [PlistUtils loadUserInfoPlistFilewithFileName:SETINFO];
        if (infoDic[@"port"]) {
            port = infoDic[@"port"];
        }
        
        if ([infoDic[@"http"] isEqualToString:@"https"]) {
            [appDelegate.evengine enableSecure:YES];
        }else {
            [appDelegate.evengine enableSecure:NO];
        }
        
        if (serverStr.length == 0) {
            hub.hidden = NO;
            hub.hudTitleFd.stringValue = localizationBundle(@"alert.writeServerAddress");
            [self persendMethod:2];
            joinMeetingBg.alphaValue = 0.5;
            anonymousjoinMeetingBtn.enabled = NO;
            double delayInSeconds = 3;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                self->joinMeetingBg.alphaValue = 1;
                self->anonymousjoinMeetingBtn.enabled = YES;
            });
            return;
        }
    }else {
        [appDelegate.evengine enableSecure:NO];
    }
    if (confIdStr.length == 0) {
        hub.hidden = NO;
        hub.hudTitleFd.stringValue = localizationBundle(@"alert.writeConfId");
        [self persendMethod:2];
        joinMeetingBg.alphaValue = 0.5;
        anonymousjoinMeetingBtn.enabled = NO;
        double delayInSeconds = 3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self->joinMeetingBg.alphaValue = 1;
            self->anonymousjoinMeetingBtn.enabled = YES;
        });
        return;
    }
    
    if (disNameStr.length == 0) {
        disNameStr = [EVUtils judgeString:NSUserName()];
    }
    
    [NSUSERDEFAULT setValue:@"YES" forKey:@"anonymous"];
    [NSUSERDEFAULT synchronize];
    [appDelegate.evengine setUserImage:[EVUtils bundleFile:@"bg_videomute.png"] filename:[EVUtils bundleFile:@"image_defaultuser.png"]];
    DDLogInfo(@"[Info] 10028 user anonymous logins");
    if (isCloundLogin) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        [dic setValue:infoDictionary[@"CLOUD_LOCATION_SERVER_ADDRESS"] forKey:@"server"];
        [dic setValue:port forKey:@"port"];
        [dic setValue:disNameStr forKey:@"disName"];
        [dic setValue:confIdStr forKey:@"confId"];
        [appDelegate.evengine enableSecure:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:ANONYMOUSLOCATIONLOGIN object:dic];
    }else {
        NSDictionary *infoDic = [PlistUtils loadUserInfoPlistFilewithFileName:SETINFO];
        if ([infoDic[@"http"] isEqualToString:@"https"]) {
            [appDelegate.evengine enableSecure:YES];
        }else {
            [appDelegate.evengine enableSecure:NO];
        }
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:serverStr forKey:@"server"];
        [dic setValue:port forKey:@"port"];
        [dic setValue:disNameStr forKey:@"disName"];
        [dic setValue:confIdStr forKey:@"confId"];
        [[NSNotificationCenter defaultCenter] postNotificationName:ANONYMOUSLOCATIONLOGIN object:dic];
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:disNameStr forKey:@"disName"];
    [dic setValue:confIdStr forKey:@"confId"];
    [dic setValue:serverStr forKey:@"server"];
    
    [NSUSERDEFAULT setObject:dic forKey:@"AnonymousInformation"];
    [NSUSERDEFAULT synchronize];
    
    hub.hidden = NO;
    hub.hudTitleFd.stringValue = localizationBundle(@"alert.connection");
    [self persendMethod:5];
    
    NSMutableDictionary *setDic = [NSMutableDictionary dictionaryWithDictionary:[PlistUtils loadUserInfoPlistFilewithFileName:SETINFO]];
        [setDic setValue:confIdStr forKey:@"confId"];
    [PlistUtils saveUserInfoPlistFile:(NSDictionary *)setDic withFileName:SETINFO];
    
}

- (IBAction)advanceBtnAction:(id)sender
{
    if (sender == advancedsureBtn) {
        NSString *portStr = [EVUtils removeTheStringBlankSpace:portTextFd.stringValue];
        
        if (portStr.length != 0) {
            if (![EVUtils isPureNum:portStr]) {
                hub.hidden = NO;
                hub.hudTitleFd.stringValue = localizationBundle(@"alert.onlynumber");
                [self persendMethod:2];
                return;
            }
        }
        NSMutableDictionary *advanceDic = [NSMutableDictionary dictionaryWithDictionary:[PlistUtils loadUserInfoPlistFilewithFileName:SETINFO]];
        [advanceDic setValue:portStr forKey:@"port"];
        if (httpBtn.state == NSOffState) {
            [advanceDic setValue:@"http" forKey:@"http"];
            [appDelegate.evengine enableSecure:NO];
        }else {
            [advanceDic setValue:@"https" forKey:@"http"];
            [appDelegate.evengine enableSecure:YES];
        }
        [PlistUtils saveUserInfoPlistFile:(NSDictionary *)advanceDic withFileName:SETINFO];
        
        if (isSet) {
            userLoginView.hidden = NO;
            [self setRightAnimation:AdvancedSetView];
            AdvancedsetViewConstraint.constant = SCREENWIDTH;
        }else {
            joinMeetingView.hidden = NO;
            [self setRightAnimation:AdvancedSetView];
            AdvancedsetViewConstraint.constant = SCREENWIDTH;
        }
        
    }else if (sender == advancedcancelBtn) {
        if (isSet) {
            userLoginView.hidden = NO;
            [self setRightAnimation:AdvancedSetView];
            AdvancedsetViewConstraint.constant = SCREENWIDTH;
        }else {
            joinMeetingView.hidden = NO;
            [self setRightAnimation:AdvancedSetView];
            AdvancedsetViewConstraint.constant = SCREENWIDTH;
        }
    }
}

- (IBAction)applyAction:(id)sender
{
   // [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:infoPlistStringBundle(@"applyUrl")]];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];

    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[[infoDictionary objectForKey:@"CLOUD_TRIAL_URL"] stringByReplacingOccurrencesOfString:@"\\" withString:@""]]];
}

/**
 close the window

 @param sender button
 */
- (IBAction)closeWindowAction:(id)sender
{
    exit(0);
}

#pragma mark - Mouse
- (void)mouseEntered:(NSEvent *)theEvent {
    NSDictionary *dic = theEvent.userData;
    if ([dic[@"area"] isEqualToString:@"1"]) {
        _enterpriseBg.hidden = NO;
    }else{
        _cloudBg.hidden = NO;
    }
}

- (void)mouseExited:(NSEvent *)theEvent {
    NSDictionary *dic = theEvent.userData;
    if ([dic[@"area"] isEqualToString:@"1"]) {
        _enterpriseBg.hidden = YES;
    }else{
        _cloudBg.hidden = YES;
    }
}

#pragma mark - animation
- (void)setLeftAnimation:(NSView *)animationView
{
    CABasicAnimation *basicAni   = [CABasicAnimation animation];
    basicAni.keyPath             = @"position";
    basicAni.fromValue           = [NSValue valueWithPoint:NSMakePoint(SCREENWIDTH, 0)];
    basicAni.toValue             = [NSValue valueWithPoint:NSMakePoint(0, 0)];
    basicAni.duration            = 0.5;
    basicAni.fillMode            = kCAFillModeForwards;
    basicAni.removedOnCompletion = NO;
    [animationView.layer addAnimation:basicAni forKey:nil];
}

- (void)setRightAnimation:(NSView *)animationView
{
    CABasicAnimation *basicAni   = [CABasicAnimation animation];
    basicAni.keyPath             = @"position";
    basicAni.fromValue           = [NSValue valueWithPoint:NSMakePoint(0, 0)];
    basicAni.toValue             = [NSValue valueWithPoint:NSMakePoint(SCREENWIDTH, 0)];
    basicAni.duration            = 0.5;
    basicAni.fillMode            = kCAFillModeForwards;
    basicAni.removedOnCompletion = NO;
    [animationView.layer addAnimation:basicAni forKey:nil];
}

#pragma mark - KEYDOWN(private or cloud join and login)
- (IBAction)joinkeydown:(id)sender
{
    if (isOnJoinPage) {
        [self anonymousJoinMeetingAction:nil];
    }
}

- (IBAction)loginkeydown:(id)sender
{
    if (isOnloginPage) {
        [self userLoginAction:nil];
    }
}

#pragma mark - Get user data info
- (void)getUserDataInfo
{
    serverTextFd.stringValue   = @"";
    userTextFd.stringValue     = @"";
    passwordTextFd.stringValue = @"";
    
    joinMeetingDisNameFd.stringValue = @"";
    joinMeetingConfIdFd.stringValue  = @"";
    joinMeetingserverFd.stringValue  = @"";
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

#pragma mark - EVEngineDelegate
-(void)onError:(EVError *)err {
    dispatch_async(dispatch_get_main_queue(), ^{
        DDLogError(@"[Error] 10002 loginError type: %lu, code:%u,  msg: %@", (unsigned long)err.type, err.code, err.msg);
        if (err.type == EVErrorTypeServer) {
            //sdk error don't have to remind.
            if (err.code == 1101) {
                self->hub.hudTitleFd.stringValue = [NSString stringWithFormat:@"%@%@%@", localizationBundle(@"alert.passworderror1"), err.args[0], localizationBundle(@"alert.passworderror2")];
                [self->appDelegate.evengine logout];
                [self persendMethod:2];
            }else if (err.code == 1102) {
                self->hub.hudTitleFd.stringValue = localizationBundle(@"alert.passworderror3");
                [self persendMethod:2];
            }else if (err.code == 1100) {
                self->hub.hudTitleFd.stringValue = localizationBundle(@"errorcode.1100");
                [self persendMethod:2];
            }else if (err.code == 1112) {
                self->hub.hudTitleFd.stringValue = localizationBundle(@"error.1112");
                [self persendMethod:2];
            }else {
                self->hub.hudTitleFd.stringValue = localizationBundle(@"alert.cantconnert.server");
                [self persendMethod:2];
            }
        }else if (err.type == EVErrorTypeLocate) {
            if (err.code == 10009) {
                self->hub.hudTitleFd.stringValue = [NSString stringWithFormat:@"%@", localizationBundle(@"error.10009")];
                [self persendMethod:3];
            }
        }else {
            self->hub.hudTitleFd.stringValue = [NSString stringWithFormat:@"%@", localizationBundle(@"alert.cantconnert.server")];
            self->hub.hidden = NO;
            [self persendMethod:3];
        }
    });
}

- (void)onLoginSucceed:(EVUserInfo *)user {
    DDLogInfo(@"[Info] 10003 LoginSucceed username:%@, displayName: %@, org: %@, cellphone: %@, email: %@", user.username, user.displayName, user.org, user.cellphone, user.email);
    //need save user Info
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *downloadimagepath = [[EVUtils get_current_app_path]stringByAppendingPathComponent:@"header.jpg"];
        [self->appDelegate.evengine downloadUserImage:downloadimagepath];
        if (self->isCloundLogin) {
            NSDictionary *userInfo = @{@"username":user.username, @"displayName":user.displayName, @"org":user.org, @"cellphone":user.cellphone, @"email":user.email, @"telephone":user.telephone, @"server":infoPlistStringBundle(@"CloudServerAddress"), @"password":@"", @"token":user.token, @"customizedH5UrlPrefix":user.customizedH5UrlPrefix, @"locationServer":self->serverStr};
            [PlistUtils saveUserInfoPlistFile:userInfo withFileName:CLOUDUSERINFO];
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

            NSMutableDictionary *pdic = [[NSMutableDictionary alloc] init];
            [pdic setValue:self->userTextFd.stringValue forKey:@"accout"];
            [pdic setValue:self->passwordTextFd.stringValue forKey:@"password"];
            
            [NSUSERDEFAULT setObject:pdic forKey:@"Ylogin"];
            [NSUSERDEFAULT synchronize];
            
        }else {
            NSDictionary *userInfo = @{@"username":user.username, @"displayName":user.displayName, @"org":user.org, @"cellphone":user.cellphone, @"email":user.email, @"telephone":user.telephone, @"server":self->serverTextFd.stringValue, @"password":@"", @"token":user.token,@"customizedH5UrlPrefix":user.customizedH5UrlPrefix, @"locationServer":self->serverStr};
            [PlistUtils saveUserInfoPlistFile:userInfo withFileName:PRIVATEUSERINFO];
            
            NSMutableDictionary *setDic = [NSMutableDictionary dictionaryWithDictionary:[PlistUtils loadUserInfoPlistFilewithFileName:SETINFO]];
            [setDic setValue:@"NO" forKey:@"iscloudLogin"];
            NSNumber * boolContactWebPage = [NSNumber numberWithBool:user.featureSupport.contactWebPage];
            [setDic setValue:boolContactWebPage forKey:@"contactWebPage"];
            NSNumber * boolP2pCall = [NSNumber numberWithBool:user.featureSupport.p2pCall];
            [setDic setValue:boolP2pCall forKey:@"p2pCall"];
            NSNumber * boolChatInConference = [NSNumber numberWithBool:user.featureSupport.chatInConference];
            [setDic setValue:boolChatInConference forKey:@"chatInConference"];
            NSNumber * boolSwitchingToAudioConference = [NSNumber numberWithBool:user.featureSupport.switchingToAudioConference];
            [setDic setValue:boolSwitchingToAudioConference forKey:@"switchingToAudioConference"];
            NSNumber * boolSitenameIsChangeable = [NSNumber numberWithBool:user.featureSupport.sitenameIsChangeable];
            [setDic setValue:boolSitenameIsChangeable forKey:@"sitenameIsChangeable"];
            [PlistUtils saveUserInfoPlistFile:setDic withFileName:SETINFO];
            
            NSMutableDictionary *pdic = [[NSMutableDictionary alloc] init];
            [pdic setValue:self->serverTextFd.stringValue forKey:@"server"];
            [pdic setValue:self->userTextFd.stringValue forKey:@"accout"];
            [pdic setValue:self->passwordTextFd.stringValue forKey:@"password"];
            
            [NSUSERDEFAULT setObject:pdic forKey:@"Qlogin"];
            [NSUSERDEFAULT synchronize];
        }
        
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
        
        if (!self->appDelegate.islogin) {
            HomeWindowController *WinControl = [HomeWindowController windowController];
            
            self->appDelegate = APPDELEGATE;
            self->appDelegate.mainWindowController = WinControl;
            [WinControl.window makeKeyAndOrderFront:self];
        }
        self->appDelegate.islogin = YES;
        [self persendMethod:0];
        [self.view.window orderOut:self];
        
        Notifications(UPDATETOKEN);
    });
}

#pragma mark - Notification
/**
 Toggle language

 @param sender Notification
 */
- (void)changeLanguage:(NSNotification *)sender
{
    _privateDeploymentTitle.stringValue = localizationBundle(@"login.window.private.cloud");
    _cloudTitle.stringValue = localizationBundle(@"login.window.cloud.user");
    [enterpriseLoginbackButton changeLeftButtonattribute:localizationBundle(@"alert.back") color:TITLECOLOR];
    _privateDeploymentTitle.stringValue = localizationBundle(@"login.window.private.cloud");
    _cloudTitle.stringValue = localizationBundle(@"login.window.cloud.user");
    [enterpriseLoginbackButton changeLeftButtonattribute:localizationBundle(@"alert.back") color:TITLECOLOR];
    [joinMeetingBtn changeCenterButtonattribute:localizationBundle(@"login.window.join.meeting") color:WHITECOLOR];
    [loginBtn changeCenterButtonattribute:localizationBundle(@"login.window.login") color:WHITECOLOR];
    [userLoginViewLoginBtn changeCenterButtonattribute:localizationBundle(@"login.window.login") color:WHITECOLOR];
    [userLoginBackBtn changeLeftButtonattribute:localizationBundle(@"alert.back") color:TITLECOLOR];
    [advancedsetBtn changeCenterButtonattribute:localizationBundle(@"login.window.advanced.settings") color:BLUECOLOR];
    [advancedBackBtn changeLeftButtonattribute:localizationBundle(@"alert.back") color:TITLECOLOR];
    [settingBtn changeLeftButtonattribute:localizationBundle(@"home.left.settitle") color:BLUECOLOR];
    [advancedsureBtn changeCenterButtonattribute:localizationBundle(@"alert.sure") color:WHITECOLOR];
    [advancedcancelBtn changeCenterButtonattribute:localizationBundle(@"alert.cancel") color:CONTENTCOLOR];
    [joinadvancedsetBtn changeCenterButtonattribute:localizationBundle(@"login.window.advanced.settings") color:TITLECOLOR];
    [joinMeetingBackBtn changeLeftButtonattribute:localizationBundle(@"alert.back") color:TITLECOLOR];
    [anonymousjoinMeetingBtn changeCenterButtonattribute:localizationBundle(@"login.window.join") color:WHITECOLOR];
    [applyBtn changeCenterButtonattribute:localizationBundle(@"login.window.applyfortrial") color:BLUECOLOR];
    [videoBtn changeLeftButtonattribute:localizationBundle(@"home.join.camera") color:TITLECOLOR];
    [muteBtn changeLeftButtonattribute:localizationBundle(@"home.join.mute") color:TITLECOLOR];
    
    portTextFd.placeholderString = localizationBundle(@"login.window.advanced.port");
    advanceTitleFd.stringValue = localizationBundle(@"login.window.advanced.settings");
    if (isCloundLogin) {
        loginViewTitle.stringValue = localizationBundle(@"login.window.cloud.user");
    }else {
        loginViewTitle.stringValue = localizationBundle(@"login.window.private.cloud");
    }
    serverTextFd.placeholderString = localizationBundle(@"login.window.servertf");
    userTextFd.placeholderString = localizationBundle(@"login.window.usertf");
    passwordTextFd.placeholderString = localizationBundle(@"login.window.passwordtf");
    loginImageTitle.image = [NSImage imageNamed:localizationBundle(@"Image.Company")];
    enterpriseImageTitle.image = [NSImage imageNamed:localizationBundle(@"Image.Company")];
    joinMeetingserverFd.placeholderString = localizationBundle(@"login.window.servertf");
    joinMeetingConfIdFd.placeholderString = localizationBundle(@"login.window.confid");
    joinMeetingDisNameFd.placeholderString = localizationBundle(@"login.window.displayname");
    joinMeetingTitleFd.stringValue = localizationBundle(@"login.window.join.meeting");
}

//close the login window
- (void)closeWindow
{
    hub.hidden = YES;
    [self.view.window orderOut:nil];
}

//show the login window
- (void)showWindow:(NSNotification *)sender
{
    appDelegate.mainWindowController = self.view.window.windowController;
    [self.view.window orderFront:nil];
    if ([[NSUSERDEFAULT objectForKey:@"needAutoLogin"] isEqualToString:@"YES"]) {
        [NSUSERDEFAULT setValue:@"NO" forKey:@"needAutoLogin"];
        [NSUSERDEFAULT synchronize];
        NSDictionary *infoDic = [PlistUtils loadUserInfoPlistFilewithFileName:SETINFO];
        if ([infoDic[@"iscloudLogin"] isEqualToString:@"YES"]) {
            //autocloudlogin
            isCloundLogin = YES;
        }else {
            isCloundLogin = NO;
        }
        [self loginAction:nil];
        [self userLoginAction:nil];
    }else {
        if (sender.object != nil) {
            //匿名登录
            NSDictionary *data = sender.object;
            if ([data[@"protocol"] isEqualToString:@"https"]) {
                [appDelegate.evengine enableSecure:YES];
            }else {
                [appDelegate.evengine enableSecure:NO];
            }
            NSString *disNameStr = data[@"displayname"];
            if (disNameStr.length == 0) {
                disNameStr = [EVUtils judgeString:NSUserName()];
            }
            
            [NSUSERDEFAULT setValue:@"YES" forKey:@"anonymous"];
            [NSUSERDEFAULT synchronize];
            [NSUSERDEFAULT setValue:@"YES" forKey:@"needAutoLogin"];
            [NSUSERDEFAULT synchronize];
            [appDelegate.evengine setUserImage:[EVUtils bundleFile:@"bg_videomute.png"] filename:[EVUtils bundleFile:@"image_defaultuser.png"]];
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setValue:data[@"server"] forKey:@"server"];
            [dic setValue:data[@"port"] forKey:@"port"];
            [dic setValue:disNameStr forKey:@"disName"];
            [dic setValue:data[@"confid"] forKey:@"confid"];
            [dic setValue:data[@"protocol"] forKey:@"protocol"];
            if (data[@"password"] != nil) {
                [dic setValue:data[@"password"] forKey:@"password"];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:ANONYMOUSLOCATIONWEBLOGIN object:dic];
            
        }else {
            
        }
    }
}

//if receive the web login info. notice the join meeting window join meeting.
- (void)anonymouslocationWebLogin:(NSNotification *)sender
{
    hub.hidden = NO;
    anonymousDic = sender.object;
    hub.hudTitleFd.stringValue = localizationBundle(@"alert.connection");
    [self persendMethod:5];
    [self performSelector:@selector(anonymoussss2) withObject:self afterDelay:3];
}

- (void)autoWebLogin:(NSNotification *)sender
{
    HLog(@"1111111111111AUTOWEBLOGININFO");
    [NSUSERDEFAULT setValue:@"YES" forKey:@"AUTOWEBLOGIN"];
    [NSUSERDEFAULT setValue:sender.object forKey:@"AUTOWEBLOGININFO"];
    [NSUSERDEFAULT synchronize];
}

//How many seconds later, hub dismiss.
- (void)portmpt:(NSNotification *)sender
{
    NSString *str = sender.object;
    if ([str isEqualToString:@"1001"]) {
        self->hub.hidden = NO;
        self->hub.hudTitleFd.stringValue = localizationBundle(@"alert.invalidConfNumber");
    }else if ([str isEqualToString:@"2001"]) {
        self->hub.hidden = NO;
        self->hub.hudTitleFd.stringValue = localizationBundle(@"alert.cloudnotactivat");
    }else if ([str isEqualToString:@"2005"]) {
        self->hub.hidden = NO;
        self->hub.hudTitleFd.stringValue = localizationBundle(@"alert.meetingnotstart");
    }else if ([str isEqualToString:@"2031"]) {
        self->hub.hidden = NO;
        self->hub.hudTitleFd.stringValue = localizationBundle(@"alert.allowmeeting");
    }else if ([str isEqualToString:@"2033"]) {
        self->hub.hidden = NO;
        self->hub.hudTitleFd.stringValue = localizationBundle(@"alert.meetingdosenotanonymouscall");
    }else if ([str isEqualToString:@"2035"]) {
        self->hub.hidden = NO;
        self->hub.hudTitleFd.stringValue = localizationBundle(@"alert.trialexpired");
    }else if ([str isEqualToString:@"2011"]) {
        self->hub.hidden = NO;
        self->hub.hudTitleFd.stringValue = localizationBundle(@"error.2011");
    }else if ([str isEqualToString:@"2009"]) {
        self->hub.hidden = NO;
        self->hub.hudTitleFd.stringValue = localizationBundle(@"error.2009");
    }else if ([str isEqualToString:@"2024"]) {
        self->hub.hidden = NO;
        self->hub.hudTitleFd.stringValue = localizationBundle(@"error.2024");
    }else if ([str isEqualToString:@"2025"]) {
        self->hub.hidden = NO;
        self->hub.hudTitleFd.stringValue = localizationBundle(@"error.2025");
    }else if ([str isEqualToString:@"2007"]) {
        self->hub.hidden = NO;
        self->hub.hudTitleFd.stringValue = localizationBundle(@"error.2007");
    }else if ([str isEqualToString:@"10009"]) {
        self->hub.hidden = NO;
        self->hub.hudTitleFd.stringValue = localizationBundle(@"alert.invalidConfNumber");
    }else if ([str isEqualToString:@"2023"]) {
        self->hub.hidden = NO;
        self->hub.hudTitleFd.stringValue = localizationBundle(@"alert.limit");
    }else if ([str isEqualToString:@"4055"]) {
        self->hub.hidden = NO;
        self->hub.hudTitleFd.stringValue = localizationBundle(@"error.4055");
    }else {
        self->hub.hidden = NO;
        self->hub.hudTitleFd.stringValue = [NSString stringWithFormat:@"%@%@", localizationBundle(@"alert.joinmeetingerr"), str];
    }
    [self persendMethod:3];
}

- (void)anonymoussss2
{
    [self performSegueWithIdentifier:@"joinWindowSegue" sender:self];

    NSString *displayname = anonymousDic[@"displayname"];
    if (displayname.length == 0) {
        displayname = [EVUtils judgeString:NSUserName()];
    }
    if ([anonymousDic[@"protocol"] isEqualToString:@"http"]) {
        [appDelegate.evengine enableSecure:NO];
    }else {
        [appDelegate.evengine enableSecure:YES];
    }
    [NSUSERDEFAULT setValue:@"YES" forKey:@"anonymous"];
    [NSUSERDEFAULT synchronize];
    [self getEVSDK];
    Notifications(OPENVIDEO);
    [appDelegate.evengine setUserImage:[EVUtils bundleFile:@"bg_videomute.png"] filename:[EVUtils bundleFile:@"image_defaultuser.png"]];
}

#pragma Segues
- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"joinWindowSegue"]) {
        JoinWindowController *addStorageWD = segue.destinationController;
        JoinWindowViewController *viewC = (JoinWindowViewController *)addStorageWD.contentViewController;
        viewC.meetingDic = anonymousDic;
        [viewC setInfo];
    }
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

- (BOOL)isValidToVisitCamera
{
   __block BOOL bCanRecord = YES;
   
   if (@available(macOS 10.14, *)) {
       AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
       NSLog(@"status : %ld",(long)status);
       
       switch (status) {
           case AVAuthorizationStatusNotDetermined:{
               
               // 许可对话没有出现，发起授权许可
               [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                   if (granted) {
                       //第一次用户接受
                       NSLog(@"-- granted");
                       
                   }else{
                       //用户拒绝
                       NSLog(@"-- not granted");
                   }
               }];
               break;
           }
               
           case AVAuthorizationStatusAuthorized:{
               // 已经开启授权，可继续
               NSLog(@"-- Authorized");
               bCanRecord = YES;
               break;
           }
           case AVAuthorizationStatusDenied:{
               NSLog(@"-- Denied");
               bCanRecord = NO;
               break;
           }
           case AVAuthorizationStatusRestricted:{
               NSLog(@"-- Restricted");
               bCanRecord = NO;
               break;
           }
               
           default:
               break;
       }
   } else {
       // Fallback on earlier versions
   }

   return bCanRecord;
}

- (BOOL)isValidToVisitMicroPhone{
    
    __block BOOL bCanRecord = YES;
    
    if (@available(macOS 10.14, *)) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        NSLog(@"status : %ld",(long)status);
        
        switch (status) {
            case AVAuthorizationStatusNotDetermined:{
                
                // 许可对话没有出现，发起授权许可
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                    if (granted) {
                        //第一次用户接受
                        NSLog(@"-- granted");
                        
                    }else{
                        //用户拒绝
                        NSLog(@"-- not granted");
                    }
                }];
                break;
            }
                
            case AVAuthorizationStatusAuthorized:{
                // 已经开启授权，可继续
                NSLog(@"-- Authorized");
                bCanRecord = YES;
                break;
            }
            case AVAuthorizationStatusDenied:{
                NSLog(@"-- Denied");
                bCanRecord = NO;
                break;
            }
            case AVAuthorizationStatusRestricted:{
                NSLog(@"-- Restricted");
                bCanRecord = NO;
                break;
            }
                
            default:
                break;
        }
    } else {
        // Fallback on earlier versions
    }
 
    return bCanRecord;
}


//Limit words to no more than 16 digits.
- (void)controlTextDidChange:(NSNotification *)obj {
    int MaxLimit = 32;
    if ([[self.joinMeetingConfIdFd stringValue] length] > MaxLimit) {
        [self.joinMeetingConfIdFd setStringValue:[[self.joinMeetingConfIdFd stringValue] substringToIndex:MaxLimit]];
    }
} 

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CHANGELANGUAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AUTOLOGIN object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CLOSELOGINWINDOW object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SHOWLOGINWINDOW object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ANONYMOUSLOCATIONWEBLOGIN object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AUTOWEBLOGINJOIN object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PORTMPT object:nil];
}

@end
