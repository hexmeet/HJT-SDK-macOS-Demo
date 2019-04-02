//
//  PasswordViewController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/9/21.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "PasswordViewController.h"

@interface PasswordViewController ()

@end

@implementation PasswordViewController

@synthesize passwordTF, passwordTitle, joinBg, joinBtn;

- (void)viewDidDisappear
{
    [super viewDidDisappear];
    // remove notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CLOSEPASSWORDWINDOW object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self setRootViewAttribute];
    
    [self languageLocalization];
}

- (void)setRootViewAttribute
{
    [self.view setBackgroundColor:WHITECOLOR];
    
    [joinBg setBackgroundColor:BLUECOLOR];
    joinBg.layer.cornerRadius = 4.;
    
    passwordTF.focusRingType = NSFocusRingTypeNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeWinodow) name:CLOSEPASSWORDWINDOW object:nil];
}

- (void)languageLocalization
{
    [LanguageTool initUserLanguage];
    
    passwordTF.placeholderString = localizationBundle(@"alert.inputpassword");
    [joinBtn changeCenterButtonattribute:localizationBundle(@"login.window.join") color:WHITECOLOR];
    passwordTitle.stringValue = localizationBundle(@"home.join.password");
}

#pragma mark - ButtonMethod
- (IBAction)closeWindow:(id)sender
{
    [self.view.window close];
}

- (IBAction)joinAction:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MEETINGPASSWORD object:passwordTF.stringValue];
    [self.view.window close];
}

- (IBAction)passwordAction:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MEETINGPASSWORD object:passwordTF.stringValue];
    [self.view.window close];
}

#pragma Notifacation
- (void)closeWinodow
{
    [self.view.window close];
}

@end
