//
//  LocalContetnViewController.m
//  easyVideo-avc
//
//  Created by quanhao huang on 2019/4/8.
//  Copyright © 2019 EVSDK. All rights reserved.
//

#import "LocalContetnViewController.h"

@interface LocalContetnViewController ()
{
    AppDelegate *appDelegate;
}
@end

@implementation LocalContetnViewController

@synthesize localView, saveBtn, stopBtn, stopTitle, saveTitle;

- (void)viewWillAppear
{
    [super viewWillAppear];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self setRootViewAttribute];
    
    [self languageLocalization];
}

- (void)setRootViewAttribute
{
    localView.wantsLayer = YES;
    localView.layer.borderWidth = 3;
    localView.layer.borderColor = BLUECOLOR.CGColor;
    
    appDelegate = APPDELEGATE;
    
    self.view.window.animationBehavior = NSWindowAnimationBehaviorNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeWindow) name:CLOSELOCALCONTENTWINDOW object:nil];
}

- (void)languageLocalization
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage:) name:CHANGELANGUAGE object:nil];
    
    //初始化应用语言
    [LanguageTool initUserLanguage];

    saveTitle.stringValue = localizationBundle(@"video.content.save");
    stopTitle.stringValue = localizationBundle(@"video.content.stop");
}

#pragma mark - NSButtonMethod
- (IBAction)buttonMethod:(id)sender
{
    if (sender == saveBtn) {
        Notifications(SAVEIMAGE);
    }else if (sender == stopBtn) {
        NSAlert *alert = [NSAlert new];
        [alert addButtonWithTitle:localizationBundle(@"alert.sure")];
        [alert addButtonWithTitle:localizationBundle(@"alert.cancel")];
        [alert setMessageText:localizationBundle(@"alert.prompt")];
        [alert setInformativeText:localizationBundle(@"alert.stopshare")];
        [alert setAlertStyle:NSAlertStyleCritical];
        [alert beginSheetModalForWindow:[self.view window] completionHandler:^(NSModalResponse returnCode) {
            if(returnCode == NSAlertFirstButtonReturn){
                Notifications(LOCALCONTENTWINDOWDIDCLOSE);
                [self.view.window close];
            }else if(returnCode == NSAlertSecondButtonReturn){
                
            }
        }];
    }
}

#pragma mark - Notification
- (void)closeWindow
{
    [self.view.window close];
}

- (void)changeLanguage:(NSNotification *)sender
{
    saveTitle.stringValue = localizationBundle(@"video.content.save");
    stopTitle.stringValue = localizationBundle(@"video.content.stop");
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CLOSELOCALCONTENTWINDOW object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CHANGELANGUAGE object:nil];
}

@end
