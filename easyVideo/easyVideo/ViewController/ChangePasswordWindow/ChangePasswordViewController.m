//
//  ChangePasswordViewController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/8/23.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "macHUD.h"
#import "RootWindowController.h"

@interface ChangePasswordViewController ()<EVEngineDelegate>
{
    macHUD *hub;
    AppDelegate *appDelegate;
}
@end

@implementation ChangePasswordViewController

@synthesize topViewBg, topTitle, oldpdTitle, oldpdTF, alertTitle, newpdTitle, newpdTF, surepdTitle, surepdTF, bottomViewBg, cancelViewBg, sureViewBg, cancelBtn, sureBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self setRootViewAttribute];
    
    [self languageLocalization];
}

- (void)setRootViewAttribute
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closePdWindow) name:CLOSEPDWINDOW object:nil];
    
    [self.view setBackgroundColor:WHITECOLOR];
    [topViewBg setBackgroundColor:DEFAULTBGCOLOR];
    [bottomViewBg setBackgroundColor:DEFAULTBGCOLOR];
    [cancelViewBg setBackgroundColor:WHITECOLOR];
    [sureViewBg setBackgroundColor:BLUECOLOR];
    
    cancelViewBg.layer.cornerRadius = 4.f;
    sureViewBg.layer.cornerRadius = 4.f;
    
    appDelegate = APPDELEGATE;
    
    hub = [macHUD creatMacHUD:@"" icon:@"" viewController:self];
    hub.hidden = YES;
}

/**
 Language localization
 */
- (void)languageLocalization
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage:) name:CHANGELANGUAGE object:nil];
    
    [LanguageTool initUserLanguage];
    
    [cancelBtn changeCenterButtonattribute:localizationBundle(@"alert.cancel") color:CONTENTCOLOR];
    [sureBtn changeCenterButtonattribute:localizationBundle(@"alert.sure") color:WHITECOLOR];
    topTitle.stringValue = localizationBundle(@"home.pd.title");
    oldpdTitle.stringValue = localizationBundle(@"home.pd.oldpd");
    alertTitle.stringValue = localizationBundle(@"home.pd.alert");
    newpdTitle.stringValue = localizationBundle(@"home.pd.newpd");
    surepdTitle.stringValue = localizationBundle(@"home.pd.surepd");
    
}

#pragma mark - NSButtonMethod
- (IBAction)closeWindow:(id)sender
{
    [self.view.window close];
}

- (IBAction)buttonMethod:(id)sender
{
    if (sender == cancelBtn) {
        
        [self.view.window close];
        
    }else if (sender == sureBtn) {
        NSString *oldpwStr = [EVUtils removeTheStringBlankSpace:oldpdTF.stringValue];
        NSString *newpwStr = [EVUtils removeTheStringBlankSpace:newpdTF.stringValue];
        NSString *confirmStr = [EVUtils removeTheStringBlankSpace:surepdTF.stringValue];
        
        if (oldpwStr.length == 0) {
            hub.hidden = NO;
            hub.hudTitleFd.stringValue = localizationBundle(@"alert.pass.note.writeOld");
            [self persendMethod:2];
            return;
        }else if (newpwStr.length == 0) {
            hub.hidden = NO;
            hub.hudTitleFd.stringValue = localizationBundle(@"alert.pass.note.writeNew");
            [self persendMethod:2];
            return;
        }else if (![newpwStr isEqualToString:confirmStr]) {
            hub.hidden = NO;
            hub.hudTitleFd.stringValue = localizationBundle(@"alert.pass.note.notMatch");
            [self persendMethod:2];
            return;
        }
        
        int state =  [appDelegate.evengine changePassword:[appDelegate.evengine encryptPassword:oldpwStr] newpassword:[appDelegate.evengine encryptPassword:newpwStr]];
        if (state == EVOK) {
            DDLogInfo(@"[Info] 10006 ChangePasswordSucceed");
            hub.hidden = NO;
            hub.hudTitleFd.stringValue = localizationBundle(@"alert.changepasswords");
            [self performSelector:@selector(changesuccessful) withObject:self afterDelay:2];
            return;
        }else if (state == EVNG) {
            DDLogWarn(@"[Warn] 10007 ChangePasswordFailure errorinfo:%d", state);
            hub.hidden = NO;
            hub.hudTitleFd.stringValue = localizationBundle(@"alert.changepasswordf");
            [self persendMethod:2];
            return;
        }else {
            DDLogWarn(@"[Warn] 10007 ChangePasswordError errorinfo:%d", state);
            hub.hidden = NO;
            hub.hudTitleFd.stringValue = localizationBundle(@"alert.changepasswordf");
            [self persendMethod:2];
            return;
        }
        
    }
    
}

#pragma mark - Notification
- (void)closePdWindow
{
    [self.view.window close];
}

/**
 Toggle language
 
 @param sender Notification
 */
- (void)changeLanguage:(NSNotification *)sender
{
    [cancelBtn changeCenterButtonattribute:localizationBundle(@"alert.cancel") color:CONTENTCOLOR];
    [sureBtn changeCenterButtonattribute:localizationBundle(@"alert.sure") color:WHITECOLOR];
    topTitle.stringValue = localizationBundle(@"home.pd.title");
    oldpdTitle.stringValue = localizationBundle(@"home.pd.oldpd");
    alertTitle.stringValue = localizationBundle(@"home.pd.alert");
    newpdTitle.stringValue = localizationBundle(@"home.pd.newpd");
    surepdTitle.stringValue = localizationBundle(@"home.pd.surepd");
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

//if change password success. user must log back in.
- (void)changesuccessful
{
    hub.hidden = YES;
    [self.view.window close];
    
    RootWindowController *WinControl = [RootWindowController windowController];
    appDelegate.mainWindowController = WinControl;
    [WinControl.window makeKeyAndOrderFront:self];
    
    Notifications(CLOSEHOMEWINDOW);
    Notifications(CLOSEPDWINDOW);
    Notifications(CLOSEJOINWINDOW);
    Notifications(CLOSEHEADIMAGEWINDOW);
    
    appDelegate.islogin = NO;
    
    [appDelegate.evengine logout];
    
    HLog(@"[LogOut]");
    
    [self.view.window close];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CHANGELANGUAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CLOSEPDWINDOW object:nil];
}

@end
