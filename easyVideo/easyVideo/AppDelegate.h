//
//  AppDelegate.h
//  easyVideo
//
//  Created by quanhao huang on 2018/8/9.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreData/CoreData.h>
#import "evsdk/EVEngineObj.h"
#import "JoinMeetingWindowController.h"
#import "UploadWindowController.h"
#import "CheckVersionWindowController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (strong) NSWindowController *mainWindowController;
@property (nonatomic, assign) BOOL islogin;
@property (nonatomic, assign) BOOL isInTheMeeting;
@property (nonatomic, assign) BOOL isautocheck;
@property (nonatomic, strong) NSURL *joinurl;
@property (nonatomic, strong) EVEngineObj *evengine;
/** Menu */
@property (weak) IBOutlet NSMenu *MeunName;
@property (weak) IBOutlet NSMenuItem *appName;
@property (weak) IBOutlet NSMenuItem *sendDiagnosticInfo;
@property (weak) IBOutlet NSMenuItem *aboutApp;
@property (weak) IBOutlet NSMenuItem *exitApp;
@property (weak) IBOutlet NSMenuItem *checkVersion;

/** Window */
@property (nonatomic, strong) JoinMeetingWindowController *joinMeetingWindow;
@property (nonatomic, strong) UploadWindowController *uploadWindow;
@property (nonatomic, strong) CheckVersionWindowController *checkVersionWindow;

@end

