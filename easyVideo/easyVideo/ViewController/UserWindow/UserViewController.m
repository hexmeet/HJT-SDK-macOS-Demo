//
//  UserViewController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/8/21.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "UserViewController.h"
#import "ChangePasswordWindowController.h"
#import "RootWindowController.h"
#import "HeadImageWindowController.h"
#import "macHUD.h"

//#import "UserPopoverController.h"

@interface UserViewController ()<NSTextFieldDelegate, EVEngineDelegate>
{
    BOOL isedit;
    AppDelegate *appDelegate;
    macHUD *hub;
}

@end

@implementation UserViewController

@synthesize topCustomViewBg, userHeadImage, userHeadBg, userHeadImageBtn, editUserNameBtn, userNameTitle, middleCustomViewBg, phoneTitle, landlineTitle, emailTitle, departmentTitle, companyTitle, phoneTF, landlineTF, emailTF, departmentTF, companyTF, bottomPBg, bottomLBg, changePasswordBtn, loginOutBtn, editConstraint;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self setRootViewAttribute];
    
    [self languageLocalization];
    
    [self getUserInfo];
    
}

#pragma mark - mouseEnter
- (void)mouseEntered:(NSEvent *)theEvent
{
    userHeadBg.hidden = NO;
    userHeadImageBtn.hidden = NO;
}

- (void)mouseExited:(NSEvent *)theEvent
{
    userHeadBg.hidden = YES;
    userHeadImageBtn.hidden = YES;
}

- (void)mouseDown:(NSEvent *)event
{
    NSString *displayNameStr = [EVUtils removeTheStringBlankSpace:userNameTitle.stringValue];
    
    if (displayNameStr.length != 0) {
        int state = [appDelegate.evengine changeDisplayName:displayNameStr];
        
        if (state == EVOK) {
            DDLogInfo(@"[Info] 10008 ChangeDisplayNameSucceed");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEDISPLAYNAME" object:displayNameStr];
            [userNameTitle resignFirstResponder];
            editUserNameBtn.hidden = NO;
            userNameTitle.editable = NO;
            
            isedit = NO;
            //更改本地数据
            NSDictionary *setInfo = [PlistUtils loadUserInfoPlistFilewithFileName:SETINFO];
            if ([setInfo[@"iscloudLogin"]isEqualToString:@"YES"]) {
                NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithDictionary:[PlistUtils loadUserInfoPlistFilewithFileName:CLOUDUSERINFO]];
                userinfo[@"displayName"] = userNameTitle.stringValue;
                [PlistUtils saveUserInfoPlistFile:(NSDictionary *)userinfo withFileName:CLOUDUSERINFO];
            }else {
                NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithDictionary:[PlistUtils loadUserInfoPlistFilewithFileName:PRIVATEUSERINFO]];
                userinfo[@"displayName"] = userNameTitle.stringValue;
                [PlistUtils saveUserInfoPlistFile:(NSDictionary *)userinfo withFileName:PRIVATEUSERINFO];
            }
            [self getUserInfo];
            Notifications(CHANGEDISPLAYNAME);
        }else if (state == EVNG) {
            DDLogWarn(@"[Warn] 10009 ChangeDisplayNameFailure errorInfo:%d", state);
            hub.hidden = NO;
            hub.hudTitleFd.stringValue = localizationBundle(@"alert.changepasswordf");
            [self getUserInfo];
            [self persendMethod:2];
        }else {
            DDLogWarn(@"[Warn] 10009 ChangeDisplayNameError errorInfo:%d", state);
            hub.hidden = NO;
            hub.hudTitleFd.stringValue = localizationBundle(@"alert.changepasswordf");
            [self getUserInfo];
            [self persendMethod:2];
        }
    }
}

- (void)keyDown:(NSEvent *)event
{
    NSString *chars = [event characters];
    if ([chars isEqualToString:@"\r"]) {
        if (isedit) {
            NSString *displayNameStr = [EVUtils removeTheStringBlankSpace:userNameTitle.stringValue];

            if (displayNameStr.length != 0) {
//                [appDelegate.evengine setDelegate:self];
                int state = [appDelegate.evengine changeDisplayName:displayNameStr];
                if (state == EVOK) {
                    DDLogInfo(@"[Info] 10008 ChangeDisplayNameSucceed");
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEDISPLAYNAME" object:displayNameStr];
                    [userNameTitle resignFirstResponder];
                    editUserNameBtn.hidden = NO;
                    userNameTitle.editable = NO;
                    
                    isedit = NO;
                    //更改本地数据
                    NSDictionary *setInfo = [PlistUtils loadUserInfoPlistFilewithFileName:SETINFO];
                    if ([setInfo[@"iscloudLogin"]isEqualToString:@"YES"]) {
                        NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithDictionary:[PlistUtils loadUserInfoPlistFilewithFileName:CLOUDUSERINFO]];
                        userinfo[@"displayName"] = userNameTitle.stringValue;
                        [PlistUtils saveUserInfoPlistFile:(NSDictionary *)userinfo withFileName:CLOUDUSERINFO];
                    }else {
                        NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithDictionary:[PlistUtils loadUserInfoPlistFilewithFileName:PRIVATEUSERINFO]];
                        userinfo[@"displayName"] = userNameTitle.stringValue;
                        [PlistUtils saveUserInfoPlistFile:(NSDictionary *)userinfo withFileName:PRIVATEUSERINFO];
                    }
                    [self getUserInfo];
                    Notifications(CHANGEDISPLAYNAME);
                }else if (state == EVNG) {
                    DDLogWarn(@"[Warn] 10009 ChangeDisplayNameFailure errorInfo:%d", state);
                    hub.hidden = NO;
                    hub.hudTitleFd.stringValue = localizationBundle(@"alert.changepasswordf");
                    [self getUserInfo];
                    [self persendMethod:2];
                }else {
                    DDLogWarn(@"[Warn] 10009 ChangeDisplayNameFailure errorInfo:%d", state);
                    hub.hidden = NO;
                    hub.hudTitleFd.stringValue = localizationBundle(@"alert.changepasswordf");
                    [self getUserInfo];
                    [self persendMethod:2];
                }
            }
        }
        
    }
}

- (void)setRootViewAttribute
{
    appDelegate = APPDELEGATE;
    
    NSString *downloadimagepath = [[EVUtils get_current_app_path]stringByAppendingPathComponent:@"header.jpg"];
    userHeadImage.image = [[NSImage alloc]initWithContentsOfFile:downloadimagepath];
    
    hub = [macHUD creatMacHUD:@"" icon:@"" viewController:self];
    hub.hidden = YES;
    
    [self.view setBackgroundColor:BLUECOLOR];
    [topCustomViewBg setBackgroundColor:DEFAULTBGCOLOR];
    [middleCustomViewBg setBackgroundColor:WHITECOLOR];
    [bottomLBg setBackgroundColor:WHITECOLOR];
    [bottomPBg setBackgroundColor:WHITECOLOR];
    
    phoneTF.focusRingType      = NSFocusRingTypeNone;
    landlineTF.focusRingType   = NSFocusRingTypeNone;
    emailTF.focusRingType      = NSFocusRingTypeNone;
    departmentTF.focusRingType = NSFocusRingTypeNone;
    companyTF.focusRingType    = NSFocusRingTypeNone;

    [userHeadBg setBackgroundColor:BLACKCOLOR];
    userHeadBg.layer.cornerRadius = 30.f;
    userHeadBg.alphaValue = 0.6;
    userHeadBg.hidden = YES;
    userHeadImage.wantsLayer = YES;
    userHeadImage.layer.cornerRadius = 30.f;
    userHeadImageBtn.hidden = YES;
    userHeadImageBtn.layer.cornerRadius = 30.f;
    
    NSTrackingArea *area = [[NSTrackingArea alloc] initWithRect:userHeadImage.bounds options:NSTrackingMouseEnteredAndExited|NSTrackingActiveInKeyWindow owner:self userInfo:nil];
    
    [userHeadImage addTrackingArea:area];
    
    userNameTitle.editable = NO;
    isedit = NO;
    
    [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskKeyDown handler:^NSEvent * _Nullable(NSEvent * _Nonnull aEvent) {
        [self keyDown:aEvent];
        return aEvent;
    }];
    [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskFlagsChanged handler:^NSEvent * _Nullable(NSEvent * _Nonnull aEvent) {
        [self flagsChanged:aEvent];
        return aEvent;
    }];
}

/**
 Language localization
 */
- (void)languageLocalization
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage:) name:CHANGELANGUAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeUserWindow) name:CLOSEUSERWINDOW object:nil];
    
    [LanguageTool initUserLanguage];
    
    phoneTitle.stringValue      = localizationBundle(@"home.user.phone");
    landlineTitle.stringValue   = localizationBundle(@"home.user.landline");
    emailTitle.stringValue      = localizationBundle(@"home.user.email");
    departmentTitle.stringValue = localizationBundle(@"home.user.department");
    companyTitle.stringValue    = localizationBundle(@"home.user.company");
    
    [changePasswordBtn changeCenterButtonattribute:localizationBundle(@"home.user.changepassword") color:BLUECOLOR];
    [loginOutBtn changeCenterButtonattribute:localizationBundle(@"home.user.loginout") color:DEFAULREDCOLOR];
}

- (void)getUserInfo
{
    NSDictionary *setInfo = [PlistUtils loadUserInfoPlistFilewithFileName:SETINFO];
    if ([setInfo[@"iscloudLogin"]isEqualToString:@"YES"]) {
        NSDictionary *userinfo = [PlistUtils loadUserInfoPlistFilewithFileName:CLOUDUSERINFO];
        userNameTitle.stringValue = userinfo[@"displayName"];
        phoneTF.stringValue = userinfo[@"cellphone"];
        landlineTF.stringValue = userinfo[@"telephone"];
        emailTF.stringValue = userinfo[@"email"];
        companyTF.stringValue = userinfo[@"org"];
    }else {
        NSDictionary *userinfo = [PlistUtils loadUserInfoPlistFilewithFileName:PRIVATEUSERINFO];
        userNameTitle.stringValue = userinfo[@"displayName"];
        phoneTF.stringValue = userinfo[@"cellphone"];
        landlineTF.stringValue = userinfo[@"telephone"];
        emailTF.stringValue = userinfo[@"email"];
        companyTF.stringValue = userinfo[@"org"];
    }
    
    for (int i = 0; i<userNameTitle.stringValue.length; i++) {
        NSString *str1 = [userNameTitle.stringValue substringToIndex:i];
        CGSize size = [str1 sizeWithAttributes:@{NSFontAttributeName: [NSFont systemFontOfSize:14.0f]}];
        if (size.width>168) {
            editConstraint.constant = 104+180;
            userNameTitle.stringValue = [str1 stringByAppendingPathComponent:@"..."];
            return;
        }else {
            editConstraint.constant = 200+size.width/2;
        }
    }
    
    if ([appDelegate.evengine getUserInfo].dept.length != 0 && [appDelegate.evengine getUserInfo].dept != nil) {
        departmentTF.stringValue = [appDelegate.evengine getUserInfo].dept;
    };
}

#pragma mark - NSTextFieldDelegate
- (void)controlTextDidChange:(NSNotification *)obj {
    if ([[userNameTitle stringValue] length] > 20) {
        [userNameTitle setStringValue:[[userNameTitle stringValue] substringToIndex:20]];
    }
}

#pragma mark - NSButtonMethod
- (IBAction)closeWindow:(id)sender
{
    [self.view.window close];
}

/**
 edit user name

 @param sender editUserNameBtn
 */
- (IBAction)editUserNameAction:(id)sender
{
    isedit = YES;
    editUserNameBtn.hidden = YES;
    userNameTitle.editable = YES;
    NSDictionary *setInfo = [PlistUtils loadUserInfoPlistFilewithFileName:SETINFO];
    if ([setInfo[@"iscloudLogin"]isEqualToString:@"YES"]) {
        NSDictionary *userinfo = [PlistUtils loadUserInfoPlistFilewithFileName:CLOUDUSERINFO];
        userNameTitle.stringValue = userinfo[@"displayName"];
        phoneTF.stringValue = userinfo[@"cellphone"];
        landlineTF.stringValue = userinfo[@"telephone"];
        emailTF.stringValue = userinfo[@"email"];
        companyTF.stringValue = userinfo[@"org"];
    }else {
        NSDictionary *userinfo = [PlistUtils loadUserInfoPlistFilewithFileName:PRIVATEUSERINFO];
        userNameTitle.stringValue = userinfo[@"displayName"];
        phoneTF.stringValue = userinfo[@"cellphone"];
        landlineTF.stringValue = userinfo[@"telephone"];
        emailTF.stringValue = userinfo[@"email"];
        companyTF.stringValue = userinfo[@"org"];
    }
    [userNameTitle becomeFirstResponder];
}

/**
 all Btn Method

 @param sender Btn
 */
- (IBAction)buttonMethod:(id)sender
{
    if (sender == changePasswordBtn) {
        
        Notifications(CLOSEPDWINDOW);
        
        ChangePasswordWindowController* windowControl = [ChangePasswordWindowController windowController];
        [windowControl.window makeKeyAndOrderFront:self];
        
//        [self.view.window close];
        
    }else if (sender == loginOutBtn) {
        
        NSAlert *alert = [NSAlert new];
        [alert addButtonWithTitle:localizationBundle(@"alert.sure")];
        [alert addButtonWithTitle:localizationBundle(@"alert.cancel")];
        [alert setMessageText:@""];
        [alert setInformativeText:localizationBundle(@"alert.note.loginout")];
        [alert setAlertStyle:NSAlertStyleInformational];
        [alert beginSheetModalForWindow:[self.view window] completionHandler:^(NSModalResponse returnCode) {
            if(returnCode == NSAlertFirstButtonReturn){
                self->appDelegate.islogin = NO;
                [self->appDelegate.evengine logout];
                
                Notifications(SHOWLOGINWINDOW);
                Notifications(CLOSEHOMEWINDOW);
                Notifications(CLOSEPDWINDOW);
                Notifications(CLOSEJOINWINDOW);
                Notifications(CLOSEHEADIMAGEWINDOW);
                Notifications(CLOSEMEETINGWEBWINDOW);
                Notifications(CLOSEPASSWORDWINDOW);
                Notifications(CLOSEINVITATIONWINDOW);
                
                DDLogInfo(@"[Info] 10018 Login out");
                
                [self.view.window close];
            }else if(returnCode == NSAlertSecondButtonReturn){
                
            }
        }];
        
    }else if (sender == userHeadImageBtn) {
        //change user head image
        Notifications(CLOSEHEADIMAGEWINDOW);

        HeadImageWindowController* windowControl = [HeadImageWindowController windowController];

        AppDelegate *appDelegate = APPDELEGATE;

        [windowControl.window makeKeyAndOrderFront:self];
    }
}

- (IBAction)editChangeAction:(id)sender
{
    
}

#pragma mark - Notification
/**
 Toggle language
 
 @param sender Notification
 */
- (void)changeLanguage:(NSNotification *)sender
{
    phoneTitle.stringValue      = localizationBundle(@"home.user.phone");
    landlineTitle.stringValue   = localizationBundle(@"home.user.landline");
    emailTitle.stringValue      = localizationBundle(@"home.user.email");
    departmentTitle.stringValue = localizationBundle(@"home.user.department");
    companyTitle.stringValue    = localizationBundle(@"home.user.company");
    
    [changePasswordBtn changeLeftButtonattribute:localizationBundle(@"home.user.changepassword") color:BLUECOLOR];
    [loginOutBtn changeLeftButtonattribute:localizationBundle(@"home.user.loginout") color:BLUECOLOR];
}

- (void)closeUserWindow
{
    [self.view.window close];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CHANGELANGUAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CLOSEUSERWINDOW object:nil];
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

@end
