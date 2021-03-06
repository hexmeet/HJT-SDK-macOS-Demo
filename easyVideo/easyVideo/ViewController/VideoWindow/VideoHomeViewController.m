//
//  VideoHomeViewController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/8/30.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "VideoHomeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "HomeWindowController.h"
#import "ManagementWindowController.h"
#import "SignalWindowController.h"
#import "VideoController.h"
#import "EVVideoInfo.h"
#import "EVLayoutManager.h"
#import "ContentWindowController.h"
#import "MeetingWebWindowController.h"
#import "LocalContentWindowController.h"
#import "ScreenWindowController.h"
#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import <OpenGL/CGLMacro.h>
#import "LocalViewController.h"
#import "ChatPageViewController.h"

enum MessageType {
    MessgeTop,
    MessgeCenter,
    MessgeBottom,
};
#define WINDOWWIDTH  self.view.bounds.size.width
#define WINDOWHEIGHT self.view.bounds.size.height
@interface VideoHomeViewController ()<EVEngineDelegate, CAAnimationDelegate, NSTextFieldDelegate>
{
    BOOL ismute;
    BOOL isservermute;
    BOOL iscamera;
    BOOL islayout;
    BOOL isCanMove;
    BOOL isNeedAnimation;
    BOOL isFullScreen;
    BOOL isShowButtomBg;
    BOOL isMainVenue;
    BOOL ismyselfmute;
    BOOL isshowContent;
    BOOL isshowNotworkAlert;
    BOOL isshare;
    BOOL isshowLocal;
    BOOL isMuteforEnd;
    
    void * remoteArr[9];

    NSInteger fontInteger;
    uint32 contentid;
    
    AppDelegate *appDelegate;
    dispatch_source_t _timer;
    NSMutableArray *remoteList;
    CGPoint _sourcePoint;
    CGSize viewSize;
    
    NSInteger verticalBorder;
    NSInteger Messagecount;
    NSInteger timeInteger;
    
    NSArray *siteInfoArr;
    NSMutableArray *muteArr;
    
    VideoController *remotVideoController;
    
    ContentWindowController *contentWindow;
    
    MeetingWebWindowController *meetingWebWindow;
    
    LocalContentWindowController *localControl;
    
    EVLayoutMode layoutType;
    
    enum MessageType messageType;
    NSString *chooseVideoName;
}

@property (nonatomic, strong) NSView *messageView;
@property (nonatomic, strong) NSTextField *messageField;
@property (nonatomic, strong) NSTextField *staticField;

@end

@implementation VideoHomeViewController

@synthesize topViewBg, buttomViewBg, handUpViewBg, muteBtn, cameraBtn, setBtn, meetingBtn, videoLayoutBtn, handBtn, callendBtn, muteTitle, cameraTitle, setTitle, meetingTitle, videoTitle, signalImage, meetingNumber, timerLb, cancelVideo, cancelVideoConstraint, numberTitle, shareBtn, shareTitle, hud, hudTitle;

extern SVCLayoutDetail gSvcLayoutDetail[SVC_LAYOUT_MODE_NUMBER];

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self setRootViewAttribute];

    [self languageLocalization];
    
    [self setVideo];
    
    [self creatMessageView];
    
    [EVLayoutManager getInstance];
    
    NSTrackingAreaOptions options = NSTrackingInVisibleRect|NSTrackingMouseEnteredAndExited|NSTrackingActiveAlways;
    NSTrackingArea *area1 = [[NSTrackingArea alloc] initWithRect:self.meetingBtn.bounds options:options owner:self userInfo:nil];
    NSTrackingArea *area2 = [[NSTrackingArea alloc] initWithRect:self.setBtn.bounds options:options owner:self userInfo:nil];
    NSTrackingArea *area3 = [[NSTrackingArea alloc] initWithRect:self.videoLayoutBtn.bounds options:options owner:self userInfo:nil];
    NSTrackingArea *area4 = [[NSTrackingArea alloc] initWithRect:self.muteBtn.bounds options:options owner:self userInfo:nil];
    NSTrackingArea *area5 = [[NSTrackingArea alloc] initWithRect:self.cameraBtn.bounds options:options owner:self userInfo:nil];
    NSTrackingArea *area6 = [[NSTrackingArea alloc] initWithRect:self.handBtn.bounds options:options owner:self userInfo:nil];
    NSTrackingArea *area7 = [[NSTrackingArea alloc] initWithRect:self.showContentVideo.bounds options:options owner:self userInfo:nil];
    NSTrackingAreaOptions options2 = NSTrackingMouseEnteredAndExited|NSTrackingInVisibleRect|NSTrackingActiveAlways;
    NSTrackingArea *area8 = [[NSTrackingArea alloc] initWithRect:self.view.bounds options:options2 owner:self userInfo:nil];
    [self.meetingBtn addTrackingArea:area1];
    [self.setBtn addTrackingArea:area2];
    [self.videoLayoutBtn addTrackingArea:area3];
    [self.muteBtn addTrackingArea:area4];
    [self.cameraBtn addTrackingArea:area5];
    [self.handBtn addTrackingArea:area6];
    [self.showContentVideo addTrackingArea:area7];
    [self.view addTrackingArea:area8];
}

- (void)viewWillAppear
{
    [super viewWillAppear];
    
//    Notifications(SHOWLOCAL);
//    DDLogInfo(@"[Info] 10032 User Show Local Winodw");
//    localViewBg.hidden = YES;
}

- (void)viewDidLayout
{
    [super viewDidLayout];
    
    self.view.window.title = infoPlistStringBundle(@"CFBundleName");
    
    _sourcePoint = CGPointMake(0, 0);
    
    viewSize = self.view.bounds.size;

    for (int i = 0; i<remoteList.count; i++) {
        remotVideoController = remoteList[i];
        if (layoutType == EVLayoutSpeakerMode) {
            CGFloat x = gSvcLayoutDetail[SVC_LAYOUT_MODE_1X1].videoViewDescription[i][0] * WINDOWWIDTH;
            CGFloat y = gSvcLayoutDetail[SVC_LAYOUT_MODE_1X1].videoViewDescription[i][1] * (WINDOWHEIGHT-38);
            CGFloat width = gSvcLayoutDetail[SVC_LAYOUT_MODE_1X1].videoViewDescription[i][2] * WINDOWWIDTH;
            CGFloat height = gSvcLayoutDetail[SVC_LAYOUT_MODE_1X1].videoViewDescription[i][3] * (WINDOWHEIGHT-38);
            if (i<siteInfoArr.count) {
                [remotVideoController.view setFrame:CGRectMake(x, y, width, height)];
            }else {
                [remotVideoController.view setFrame:CGRectMake(x, y, 0, 0)];
            }
        }else if (layoutType == EVLayoutGalleryMode) {
            if (siteInfoArr.count == 1) {
                CGFloat x = gSvcLayoutDetail[SVC_LAYOUT_MODE_1X1].videoViewDescription[i][0] * WINDOWWIDTH;
                CGFloat y = gSvcLayoutDetail[SVC_LAYOUT_MODE_1X1].videoViewDescription[i][1] * (WINDOWHEIGHT-38);
                CGFloat width = gSvcLayoutDetail[SVC_LAYOUT_MODE_1X1].videoViewDescription[i][2] * WINDOWWIDTH;
                CGFloat height = gSvcLayoutDetail[SVC_LAYOUT_MODE_1X1].videoViewDescription[i][3] * (WINDOWHEIGHT-38);
                if (i<siteInfoArr.count) {
                    [remotVideoController.view setFrame:CGRectMake(x, y, width, height)];
                }else {
                    [remotVideoController.view setFrame:CGRectMake(x, y, 0, 0)];
                }
            }else if (siteInfoArr.count == 2) {
                double width = gSvcLayoutDetail[SVC_LAYOUT_MODE_1X2].videoViewDescription[i][2] * WINDOWWIDTH;
                double height = width*9.0/16.0;
                double redundant = (WINDOWHEIGHT-height)/2;
                double x = gSvcLayoutDetail[SVC_LAYOUT_MODE_1X2].videoViewDescription[i][0] * WINDOWWIDTH;
                double y = redundant;
                if (i<siteInfoArr.count) {
                    [remotVideoController.view setFrame:CGRectMake(x, y, width, height)];
                }else {
                    [remotVideoController.view setFrame:CGRectMake(x, y, 0, 0)];
                }
            }else if (siteInfoArr.count >2 && siteInfoArr.count < 5) {
                double height = gSvcLayoutDetail[SVC_LAYOUT_MODE_2X2].videoViewDescription[i][3] * (WINDOWHEIGHT-38);
                double width = height*16.0/9.0;
                if (width*2>WINDOWWIDTH) {
                    width = WINDOWWIDTH/2;
                    height = width*9.0/16.0;
                    double redundant = (WINDOWHEIGHT-height*2-38)/2;
                    double y = redundant;
                    if (i == 0 || i == 1) {
                        y = redundant+height;
                    }else {
                        y = redundant;
                    }
                    CGFloat x;
                    if (i == 0 || i == 2) {
                        x = 0;
                    }else {
                        x = width;
                    }
                    if (i<siteInfoArr.count) {
                        [remotVideoController.view setFrame:CGRectMake(x, y, width, height)];
                    }else {
                        [remotVideoController.view setFrame:CGRectMake(x, y, 0, 0)];
                    }
                }else {
                    double redundant = (WINDOWWIDTH-width*2)/2;
                    CGFloat x = 0;
                    if (i == 0 || i == 2) {
                        x = redundant;
                    }else {
                        x = redundant+width;
                    }
                    double y = gSvcLayoutDetail[SVC_LAYOUT_MODE_2X2].videoViewDescription[i][1] * (WINDOWHEIGHT-38);
                    if (i<siteInfoArr.count) {
                        [remotVideoController.view setFrame:CGRectMake(x, y, width, height)];
                    }else {
                        [remotVideoController.view setFrame:CGRectMake(x, y, 0, 0)];
                    }
                }

            }else if (siteInfoArr.count >4 && siteInfoArr.count < 7) {
                double width = WINDOWWIDTH/3;
                double height = width/16.0*9.0;
                double redundant = (WINDOWHEIGHT-height*2)/2;
                double y = redundant;
                if (i == 0 || i == 1 || i == 2) {
                    y = redundant+height;
                }else if (i == 3 || i == 4 || i ==5) {
                    y = redundant;
                }else {
                    width = 0;
                    height = 0;
                }
                CGFloat x = gSvcLayoutDetail[SVC_LAYOUT_MODE_2X3].videoViewDescription[i][0] * WINDOWWIDTH;
                if (i<siteInfoArr.count) {
                    [remotVideoController.view setFrame:CGRectMake(x, y, width, height)];
                }else {
                    [remotVideoController.view setFrame:CGRectMake(x, y, 0, 0)];
                }
            }else if (siteInfoArr.count > 6) {
                double width = WINDOWWIDTH/3;
                double height = width/16.0*9.0;
                
                if (height*3 < WINDOWHEIGHT-38) {
                    double redundant = (WINDOWHEIGHT-38-height*3)/2;
                    double y = redundant;
                    if (i == 0 || i == 1 || i == 2) {
                        y = redundant+height*2;
                    }else if (i == 3 || i == 4 || i ==5) {
                        y = redundant+height;
                    }else if (i == 6 || i == 7 || i ==8) {
                        y = redundant;
                    }else {
                        width = 0;
                        height = 0;
                    }
                    CGFloat x = gSvcLayoutDetail[SVC_LAYOUT_MODE_3X3].videoViewDescription[i][0] * WINDOWWIDTH;
                    if (i<siteInfoArr.count) {
                        [remotVideoController.view setFrame:CGRectMake(x, y, width, height)];
                    }else {
                        [remotVideoController.view setFrame:CGRectMake(x, y, 0, 0)];
                    }
                }else {
                    double height = (WINDOWHEIGHT-38)/3;
                    double width  = height/9*16;
                    double redundant = (WINDOWWIDTH - width*3)/2;
                    double x = redundant;
                    double y = 0.0;
                    if (i == 0 || i == 3 || i == 6) {
                        x = redundant;
                        y = 0;
                    }else if (i == 1 || i == 4 || i == 7) {
                        x = redundant+width;
                        y = height;
                    }else if (i == 2 || i == 5 || i == 8) {
                        x = redundant+width*2;
                        y = height*2;
                    }else {
                        width = 0;
                        height = 0;
                    }
                    
                    if (i == 0 || i == 1 || i == 2) {
                        y = height*2;
                    }else if (i == 3 || i == 4 || i ==5) {
                        y = height;
                    }else if (i == 6 || i == 7 || i ==8) {
                        y = 0;
                    }else {
                        width = 0;
                        height = 0;
                    }
                    
                    if (i<siteInfoArr.count) {
                        [remotVideoController.view setFrame:CGRectMake(x, y, width, height)];
                    }else {
                        [remotVideoController.view setFrame:CGRectMake(x, y, 0, 0)];
                    }
                }
            }
        }
    }
    
    /** Message */
    _messageView.frame = CGRectMake(0, (WINDOWHEIGHT-76)*self->verticalBorder/100, WINDOWWIDTH, 40);
    CGRect rect = [self getLabelHeightWithText:_staticField.stringValue width:WINDOWWIDTH*2 font:fontInteger];
    _staticField.frame = CGRectMake(0, (40-rect.size.height)/2, WINDOWWIDTH, rect.size.height);
    _messageField.frame = CGRectMake(0, 0, WINDOWWIDTH, 40);
}

- (void)viewWillDisappear
{
    [super viewWillDisappear];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CHANGELANGUAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:STARTIME object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CLOSEVIDEOHOMEWINDOW object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CHOOSEVIDEO object:nil];
}

- (void)setRootViewAttribute
{
    _inputNameField.focusRingType = NSFocusRingTypeNone;
    _inputNameField.delegate = self;
    
    [_nameCancelBtn changeCenterButtonattribute:localizationBundle(@"alert.cancel") color:CONTENTCOLOR];
    [_nameSureBtn changeCenterButtonattribute:localizationBundle(@"alert.sure") color:WHITECOLOR];
    
    [self.recordBg setBackgroundColorR:0 G:0 B:0 withAlpha:0.4];
    self.recordBg.layer.cornerRadius = 3.;
    [self.redBg setBackgroundColor:HEXCOLOR(0xff2a3c)];
    self.redBg.layer.cornerRadius = 5.;
    
    [self.speakerViewBg setBackgroundColorR:0 G:0 B:0 withAlpha:0.4];
    self.speakerViewBg.layer.cornerRadius = 3.;
    
    [topViewBg setBackgroundColorR:0 G:0 B:0 withAlpha:0.95];
    [buttomViewBg setBackgroundColorR:0 G:0 B:0 withAlpha:0.95];
    [self.zheView setBackgroundColorR:0 G:0 B:0 withAlpha:0.95];
    
    [self.menuViewBg setBackgroundColorR:0 G:0 B:0 withAlpha:0.95];
    
    [self.view setBackgroundColor:BLACKCOLOR];
    
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(hiddenTool) withObject:nil afterDelay:15];
    
    appDelegate = APPDELEGATE;
    
    hud.wantsLayer = YES;
    hud.layer.backgroundColor = [NSColor blackColor].CGColor;
    hud.layer.cornerRadius = 10;
    hud.alphaValue = 0.6f;
    
    muteBtn.canSelected = YES;
    muteBtn.buttonState = SWSTAnswerButtonNormalState;
    cameraBtn.canSelected = YES;
    cameraBtn.buttonState = SWSTAnswerButtonNormalState;
    videoLayoutBtn.canSelected = YES;
    videoLayoutBtn.buttonState = SWSTAnswerButtonNormalState;
    
    self.recordBg.hidden = YES;
    cancelVideo.hidden = YES;
    cancelVideoConstraint.constant = 20;
    _speakerConstraint.constant = 20;
    _speakerViewBg.hidden = YES;
    
    ismute = NO;
    iscamera = NO;
    islayout = NO;
    isCanMove = NO;
    isNeedAnimation = NO;
    isShowButtomBg = YES;
    isMainVenue = YES;
    isshowNotworkAlert = YES;
    isshare = NO;
    isshowLocal = YES;
    isMuteforEnd = NO;
    
    muteArr = [NSMutableArray arrayWithCapacity:1];
    
    remoteList = [NSMutableArray arrayWithCapacity:1];
    
    contentWindow = [ContentWindowController windowController];
    
    meetingWebWindow = [MeetingWebWindowController windowController];
    
    localControl = [LocalContentWindowController windowController];
    
    if ([EVUtils queryUserPlist:@"switchingToAudioConference"]) {
        _menuuViewConstraint.constant = 150;
    }else {
        _menuuViewConstraint.constant = 50;
    }
}

- (void)setVideo
{
    for (int i = 0; i<9; i++) {
        remotVideoController = [[VideoController alloc] initWithViewAndType:REMOTE viewFrame:CGRectMake(100*i, 100, 0, 0)];
        [self.view addSubview:remotVideoController.view];
        remoteArr[i] = (__bridge void *)(remotVideoController.videoView);
        [remoteList addObject:remotVideoController];
        [self.view addSubview:buttomViewBg positioned:NSWindowAbove relativeTo:remotVideoController.view];
        [self.view addSubview:self.menuViewBg positioned:NSWindowAbove relativeTo:remotVideoController.view];
        [self.view addSubview:self.recordBg positioned:NSWindowAbove relativeTo:remotVideoController.view];
        [self.view addSubview:self.speakerViewBg positioned:NSWindowAbove relativeTo:remotVideoController.view];
        [self.view addSubview:hud positioned:NSWindowAbove relativeTo:remotVideoController.view];
        [self.view addSubview:cancelVideo positioned:NSWindowAbove relativeTo:remotVideoController.view];
        [self.view addSubview:_audioViewBg positioned:NSWindowAbove relativeTo:remotVideoController.view];
        [self.view addSubview:_changeNameViewBg positioned:NSWindowAbove relativeTo:remotVideoController.view];
    }
    DDLogInfo(@"[Info] 10031 Set Remot Video Window");
    [appDelegate.evengine setRemoteVideoWindow:remoteArr andSize:9];
    
}

- (void)creatMessageView
{
    _messageView = [[NSView alloc] initWithFrame:CGRectMake(0, 300, WINDOWWIDTH, 40)];
    [_messageView setBackgroundColor:BLUECOLOR];
    _messageView.hidden = YES;
    [self.view addSubview:_messageView positioned:NSWindowBelow relativeTo:buttomViewBg];
    
    _messageField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, WINDOWWIDTH, 40)];
    _messageField.font = [NSFont systemFontOfSize:15];

    _messageField.textColor = WHITECOLOR;
    [_messageField setBackgroundColor:CLEARCOLOR];
    _messageField.editable = NO;
    _messageField.selectable = NO;
    _messageField.bordered = NO;
    _messageField.hidden = YES;
    [_messageView addSubview:_messageField];
    
    _staticField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, WINDOWWIDTH, 40)];
    _staticField.font = [NSFont systemFontOfSize:15];
    
    _staticField.textColor = WHITECOLOR;
    [_staticField setBackgroundColor:CLEARCOLOR];
    _staticField.editable = NO;
    _staticField.selectable = NO;
    _staticField.bordered = NO;
    _staticField.hidden = YES;
    _staticField.alignment = NSTextAlignmentCenter;
    [_messageView addSubview:_staticField];
}

- (void)setLayoutMode:(NSArray *)siteArr
{
    siteInfoArr = siteArr;
    
    //替换位置
    for (int i = 0; i<siteArr.count; i++) {
        EVSite *site = siteArr[i];
        for (int j = 0; j<remoteList.count; j++) {
            remotVideoController = remoteList[j];
            if (site.window == (__bridge void *)(remotVideoController.videoView)) {
                [remoteList exchangeObjectAtIndex:j withObjectAtIndex:i];
            }
        }
    }
    
    for (int i = 0; i<remoteList.count; i++) {
        remotVideoController = remoteList[i];
        remotVideoController.userName.stringValue = @"";
        remotVideoController.userBg.hidden = YES;
        for (NSString *name in self->muteArr) {
            if ([self->remotVideoController.userName.stringValue isEqualToString:name]) {
                self->remotVideoController.muteBg.hidden = NO;
                self->remotVideoController.nameConstraint.constant = 20;
            }
        }
        if (layoutType == EVLayoutSpeakerMode) {
            NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
            [data setValue:remoteList[0] forKey:@"remote"];
            [data setValue:siteArr forKey:@"remoteArr"];
            [[NSNotificationCenter defaultCenter] postNotificationName:REFACTORINGLOCAL object:data];
            CGFloat x = gSvcLayoutDetail[SVC_LAYOUT_MODE_1X1].videoViewDescription[i][0] * WINDOWWIDTH;
            CGFloat y = gSvcLayoutDetail[SVC_LAYOUT_MODE_1X1].videoViewDescription[i][1] * (WINDOWHEIGHT-38);
            CGFloat width = gSvcLayoutDetail[SVC_LAYOUT_MODE_1X1].videoViewDescription[i][2] * WINDOWWIDTH;
            CGFloat height = gSvcLayoutDetail[SVC_LAYOUT_MODE_1X1].videoViewDescription[i][3] * (WINDOWHEIGHT-38);
            if (i<siteInfoArr.count) {
                [remotVideoController.view setFrame:CGRectMake(x, y, width, height)];
            }else {
                [remotVideoController.view setFrame:CGRectMake(x, y, 0, 0)];
            }
            
        }else if (layoutType == EVLayoutSpecifiedMode) {
            NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
            [data setValue:remoteList[0] forKey:@"remote"];
            [data setValue:siteArr forKey:@"remoteArr"];
            [[NSNotificationCenter defaultCenter] postNotificationName:REFACTORINGLOCAL object:data];
        }else if (layoutType == EVLayoutGalleryMode) {
            NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
            [data setValue:remoteList[0] forKey:@"remote"];
            [data setValue:siteArr forKey:@"remoteArr"];
            [[NSNotificationCenter defaultCenter] postNotificationName:REDUCTION object:data];
            [appDelegate.evengine setRemoteVideoWindow:remoteArr andSize:9];
            if (siteArr.count == 1) {
                CGFloat x = gSvcLayoutDetail[SVC_LAYOUT_MODE_1X1].videoViewDescription[i][0] * WINDOWWIDTH;
                CGFloat y = gSvcLayoutDetail[SVC_LAYOUT_MODE_1X1].videoViewDescription[i][1] * (WINDOWHEIGHT-38);
                CGFloat width = gSvcLayoutDetail[SVC_LAYOUT_MODE_1X1].videoViewDescription[i][2] * WINDOWWIDTH;
                CGFloat height = gSvcLayoutDetail[SVC_LAYOUT_MODE_1X1].videoViewDescription[i][3] * (WINDOWHEIGHT-38);
                if (i<siteInfoArr.count) {
                    [remotVideoController.view setFrame:CGRectMake(x, y, width, height)];
                }else {
                    [remotVideoController.view setFrame:CGRectMake(x, y, 0, 0)];
                }
            }else if (siteArr.count == 2) {
                double width = gSvcLayoutDetail[SVC_LAYOUT_MODE_1X2].videoViewDescription[i][2] * WINDOWWIDTH;
                double height = width*9.0/16.0;
                double redundant = (WINDOWHEIGHT-height)/2;
                double x = gSvcLayoutDetail[SVC_LAYOUT_MODE_1X2].videoViewDescription[i][0] * WINDOWWIDTH;
                double y = redundant;
                if (i<siteInfoArr.count) {
                    [remotVideoController.view setFrame:CGRectMake(x, y, width, height)];
                }else {
                    [remotVideoController.view setFrame:CGRectMake(x, y, 0, 0)];
                }
            }else if (siteArr.count >2 && siteArr.count < 5) {
                double height = gSvcLayoutDetail[SVC_LAYOUT_MODE_2X2].videoViewDescription[i][3] * (WINDOWHEIGHT-38);
                double width = height*16.0/9.0;
                if (width*2>WINDOWWIDTH) {
                    width = WINDOWWIDTH/2;
                    height = width*9.0/16.0;
                    double redundant = (WINDOWHEIGHT-height*2-38)/2;
                    double y = redundant;
                    if (i == 0 || i == 1) {
                        y = redundant+height;
                    }else {
                        y = redundant;
                    }
                    CGFloat x;
                    if (i == 0 || i == 2) {
                        x = 0;
                    }else {
                        x = width;
                    }
                    if (i<siteInfoArr.count) {
                        [remotVideoController.view setFrame:CGRectMake(x, y, width, height)];
                    }else {
                        [remotVideoController.view setFrame:CGRectMake(x, y, 0, 0)];
                    }
                }else {
                    double redundant = (WINDOWWIDTH-width*2)/2;
                    CGFloat x = 0;
                    if (i == 0 || i == 2) {
                        x = redundant;
                    }else {
                        x = redundant+width;
                    }
                    double y = gSvcLayoutDetail[SVC_LAYOUT_MODE_2X2].videoViewDescription[i][1] * (WINDOWHEIGHT-38);
                    if (i<siteInfoArr.count) {
                        [remotVideoController.view setFrame:CGRectMake(x, y, width, height)];
                    }else {
                        [remotVideoController.view setFrame:CGRectMake(x, y, 0, 0)];
                    }
                }
            }else if (siteArr.count >4 && siteArr.count < 7) {
                double width = WINDOWWIDTH/3;
                double height = width/16.0*9.0;
                double redundant = (WINDOWHEIGHT-height*2)/2;
                double y = redundant;
                if (i == 0 || i == 1 || i == 2) {
                    y = redundant+height;
                }else if (i == 3 || i == 4 || i ==5) {
                    y = redundant;
                }else {
                    width = 0;
                    height = 0;
                }
                CGFloat x = gSvcLayoutDetail[SVC_LAYOUT_MODE_2X3].videoViewDescription[i][0] * WINDOWWIDTH;
                if (i<siteInfoArr.count) {
                    [remotVideoController.view setFrame:CGRectMake(x, y, width, height)];
                }else {
                    [remotVideoController.view setFrame:CGRectMake(x, y, 0, 0)];
                }
            }else if (siteArr.count > 6) {
                double width = WINDOWWIDTH/3;
                double height = width/16.0*9.0;
                
                if (height*3 < WINDOWHEIGHT-38) {
                    double redundant = (WINDOWHEIGHT-38-height*3)/2;
                    double y = redundant;
                    if (i == 0 || i == 1 || i == 2) {
                        y = redundant+height*2;
                    }else if (i == 3 || i == 4 || i ==5) {
                        y = redundant+height;
                    }else if (i == 6 || i == 7 || i ==8) {
                        y = redundant;
                    }else {
                        width = 0;
                        height = 0;
                    }
                    CGFloat x = gSvcLayoutDetail[SVC_LAYOUT_MODE_3X3].videoViewDescription[i][0] * WINDOWWIDTH;
                    if (i<siteInfoArr.count) {
                        [remotVideoController.view setFrame:CGRectMake(x, y, width, height)];
                    }else {
                        [remotVideoController.view setFrame:CGRectMake(x, y, 0, 0)];
                    }
                }else {
                    double height = (WINDOWHEIGHT-38)/3;
                    double width  = height/9*16;
                    double redundant = (WINDOWWIDTH - width*3)/2;
                    double x = redundant;
                    double y = 0.0;
                    if (i == 0 || i == 3 || i == 6) {
                        x = redundant;
                        y = 0;
                    }else if (i == 1 || i == 4 || i == 7) {
                        x = redundant+width;
                        y = height;
                    }else if (i == 2 || i == 5 || i == 8) {
                        x = redundant+width*2;
                        y = height*2;
                    }else {
                        width = 0;
                        height = 0;
                    }
                    
                    if (i == 0 || i == 1 || i == 2) {
                        y = height*2;
                    }else if (i == 3 || i == 4 || i ==5) {
                        y = height;
                    }else if (i == 6 || i == 7 || i ==8) {
                        y = 0;
                    }else {
                        width = 0;
                        height = 0;
                    }
                    
                    if (i<siteInfoArr.count) {
                        [remotVideoController.view setFrame:CGRectMake(x, y, width, height)];
                    }else {
                        [remotVideoController.view setFrame:CGRectMake(x, y, 0, 0)];
                    }
                }
            }
        }
    }
    
    for (int i = 0; i<siteArr.count; i++) {
        EVSite *site = siteArr[i];
        if (site.name.length != 0) {
            remotVideoController = remoteList[i];
            remotVideoController.userName.hidden = NO;
            remotVideoController.userBg.hidden = NO;
            remotVideoController.userName.stringValue = site.name;
        }
    }
    
    for (NSString *name in self->muteArr) {
        if ([self->remotVideoController.userName.stringValue isEqualToString:name]) {
            self->remotVideoController.muteBg.hidden = NO;
            self->remotVideoController.nameConstraint.constant = 20;
        }
    }
    
}

- (void)languageLocalization
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage:) name:CHANGELANGUAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTimer) name:STARTIME object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenLocal) name:HIDDENLOCAL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeWindow) name:CLOSEVIDEOHOMEWINDOW object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseVideo:) name:CHOOSEVIDEO object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveIamge) name:SAVEIMAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localContentClose) name:LOCALCONTENTWINDOWDIDCLOSE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendContent:) name:SENDCONTENT object:nil];
    
    cancelVideo.layer.cornerRadius = 4.;
    
    //初始化应用语言
    [LanguageTool initUserLanguage];
    
    [cancelVideo changeCenterButtonattribute:localizationBundle(@"video.unselectvideo") color:WHITECOLOR];
    [_closeLocalBtn changeCenterButtonattribute:localizationBundle(@"video.closelocalvideo") color:WHITECOLOR];
//    [_moreBtn changeCenterButtonattribute:localizationBundle(@"video.more") color:WHITECOLOR];
    [handBtn changeCenterButtonattribute:localizationBundle(@"video.handup") color:WHITECOLOR];
    [_switchAudioBtn changeCenterButtonattribute:localizationBundle(@"video.changeMode") color:WHITECOLOR];
    [_changeNameBtn changeCenterButtonattribute:localizationBundle(@"video.changeName") color:WHITECOLOR];
    [callendBtn changeCenterButtonattribute:localizationBundle(@"video.callend") color:COLORFF4747];
    [_exitAudioBtn changeCenterButtonattribute:@"" color:WHITECOLOR];
    [cancelVideo setBackgroundColor:BLACKCOLOR withAlpha:0.4];
    
    muteTitle.stringValue = localizationBundle(@"video.mute");
    cameraTitle.stringValue = localizationBundle(@"video.stopvideo");
    setTitle.stringValue = localizationBundle(@"video.set");
    meetingTitle.stringValue = localizationBundle(@"video.meetingmanagement");
    _chatTitle.stringValue = localizationBundle(@"video.chat");
    videoTitle.stringValue = localizationBundle(@"video.layoutswitch");
    _showLocalTitle.stringValue = localizationBundle(@"video.openlocalvideo");
    _showContentTitle.stringValue = localizationBundle(@"video.showcontent");
    shareTitle.stringValue = localizationBundle(@"video.share");
    _speakerTitle.stringValue = localizationBundle(@"video.isspeaking");
    _moreTitle.stringValue = localizationBundle(@"video.more");
    _exitAudioTitle.stringValue = localizationBundle(@"video.exitAudioTitle");
    _changeNameTitle.stringValue = localizationBundle(@"video.rename");
    _inputNameTitle.stringValue = localizationBundle(@"video.inputNewName");
}

- (void)getUserSet
{
    NSDictionary *setDic = [PlistUtils loadUserInfoPlistFilewithFileName:SETINFO];
    if (setDic[@"camera"]) {
        if ([setDic[@"camera"] isEqualToString:@"YES"]) {
            iscamera = !iscamera;
            [cameraBtn setButtonState:SWSTAnswerButtonSelectedState];
            cameraTitle.stringValue = localizationBundle(@"video.openvideo");
            cameraTitle.textColor = DEFAULREDCOLOR;
            [appDelegate.evengine enableCamera:NO];
        }else {
            [appDelegate.evengine enableCamera:YES];
        }
    }else {
        [appDelegate.evengine enableCamera:YES];
    }
    if (setDic[@"mute"]) {
        if ([setDic[@"mute"] isEqualToString:@"YES"]) {
            ismute = !ismute;
            [muteBtn setButtonState:SWSTAnswerButtonSelectedState];
            muteTitle.stringValue = localizationBundle(@"video.unmute");
            muteTitle.textColor = DEFAULREDCOLOR;
            [appDelegate.evengine enableMic:NO];
        }else {
            [appDelegate.evengine enableMic:YES];
        }
    }else {
        [appDelegate.evengine enableMic:YES];
    }
}

#pragma mark - MOUSE
- (void)mouseEntered:(NSEvent *)theEvent
{
    if (theEvent.window == self.view.window) {
        buttomViewBg.hidden = NO;
        [[self class] cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(hiddenTool) withObject:self afterDelay:15];
    }else {
        isCanMove = YES;
    }
}

- (void)mouseExited:(NSEvent *)theEvent
{
    isCanMove = NO;
}

- (void)mouseUp:(NSEvent *)theEvent
{
    _sourcePoint = CGPointMake(0, 0);
}

- (void)mouseDragged:(NSEvent *)event
{
    
}

- (void)mouseDown:(NSEvent *)event
{
    if (isCanMove) {
        return;
    }
    isShowButtomBg = !isShowButtomBg;
    if (isShowButtomBg) {
        buttomViewBg.hidden = NO;
        [[self class] cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(hiddenTool) withObject:self afterDelay:15];
        if (layoutType == EVLayoutSpeakerMode) {
            remotVideoController = remoteList[0];
            remotVideoController.nameConstraintH.constant = 85;
        }else {
            remotVideoController = remoteList[0];
            remotVideoController.nameConstraintH.constant = 10;
        }
    }else {
        [[self class] cancelPreviousPerformRequestsWithTarget:self];
        buttomViewBg.hidden = YES;
        _menuViewBg.hidden = YES;
        if (layoutType == EVLayoutSpeakerMode) {
            remotVideoController = remoteList[0];
            remotVideoController.nameConstraintH.constant = 10;
        }else {
            remotVideoController = remoteList[0];
            remotVideoController.nameConstraintH.constant = 10;
        }
    }
}

int seconds = 0l;
#pragma mark - NSButtonMethod
- (IBAction)changeNameAction:(id)sender {
    _changeNameViewBg.hidden = YES;
    if (sender == _nameCancelBtn) {
    }else if (sender == _nameSureBtn) {
        if (_inputNameField.stringValue.length != 0) {
            [self->appDelegate.evengine setInConfDisplayName:_inputNameField.stringValue];
            [[NSNotificationCenter defaultCenter] postNotificationName:CHANGEDISPLAYNAME object:_inputNameField.stringValue];
        }
    }
}

- (IBAction)buttonMethod:(id)sender
{
    if (sender == muteBtn) {
        ismute = !ismute;
        [appDelegate.evengine enableMic:!ismute];
        if (![appDelegate.evengine micEnabled]) {
            DDLogInfo(@"[Info] micEnabled:YES.");
            muteTitle.stringValue = localizationBundle(@"video.unmute");
            muteTitle.textColor = DEFAULREDCOLOR;
            [muteBtn setButtonState:SWSTAnswerButtonSelectedState];
            DDLogInfo(@"[Info] 10019 user mute");
        }else {
            DDLogInfo(@"[Info] micEnabled:NO.");
            muteTitle.stringValue = localizationBundle(@"video.mute");
            muteTitle.textColor = WHITECOLOR;
            [muteBtn setButtonState:SWSTAnswerButtonNormalState];
            DDLogInfo(@"[Info] 10020 user unmute");
        }
        
    }else if (sender == cameraBtn) {
        iscamera = !iscamera;
        if (iscamera) {
            cameraTitle.stringValue = localizationBundle(@"video.openvideo");
            cameraTitle.textColor = DEFAULREDCOLOR;
            [appDelegate.evengine enableCamera:NO];
            DDLogInfo(@"[Info] 10021 user turn off camera");
        }else {
            cameraTitle.stringValue = localizationBundle(@"video.stopvideo");
            cameraTitle.textColor = WHITECOLOR;
            [appDelegate.evengine enableCamera:YES];
            DDLogInfo(@"[Info] 10022 user turn off camera");
        }
    }else if (sender == shareBtn) {
        
        if ([EVUtils canRecord]) {
            if (!isshare) {
                Notifications(CLOSESCREENWINDOW);
                ScreenWindowController *WinControl = [ScreenWindowController windowController];
                [WinControl.window makeKeyAndOrderFront:self];
            }
        }else {
            self->hud.hidden = NO;
            self->hudTitle.stringValue = localizationBundle(@"alert.noScreenrecording");
            [self getAlertViewWidth:hudTitle.stringValue];
            [self persendMethod:2];
            NSString *urlString = @"x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture";
            [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:urlString]];
        }
    }else if (sender == setBtn) {
        
        Notifications(CLOSEMANMAGEWINDOW);
        ManagementWindowController *WinControl = [ManagementWindowController windowController];
        
        [WinControl.window makeKeyAndOrderFront:self];
        
    }else if (sender == meetingBtn) {
        
        Notifications(UPLOADMEETINGWEBWINDOW);
        [meetingWebWindow.window orderFront:self];
        
    }else if (sender == self.chatBtn) {
        if (_chatPageWindow == nil) {
            _chatPageWindow = [ChatPageWindowC windowController];
        }
        ChatPageViewController *chat = (ChatPageViewController *)_chatPageWindow.contentViewController;
        chat.groupStr = [appDelegate.evengine getIMGroupID];
        [_chatPageWindow.window makeKeyAndOrderFront:nil];
    }else if (sender == videoLayoutBtn) {
        if (!isMainVenue) {
            self->hud.hidden = NO;
            self->hudTitle.stringValue = localizationBundle(@"alert.openmainvenuemodel");
            [self getAlertViewWidth:hudTitle.stringValue];
            [self persendMethod:2];
            return;
        }
        islayout = !islayout;
        EVLayoutRequest *layout = [[EVLayoutRequest alloc] init];
        layout.page = EVLayoutCurrentPage;
        if (islayout) {
            videoTitle.stringValue = localizationBundle(@"video.layoutswitch");
            layout.mode = EVLayoutSpeakerMode;
            layout.max_type = EVLayoutType_5_4T_1B;
            EVVideoSize vsize;
            vsize.width = 0;
            vsize.height = 0;
            layout.max_resolution = vsize;
            DDLogInfo(@"[Info] 10023 user choose Speaker Mode");
        }else {
            DDLogInfo(@"[Info] 10024 user choose Gallery Mode");
            videoTitle.stringValue = localizationBundle(@"video.layoutswitch");
            layout.mode = EVLayoutGalleryMode;
            layout.max_type = EVLayoutType_9;
            EVVideoSize vsize;
            vsize.width = 0;
            vsize.height = 0;
            layout.max_resolution = vsize;
            // In case of going to gallery mode layout, chosen video is turned off automatically,
            // so hide the cancelVideo button
            cancelVideo.hidden = YES;
        }
        [appDelegate.evengine setLayout:layout];
    }else if (sender == handBtn) {
        [handBtn setButtonState:SWSTAnswerButtonNormalState];
        [appDelegate.evengine requestRemoteUnmute:YES];
        hud.hidden = NO;
        self->hudTitle.stringValue = localizationBundle(@"alert.handsup.approve");
        [self getAlertViewWidth:hudTitle.stringValue];
        [self persendMethod:2];
        DDLogInfo(@"[Info] 10025 user Speech Request");
    }else if (sender == _alertBtn) {
        self->hud.hidden = NO;
        self->hudTitle.stringValue = localizationBundle(@"alert.openmainvenuemodel");
        [self getAlertViewWidth:hudTitle.stringValue];
        [self persendMethod:2];
    }else if (sender == _showContentVideo) {
        [contentWindow.window orderFront:nil];
    }else if (sender == _moreBtn) {
        _menuViewBg.hidden = !_menuViewBg.hidden;
    }else if (sender == callendBtn) {
        NSMutableDictionary *setDic = [NSMutableDictionary dictionaryWithDictionary:[PlistUtils loadUserInfoPlistFilewithFileName:SETINFO]];
        DDLogInfo(@"[Info] 10012 user handup the meeting:%@", setDic[@"confId"]);
        _messageView.hidden = YES;
        numberTitle.stringValue = @"";
        //call hanp up
        Notifications(CLOSEMANMAGEWINDOW);
        Notifications(CLOSESIGNLWINDOW);
        Notifications(CLOSELOCALWINDOW);
        Notifications(CLOSECONTENTWINDOW);
        Notifications(CLOSEMEETINGWEBWINDOW);
        [self->contentWindow.window close];
        for (int i = 0; i<remoteList.count; i++) {
            remotVideoController = remoteList[i];
            remotVideoController.view.frame = CGRectMake(0, 0, 0, 0);
        }
        
        [appDelegate.evengine hangUp];
        
//        [self usercallEndMeeting];
        
    }else if (sender == cancelVideo) {
        EVLayoutRequest *layout = [[EVLayoutRequest alloc] init];
        layout.page = EVLayoutCurrentPage;
        layout.mode = layoutType;
        layout.max_type = EVLayoutType_5_4T_1B;
        EVVideoSize vsize;
        vsize.width = 0;
        vsize.height = 0;
        layout.max_resolution = vsize;
        [appDelegate.evengine setLayout:layout];
        cancelVideo.hidden = YES;
    }else if (sender == _switchAudioBtn) {
        [_switchAudioBtn setButtonState:SWSTAnswerButtonNormalState];
        [self enterAudioMode];
    }else if (sender == _changeNameBtn) {
        [_changeNameBtn setButtonState:SWSTAnswerButtonNormalState];
        if ([appDelegate.evengine getDisplayName] != nil) {
            _inputNameField.stringValue = [appDelegate.evengine getDisplayName];
        }else{
            _inputNameField.stringValue = localizationBundle(@"video.localdisplayname");
        }
        _changeNameViewBg.hidden = NO;
        _menuViewBg.hidden = YES;
    }else if (sender == _exitAudioBtn) {
        [self enterVideoMode];
    }else if (sender == _showLocalBtn) {
        Notifications(SHOWLOCAL);
        _showLocalView.hidden = YES;
        _showContentConstraint.constant = 10;
    }
}

//进入语音模式
- (void)enterAudioMode
{
    Notifications(HIDDENLOCALWINDOW);
    self.showLocalBtn.enabled = NO;
    self.zheView.hidden = NO;
    _audioViewBg.hidden = NO;
    [appDelegate.evengine setVideoActive:0];
    
    cameraBtn.hidden = YES;
    cameraTitle.hidden = YES;
    
    shareBtn.hidden = YES;
    shareTitle.hidden = YES;
    
    videoLayoutBtn.hidden = YES;
    videoTitle.hidden = YES;
    
    _moreBtn.hidden = YES;
    _moreTitle.hidden = YES;
    
    _menuViewBg.hidden = YES;
    
    _audioConstraint.constant = 108;
    
    NSMutableDictionary *setInfo = [NSMutableDictionary dictionaryWithDictionary:[PlistUtils loadUserInfoPlistFilewithFileName:SETINFO]];
    if ([setInfo[@"chatInConference"] boolValue] && [setInfo[@"getIMAddress"] boolValue]) {
        //包含会议聊天
        _chatBtn.hidden = NO;
        _chatTitle.hidden = NO;
        _videoLayoutConstraint.constant = 108;
    }else {
        //没有会议聊天
        _chatBtn.hidden = YES;
        _chatTitle.hidden = YES;
        _videoLayoutConstraint.constant = 40;
    }
    
}
//进入视频模式
- (void)enterVideoMode
{
    self.showLocalBtn.enabled = YES;
    self.zheView.hidden = YES;
    _audioViewBg.hidden = YES;
    [appDelegate.evengine setVideoActive:3];
    
    cameraBtn.hidden = NO;
    cameraTitle.hidden = NO;
    
    shareBtn.hidden = NO;
    shareTitle.hidden = NO;
    
    videoLayoutBtn.hidden = NO;
    videoTitle.hidden = NO;
    
    _moreBtn.hidden = NO;
    _moreTitle.hidden = NO;
    
    _audioConstraint.constant = 259;
    
    NSMutableDictionary *setInfo = [NSMutableDictionary dictionaryWithDictionary:[PlistUtils loadUserInfoPlistFilewithFileName:SETINFO]];
    if ([setInfo[@"chatInConference"] boolValue] && [setInfo[@"getIMAddress"] boolValue]) {
        //包含会议聊天
        _chatBtn.hidden = NO;
        _chatTitle.hidden = NO;
        _videoLayoutConstraint.constant = 108;
    }else {
        //没有会议聊天
        _chatBtn.hidden = YES;
        _chatTitle.hidden = YES;
        _videoLayoutConstraint.constant = 40;
    }
}

- (void)getAlertViewWidth:(NSString *)str {
    CGFloat width = [self getWidthWithText:str height:20 font:14];
    if (width < 400) {
        _alertViewConstraint.constant = width + 100;
    }else {
        _alertViewConstraint.constant = 500;
    }
    
}

- (IBAction)openSignlWindowAction:(id)sender
{
    Notifications(CLOSESIGNLWINDOW);
    SignalWindowController *WinControl = [SignalWindowController windowController];
    [WinControl.window makeKeyAndOrderFront:self];
}

#pragma mark - Notification
- (void)changeLanguage:(NSNotification *)sender
{
    
    setTitle.stringValue = localizationBundle(@"video.set");
    meetingTitle.stringValue = localizationBundle(@"video.meetingmanagement");
    _chatTitle.stringValue = localizationBundle(@"video.chat");
    _showLocalTitle.stringValue = localizationBundle(@"video.openlocalvideo");
    _showContentTitle.stringValue = localizationBundle(@"video.showcontent");
    _moreTitle.stringValue = localizationBundle(@"video.more");
    shareTitle.stringValue = localizationBundle(@"video.share");
    _exitAudioTitle.stringValue = localizationBundle(@"video.exitAudioTitle");
    _changeNameTitle.stringValue = localizationBundle(@"video.rename");
    _inputNameTitle.stringValue = localizationBundle(@"video.inputNewName");
    
    [_closeLocalBtn changeCenterButtonattribute:localizationBundle(@"video.closelocalvideo") color:WHITECOLOR];
//    [_moreBtn changeCenterButtonattribute:@"" color:WHITECOLOR];
    [handBtn changeCenterButtonattribute:localizationBundle(@"video.handup") color:WHITECOLOR];
    [_switchAudioBtn changeCenterButtonattribute:localizationBundle(@"video.changeMode") color:WHITECOLOR];
    [_changeNameBtn changeCenterButtonattribute:localizationBundle(@"video.changeName") color:WHITECOLOR];
    
//    locaVideoController.view.hidden = NO;
    
    if (ismute) {
        muteTitle.stringValue = localizationBundle(@"video.unmute");
        muteTitle.textColor = DEFAULREDCOLOR;
    }else {
        muteTitle.stringValue = localizationBundle(@"video.mute");
        muteTitle.textColor = WHITECOLOR;
    }
    
    if (iscamera) {
        cameraTitle.stringValue = localizationBundle(@"video.stopvideo");
        cameraTitle.textColor = DEFAULREDCOLOR;
    }else {
        cameraTitle.stringValue = localizationBundle(@"video.openvideo");
        cameraTitle.textColor = WHITECOLOR;
    }
    
    if (islayout) {
        videoTitle.stringValue = localizationBundle(@"video.layoutswitch");
    }else {
        videoTitle.stringValue = localizationBundle(@"video.layoutswitch");
    }
}

- (void)hiddenLocal
{
    DDLogInfo(@"[Info] 10033 Receive user minification requests");
    _showLocalView.hidden = NO;
    _showContentConstraint.constant = 130;
}

- (void)closeWindow
{
    [self.view.window close];
}

- (void)chooseVideo:(NSNotification *)sender
{
    chooseVideoName = sender.object;
}

- (void)setTimer
{
    seconds = 0;
    
    DDLogInfo(@"[Info] 10016 Timer start");
    
    [self enterVideoMode];
    
    [appDelegate.evengine setDelegate:self];
    
    NSMutableDictionary *setDic = [NSMutableDictionary dictionaryWithDictionary:[PlistUtils loadUserInfoPlistFilewithFileName:SETINFO]];
    if ([setDic[@"conftype"] isEqualToString:@"p2p"]) {
        meetingNumber.stringValue = @"";
        [setDic setValue:@"conf" forKey:@"conftype"];
    }else {
        meetingNumber.stringValue = setDic[@"confId"];
    }
    [PlistUtils saveUserInfoPlistFile:(NSDictionary *)setDic withFileName:SETINFO];
    
    [self getUserSet];
                    
//     开启定时器
    if (_timer) {
        dispatch_resume(_timer);
    }else{
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        
        dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
        
        dispatch_source_set_event_handler(_timer, ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:MUTENAME object:self->muteArr];
                if (self->ismute == NO && self->isservermute == NO) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:ISLOCALMUTE object:@"unmute"];
                }else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:ISLOCALMUTE object:@"mute"];
                }
                for (int i = 0; i<self->remoteList.count; i++)
                {
                    self->remotVideoController = self->remoteList[i];
                    self->remotVideoController.muteBg.hidden = YES;
                    self->remotVideoController.nameConstraint.constant = 5;
                    for (NSString *name in self->muteArr) {
                        if ([self->remotVideoController.userName.stringValue isEqualToString:name]) {
                            self->remotVideoController.muteBg.hidden = NO;
                            self->remotVideoController.nameConstraint.constant = 20;
                        }
                    }
                }
                
                if (self->isshare) {
                    NSArray *screens = [NSScreen screens];
                    for (int i = 0; i<screens.count; i++) {
                        NSScreen *screen = screens[i];
                        uint32 sad = [screen.deviceDescription[@"NSScreenNumber"] intValue];
                        if (sad == self->contentid) {
                            CGFloat windowWidth = screen.frame.size.width;
                            CGFloat windowHeight = screen.frame.size.height;
                            [self->localControl.window setFrame:NSMakeRect(0, 0, windowWidth, windowHeight) display:NO];
                            [self->localControl.window setFrameOrigin:NSMakePoint(screen.frame.origin.x, screen.frame.origin.y)];
                        }
                    }
                }
                
                seconds ++;
                [EVUtils saveNewLogWhenOldLogTooBig];
                self->timerLb.stringValue = [EVUtils formaterSecondsToTimer:seconds];
            });
        });
        
        dispatch_resume(_timer);
        
    }
}

- (void)saveIamge
{
    /** 保存图片到桌面 */
    CFStringRef dspyDestType = CFSTR("public.png");
    CGDirectDisplayID mainID = contentid;
    // 根据Quartz分配给显示器的id，生成显示器mainID的截图
    CGImageRef mainCGImage = CGDisplayCreateImage(mainID);
    CFMutableDataRef mainMutData = CFDataCreateMutable(NULL, 0);
    CGImageDestinationRef mainDest = CGImageDestinationCreateWithData(mainMutData, dspyDestType, 1, NULL);
    CGImageDestinationAddImage(mainDest, mainCGImage, NULL);
    CGImageRelease(mainCGImage);
    CGImageDestinationFinalize(mainDest);
    CFRelease(mainDest);
    NSData *imageDate = (__bridge NSData *)mainMutData;
    CFRelease(mainMutData);
    CFRelease(dspyDestType);
    
    NSImage *tmpImage = [[NSImage alloc] initWithData:imageDate];
    
    NSData *imageData = [tmpImage TIFFRepresentation];
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
    [imageRep setSize:[tmpImage size]];
    NSData *imageData1 = [imageRep representationUsingType:NSPNGFileType properties:nil];
    
    //获取保存路径暂时保存在桌面
    NSString *filePath = [EVUtils get_download_app_path];
    filePath = [NSString stringWithFormat:@"%@/%@-%@", filePath, [EVUtils getCurrentTimes], @"ScreenCapture.png"];
    NSError *errpr;
    if ([imageData1 writeToFile:filePath options:NSDataWritingAtomic error:&errpr]) {
        //成功
        NSLog(@"成功");
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:filePath]) {
            [[NSWorkspace sharedWorkspace] openFile:filePath];
        }else {
            self->hud.hidden = NO;
            self->hudTitle.stringValue = localizationBundle(@"alert.savefailed");
            [self getAlertViewWidth:hudTitle.stringValue];
            [self persendMethod:2];
        }
    }else {
        //失败
        self->hud.hidden = NO;
        self->hudTitle.stringValue = localizationBundle(@"alert.savefailed");
        [self getAlertViewWidth:hudTitle.stringValue];
        [self persendMethod:2];
    }
}

- (void)localContentClose
{
    isshare = NO;
    [appDelegate.evengine stopContent];
    [self.view.window orderFront:nil];
}

- (void)sendContent:(NSNotification *)sender
{
    NSArray *screens = [NSScreen screens];
    for (int i = 0; i<screens.count; i++) {
        NSScreen *screen = screens[i];
        if (screen.deviceDescription[@"NSScreenNumber"] == sender.object) {
            contentid = [screen.deviceDescription[@"NSScreenNumber"] intValue];
            [appDelegate.evengine setLocalContentWindow:&contentid mode:EVContentFullMode];
            [appDelegate.evengine sendContent];
        }
    }
}

- (void)usercallEndMeeting
{
    Notifications(CLOSEMANMAGEWINDOW);
    Notifications(CLOSESIGNLWINDOW);
    Notifications(CLOSELOCALWINDOW);
    Notifications(CLOSECONTENTWINDOW);
    Notifications(CLOSEMEETINGWEBWINDOW);
    Notifications(REMOVEVIDEO);
    Notifications(CLOSELOCALCONTENTWINDOW);
    Notifications(CLOSESCREENWINDOW);
    
    [appDelegate.evengine enableCamera:YES];
    isshare = NO;
    appDelegate.isInTheMeeting = NO;
    chooseVideoName = @"";
    [contentWindow.window close];
    [self.view.window close];
    NSMutableDictionary *setDic = [NSMutableDictionary dictionaryWithDictionary:[PlistUtils loadUserInfoPlistFilewithFileName:SETINFO]];
    DDLogInfo(@"[Info] 10015 callback handup the meeting:%@", setDic[@"confId"]);
    // 关闭定时器
    DDLogInfo(@"[Info] 10017 Timer stop");
    dispatch_source_cancel(_timer);
    seconds = 0;
    for (int i = 0; i<remoteList.count; i++) {
        remotVideoController = remoteList[i];
        remotVideoController.view.frame = CGRectMake(0, 0, 0, 0);
    }
    if ([[NSUSERDEFAULT objectForKey:@"anonymous"] isEqualToString:@"YES"]) {
        DDLogInfo(@"[Info] 10038 leave meeting go to login window");
        Notifications(SHOWLOGINWINDOW);
    }else {
        DDLogInfo(@"[Info] 10037 leave meeting go to home window");
        HomeWindowController *WinControl = [HomeWindowController windowController];
        appDelegate.mainWindowController = WinControl;
        [WinControl.window makeKeyAndOrderFront:self];
    }
}

#pragma mark - NSTextFieldDelegate
- (void)controlTextDidChange:(NSNotification *)obj {
    if ([[_inputNameField stringValue] length] > 32) {
        [_inputNameField setStringValue:[[_inputNameField stringValue] substringToIndex:32]];
    }
}

#define mark - EVEngineDelegate
- (void)onNetworkQuality:(float)quality_rating
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self->signalImage.image = [NSImage imageNamed:[NSString stringWithFormat:@"icon_0%d", (int)quality_rating]];
    });
}

- (void)onMuteSpeakingDetected
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *infoDic = [PlistUtils loadUserInfoPlistFilewithFileName:SETINFO];
        if (infoDic[@"closeTip"]) {
            if ([infoDic[@"closeTip"] isEqualToString:@"YES"]) {
                return;
            }
        }
        self->hud.hidden = NO;
        self->hudTitle.stringValue = localizationBundle(@"alert.micmute");
        [self getAlertViewWidth:self->hudTitle.stringValue];
        [self persendMethod:10];
    });
}

- (void)onWarn:(EVWarn *)warn
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *infoDic = [PlistUtils loadUserInfoPlistFilewithFileName:SETINFO];
        if (infoDic[@"closeTip"]) {
            if ([infoDic[@"closeTip"] isEqualToString:@"YES"]) {
                if (warn.code == EVWarnNetworkPoor || warn.code == EVWarnNetworkVeryPoor || warn.code == EVWarnBandwidthInsufficient || warn.code == EVWarnBandwidthVeryInsufficient) {
                    return;
                }
            }
        }
        
        if (warn.code == EVWarnNetworkPoor) {
            self->hud.hidden = NO;
            self->hudTitle.stringValue = localizationBundle(@"alert.network_stable");
            [self getAlertViewWidth:self->hudTitle.stringValue];
            self.buttomViewBg.hidden = NO;
            [self persendMethod:10];
        }else if (warn.code == EVWarnNetworkVeryPoor) {
            self->hud.hidden = NO;
            self->hudTitle.stringValue = localizationBundle(@"alert.network_poor");
            [self getAlertViewWidth:self->hudTitle.stringValue];
            self.buttomViewBg.hidden = NO;
            [self persendMethod:10];
        }else if (warn.code == EVWarnBandwidthInsufficient) {
            self->hud.hidden = NO;
            self->hudTitle.stringValue = localizationBundle(@"alert.network_insufficient");
            [self getAlertViewWidth:self->hudTitle.stringValue];
            self.buttomViewBg.hidden = NO;
            [self persendMethod:10];
        }else if (warn.code == EVWarnBandwidthVeryInsufficient) {
            self->hud.hidden = NO;
            self->hudTitle.stringValue = localizationBundle(@"alert.network_shortage");
            [self getAlertViewWidth:self->hudTitle.stringValue];
            self.buttomViewBg.hidden = NO;
            [self persendMethod:10];
        }else if (warn.code == EVWarnUnmuteAudioNotAllowed) {
            self->hud.hidden = NO;
            self->hudTitle.stringValue = localizationBundle(@"alert.nnmuteAudioNotAllowed");
            [self getAlertViewWidth:self->hudTitle.stringValue];
            self.buttomViewBg.hidden = NO;
            [self persendMethod:10];
        }else if (warn.code == EVWarnUnmuteAudioIndication) {
            NSAlert *alert = [NSAlert new];
            [alert addButtonWithTitle:localizationBundle(@"alert.sure")];
            [alert addButtonWithTitle:localizationBundle(@"alert.cancel")];
            [alert setMessageText:@""];
            [alert setInformativeText:localizationBundle(@"alert.nnmuteAudioIndication")];
            [alert setAlertStyle:NSAlertStyleInformational];
            [alert beginSheetModalForWindow:[self.view window] completionHandler:^(NSModalResponse returnCode) {
                if(returnCode == NSAlertFirstButtonReturn){
                    [self->appDelegate.evengine enableMic:YES];
                    self->ismute = NO;
                    if (self->ismute) {
                        DDLogInfo(@"[Info] micEnabled:YES.");
                        self->muteTitle.stringValue = localizationBundle(@"video.unmute");
                        self->muteTitle.textColor = DEFAULREDCOLOR;
                        [self->muteBtn setButtonState:SWSTAnswerButtonSelectedState];
                    }else {
                        DDLogInfo(@"[Info] micEnabled:NO.");
                        self->muteTitle.stringValue = localizationBundle(@"video.mute");
                        self->muteTitle.textColor = WHITECOLOR;
                        [self->muteBtn setButtonState:SWSTAnswerButtonNormalState];
                    }
                }else if(returnCode == NSAlertSecondButtonReturn){
                    [self->appDelegate.evengine enableMic:NO];
                    self->ismute = YES;
                    if (self->ismute) {
                        DDLogInfo(@"[Info] micEnabled:YES.");
                        self->muteTitle.stringValue = localizationBundle(@"video.unmute");
                        self->muteTitle.textColor = DEFAULREDCOLOR;
                        [self->muteBtn setButtonState:SWSTAnswerButtonSelectedState];
                    }else {
                        DDLogInfo(@"[Info] micEnabled:NO.");
                        self->muteTitle.stringValue = localizationBundle(@"video.mute");
                        self->muteTitle.textColor = WHITECOLOR;
                        [self->muteBtn setButtonState:SWSTAnswerButtonNormalState];
                    }
                }
            }];
        }
        
    });
}

- (void)onCallEnd:(EVCallInfo * _Nonnull)info
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //call hanp up
        
        Notifications(CLOSEMANMAGEWINDOW);
        Notifications(CLOSESIGNLWINDOW);
        Notifications(CLOSELOCALWINDOW);
        Notifications(CLOSECONTENTWINDOW);
        Notifications(CLOSEMEETINGWEBWINDOW);
        Notifications(REMOVEVIDEO);
        Notifications(CLOSELOCALCONTENTWINDOW);
        Notifications(CLOSESCREENWINDOW);
        
        if ([EVUtils queryUserPlist:@"chatInConference"]) {
            [[EMMessageManager sharedInstance] selectEntity:nil ascending:YES filterString:nil success:^(NSArray *results) {
                NSLog(@"数据---%@",results);
                //全部删除
                for (NSManagedObject *obj in results){
                    [[EMMessageManager sharedInstance] deleteEntity:obj success:^{
                    } fail:^(NSError *error) {
                    }];
                }
            } fail:nil];
            
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
            
            [[EMManager sharedInstance].delegates onCallEnd];
            
            [self->appDelegate.emengine logout];
        }
        
        [self enterVideoMode];
        
        self->_speakerViewBg.hidden = YES;
        
        self->_menuViewBg.hidden = YES;
        self->isshare = NO;
        self->isMuteforEnd = NO;
        self->appDelegate.isInTheMeeting = NO;
        self->chooseVideoName = @"";
        self->isshowLocal = YES;
        [self->contentWindow.window close];
        [self.view.window close];
        NSMutableDictionary *setDic = [NSMutableDictionary dictionaryWithDictionary:[PlistUtils loadUserInfoPlistFilewithFileName:SETINFO]];
        DDLogInfo(@"[Info] 10015 callback handup the meeting:%@", setDic[@"confId"]);
        // 关闭定时器
        DDLogInfo(@"[Info] 10017 Timer stop");
        dispatch_source_cancel(self->_timer);
        seconds = 0;
        for (int i = 0; i<self->remoteList.count; i++) {
            self->remotVideoController = self->remoteList[i];
            self->remotVideoController.view.frame = CGRectMake(0, 0, 0, 0);
        }
        if ([[NSUSERDEFAULT objectForKey:@"anonymous"] isEqualToString:@"YES"]) {
            DDLogInfo(@"[Info] 10038 leave meeting go to login window");
            Notifications(SHOWLOGINWINDOW);
        }else {
            DDLogInfo(@"[Info] 10037 leave meeting go to home window");
            HomeWindowController *WinControl = [HomeWindowController windowController];
            self->appDelegate.mainWindowController = WinControl;
            [WinControl.window makeKeyAndOrderFront:self];
        }
        
    });
}

- (void)onCallConnected:(EVCallInfo * _Nonnull)info
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
}

- (void)onCallIncoming:(EVCallInfo * _Nonnull)info
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
}

- (void)onContent:(EVContentInfo * _Nonnull)info
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (info.status == EVContentDenied) {
            self->hud.hidden = NO;
            self->hudTitle.stringValue = localizationBundle(@"alert.nosharepermission");
            [self getAlertViewWidth:self->hudTitle.stringValue];
            [self persendMethod:2];
        }else if (EVContentGranted) {
            if (info.type == EVStreamContent || info.type == EVStreamWhiteBoard) {
                if (info.enabled) {
                    if (info.dir == EVStreamUpload) {
                        self->hud.hidden = NO;
                        self->hudTitle.stringValue = localizationBundle(@"alert.sharesuccess");
                        [self getAlertViewWidth:self->hudTitle.stringValue];
                        [self.view.window miniaturize:self];
                        [self persendMethod:1];
                        NSArray *screens = [NSScreen screens];
                        for (int i = 0; i<screens.count; i++) {
                            NSScreen *screen = screens[i];
                            uint32 sad = [screen.deviceDescription[@"NSScreenNumber"] intValue];
                            if (sad == self->contentid) {
                                [self->localControl.window makeKeyAndOrderFront:nil];
                                [self->localControl.window setRestorable:NO];
                                CGFloat windowWidth = screen.frame.size.width;
                                CGFloat windowHeight = screen.frame.size.height;
                                [self->localControl.window setFrame:NSMakeRect(0, 0, windowWidth, windowHeight) display:NO];
                                [self->localControl.window setFrameOrigin:NSMakePoint(screen.frame.origin.x, screen.frame.origin.y)];
                                [self->localControl.window makeKeyAndOrderFront:nil];
                                
                                self->isshare = YES;
                            }
                            if (sad == self->contentid) {
                                [self->localControl.window makeKeyAndOrderFront:nil];
                                [self->localControl.window setRestorable:NO];
                                CGFloat windowWidth = screen.frame.size.width;
                                CGFloat windowHeight = screen.frame.size.height;
                                [self->localControl.window setFrame:NSMakeRect(0, 0, windowWidth, windowHeight) display:NO];
                                [self->localControl.window setFrameOrigin:NSMakePoint(screen.frame.origin.x, screen.frame.origin.y)];
                                [self->localControl.window makeKeyAndOrderFront:nil];
                                
                                self->isshare = YES;
                            }
                            self.showContentView.hidden = YES;
                            [self->contentWindow.window close];
                        }
                    }else{
                        if (self->isshare) {
                            self->isshare = NO;
                            [self->appDelegate.evengine stopContent];
                            [self->localControl.window orderOut:nil];
                        }
                        DDLogInfo(@"[Info] 10047 user receive open contentWindow");
                        [self->contentWindow.window orderFront:nil];
                        self.showContentView.hidden = NO;
                        if (self->_showLocalView.hidden) {
                            self->_showContentConstraint.constant = 10;
                        }else {
                            self->_showContentConstraint.constant = 130;
                        }
                        self->isshowContent = YES;
                        if (self->ismyselfmute) {
                            self.centerLine.constant = 0;
                            self.showContentleft.constant = 140;
                        }else{
                            self.centerLine.constant = 35;
                            self.showContentleft.constant = 70;
                        }
                    }
                    
                }else{
                    DDLogInfo(@"[Info] 10048 user receive close contentWindow");
                    [self->contentWindow.window close];
                    self.showContentView.hidden = YES;
                    if (self->ismyselfmute) {
                        self.centerLine.constant = 35;
                        self.showContentleft.constant = 70;
                    }else{
                        self.centerLine.constant = 70;
                        self.showContentleft.constant = 70;
                    }
                }
            }
        }
    });
}

- (void)onLayoutIndication:(EVLayoutIndication *_Nonnull)layout{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (layout.speaker_name.length != 0) {
            self->_speakerName.stringValue = layout.speaker_name;
            if (!self->_audioViewBg.hidden) {
                self->_speakerViewBg.hidden = NO;
                if (!self->_audioViewBg.hidden) {
                    self->_speakerViewBg.hidden = NO;
                    if (self.recordBg.hidden == YES && self->cancelVideo.hidden == YES) {
                        self->_speakerConstraint.constant = 20;
                    }else if (self.recordBg.hidden == YES && self->cancelVideo.hidden == NO) {
                        self->_speakerConstraint.constant = 90;
                    }else if (self.recordBg.hidden == NO && self->cancelVideo.hidden == YES) {
                        self->_speakerConstraint.constant = 90;
                    }else if (self.recordBg.hidden == NO && self->cancelVideo.hidden == NO) {
                        self->_speakerConstraint.constant = 178;
                    }
                }
            }else {
                if (layout.speaker_index == -1) {
                    self->_speakerViewBg.hidden = NO;
                    if (!self->_audioViewBg.hidden) {
                        self->_speakerViewBg.hidden = NO;
                        if (self.recordBg.hidden == YES && self->cancelVideo.hidden == YES) {
                            self->_speakerConstraint.constant = 20;
                        }else if (self.recordBg.hidden == YES && self->cancelVideo.hidden == NO) {
                            self->_speakerConstraint.constant = 90;
                        }else if (self.recordBg.hidden == NO && self->cancelVideo.hidden == YES) {
                            self->_speakerConstraint.constant = 90;
                        }else if (self.recordBg.hidden == NO && self->cancelVideo.hidden == NO) {
                            self->_speakerConstraint.constant = 178;
                        }
                    }
                }else {
                    self->_speakerViewBg.hidden = YES;
                }
            }
        }else {
            self->_speakerViewBg.hidden = YES;
        }
        
        self->isMainVenue = layout.mode_settable;
        if (self->isMainVenue) {
//            self->videoLayoutBtn.enabled = YES;
//            self->videoTitle.alphaValue  = 1;
            self->_alertBtn.hidden       = YES;
            DDLogInfo(@"[Info] 10036 User receives a message to close the main venue");
        }else {
//            self->videoLayoutBtn.enabled = NO;
//            self->videoTitle.alphaValue  = 0.5;
            self->_alertBtn.hidden       = NO;
            DDLogInfo(@"[Info] 10035 User receives the message to open the main venue");
        }
        if (layout.mode == EVLayoutSpeakerMode) {
            //判断第一个窗口
            EVSite *site = layout.sites[0];
            if (self->chooseVideoName.length != 0) {
                if ([self->chooseVideoName isEqualToString:site.name]) {
                    self->cancelVideo.hidden = NO;
                    if (self->cancelVideoConstraint.constant == 90) {
                        self->_speakerConstraint.constant = 178;
                    }else {
                        self->_speakerConstraint.constant = 90;
                    }
                }else {
                    //fixed clear saved user when video change
                    self->cancelVideo.hidden = YES;
                    self->chooseVideoName = @"";
                }
            }
        }else {
            //other mode cancelVideo button shoud hidden
            self->cancelVideo.hidden = YES;
            self->chooseVideoName = @"";
        }
        
        for (int i = 0; i<layout.sites.count; i++) {
            EVSite *site = layout.sites[i];
            if (site.mic_muted) {
                for (int i = 0; i<self->muteArr.count; i++) {
                    if ([self->muteArr[i] isEqualToString:site.name]) {
                        [self->muteArr removeObjectAtIndex:i];
                    }
                }
                [self->muteArr addObject:site.name];
                DDLogInfo(@"[Info] user mute from device_id:%llu userName:%@", site.device_id, site.name);
    
            }else {
                for (int i = 0; i<self->muteArr.count; i++) {
                    if ([self->muteArr[i] isEqualToString:site.name]) {
                        [self->muteArr removeObjectAtIndex:i];
                    }
                }
                DDLogInfo(@"[Info] user mute from device_id:%llu userName:%@", site.device_id, site.name);
            }
            for (NSString *name in self->muteArr) {
                if ([self->remotVideoController.userName.stringValue isEqualToString:name]) {
                    self->remotVideoController.muteBg.hidden = NO;
                    self->remotVideoController.nameConstraint.constant = 20;
                }
            }
        }
        if (layout.setting_mode != EVLayoutAutoMode && layout.setting_mode != EVLayoutSpecifiedMode) {
            //unEVLayoutAutoMode
            self->layoutType = layout.setting_mode;
            if (layout.setting_mode == EVLayoutSpeakerMode) {
                [[NSNotificationCenter defaultCenter] postNotificationName:MUTENAME object:self->muteArr];
                self->islayout = YES;
                self->videoTitle.stringValue = localizationBundle(@"video.layoutswitch");
                [self->videoLayoutBtn setButtonState:SWSTAnswerButtonSelectedState];
                for (int i = 0; i<self->remoteList.count; i++)
                {
                    self->remotVideoController = self->remoteList[i];
                    if (i == 0) {
                        if (self->isShowButtomBg) {
                            self->remotVideoController.nameConstraintH.constant = 85;
                        }else {
                            self->remotVideoController.nameConstraintH.constant = 10;
                        }
                    }
                    [self->remotVideoController setNormolSpeaker];
                    self->remotVideoController.muteBg.hidden = YES;
                    self->remotVideoController.nameConstraint.constant = 5;
                    for (NSString *name in self->muteArr) {
                        if ([self->remotVideoController.userName.stringValue isEqualToString:name]) {
                            self->remotVideoController.muteBg.hidden = NO;
                            self->remotVideoController.nameConstraint.constant = 20;
                        }
                    }
                }
            }else if (layout.setting_mode == EVLayoutGalleryMode) {
                self->islayout = NO;
                self->videoTitle.stringValue = localizationBundle(@"video.layoutswitch");
                [self->videoLayoutBtn setButtonState:SWSTAnswerButtonNormalState];
                for (int i = 0; i<self->remoteList.count; i++)
                {
                    self->remotVideoController = self->remoteList[i];
                    if (i == 0) {
                        self->remotVideoController.nameConstraintH.constant = 10;
                    }
                    self->remotVideoController.muteBg.hidden = YES;
                    self->remotVideoController.nameConstraint.constant = 5;
                    for (NSString *name in self->muteArr) {
                        if ([self->remotVideoController.userName.stringValue isEqualToString:name]) {
                            self->remotVideoController.muteBg.hidden = NO;
                            self->remotVideoController.nameConstraint.constant = 20;
                        }
                    }
                    
                    if ([self->remotVideoController.userName.stringValue isEqualToString:layout.speaker_name])
                    {
                        [self->remotVideoController setActiveSpeaker];
                    }else{
                        [self->remotVideoController setNormolSpeaker];
                    }
                }
            }
            
        }else {
            //EVLayoutAutoMode
            self->layoutType = layout.mode;
            if (layout.mode == EVLayoutSpeakerMode) {
                [[NSNotificationCenter defaultCenter] postNotificationName:MUTENAME object:self->muteArr];
                self->islayout = YES;
                self->videoTitle.stringValue = localizationBundle(@"video.layoutswitch");
                [self->videoLayoutBtn setButtonState:SWSTAnswerButtonSelectedState];
                for (int i = 0; i<self->remoteList.count; i++)
                {
                    self->remotVideoController = self->remoteList[i];
                    [self->remotVideoController setNormolSpeaker];
                    self->remotVideoController.muteBg.hidden = YES;
                    self->remotVideoController.nameConstraint.constant = 5;
                    for (NSString *name in self->muteArr) {
                        if ([self->remotVideoController.userName.stringValue isEqualToString:name]) {
                            self->remotVideoController.muteBg.hidden = NO;
                            self->remotVideoController.nameConstraint.constant = 20;
                        }
                    }
                }
            }else if (layout.mode == EVLayoutGalleryMode) {
                self->islayout = NO;
                self->videoTitle.stringValue = localizationBundle(@"video.layoutswitch");
                [self->videoLayoutBtn setButtonState:SWSTAnswerButtonNormalState];
                for (int i = 0; i<self->remoteList.count; i++)
                {
                    self->remotVideoController = self->remoteList[i];
                    self->remotVideoController.muteBg.hidden = YES;
                    self->remotVideoController.nameConstraint.constant = 5;
                    for (NSString *name in self->muteArr) {
                        if ([self->remotVideoController.userName.stringValue isEqualToString:name]) {
                            self->remotVideoController.muteBg.hidden = NO;
                            self->remotVideoController.nameConstraint.constant = 20;
                        }
                    }
                    
                    if ([self->remotVideoController.userName.stringValue isEqualToString:layout.speaker_name])
                    {
                        [self->remotVideoController setActiveSpeaker];
                    }else{
                        [self->remotVideoController setNormolSpeaker];
                    }
                }
            }
        }
        [self setLayoutMode:layout.sites];
        
    });
}

- (void)onParticipant:(int)number
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self->numberTitle.stringValue = [NSString stringWithFormat:@"%d", number];
    });
}

- (void)onLayoutSpeakerIndication:(EVLayoutSpeakerIndication *_Nonnull)speaker
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (speaker.speaker_name.length != 0) {
            self->_speakerName.stringValue = speaker.speaker_name;
            if (!self->_audioViewBg.hidden) {
                self->_speakerViewBg.hidden = NO;
                if (!self->_audioViewBg.hidden) {
                    self->_speakerViewBg.hidden = NO;
                    if (self.recordBg.hidden == YES && self->cancelVideo.hidden == YES) {
                        self->_speakerConstraint.constant = 20;
                    }else if (self.recordBg.hidden == YES && self->cancelVideo.hidden == NO) {
                        self->_speakerConstraint.constant = 90;
                    }else if (self.recordBg.hidden == NO && self->cancelVideo.hidden == YES) {
                        self->_speakerConstraint.constant = 90;
                    }else if (self.recordBg.hidden == NO && self->cancelVideo.hidden == NO) {
                        self->_speakerConstraint.constant = 178;
                    }
                }
            }else {
                if (speaker.speaker_index == -1) {
                    self->_speakerViewBg.hidden = NO;
                    if (!self->_audioViewBg.hidden) {
                        self->_speakerViewBg.hidden = NO;
                        if (self.recordBg.hidden == YES && self->cancelVideo.hidden == YES) {
                            self->_speakerConstraint.constant = 20;
                        }else if (self.recordBg.hidden == YES && self->cancelVideo.hidden == NO) {
                            self->_speakerConstraint.constant = 90;
                        }else if (self.recordBg.hidden == NO && self->cancelVideo.hidden == YES) {
                            self->_speakerConstraint.constant = 90;
                        }else if (self.recordBg.hidden == NO && self->cancelVideo.hidden == NO) {
                            self->_speakerConstraint.constant = 178;
                        }
                    }
                }else {
                    self->_speakerViewBg.hidden = YES;
                }
            }
        }else {
            self->_speakerViewBg.hidden = YES;
        }
        
        
        for (int i = 0; i<self->remoteList.count; i++)
        {
            self->remotVideoController = self->remoteList[i];
            
            if ([self->remotVideoController.userName.stringValue isEqualToString:speaker.speaker_name])
            {
                [self->remotVideoController setActiveSpeaker];
            }else{
                [self->remotVideoController setNormolSpeaker];
            }
        }
    });
}

- (void)onLayoutSiteIndication:(EVSite *_Nonnull)site
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //修改了会中名称
        for (int i = 0; i<self->remoteList.count; i++) {
            self->remotVideoController = self->remoteList[i];
            if (self->remotVideoController.videoView == site.window) {
                self->remotVideoController.userName.stringValue = site.name;
            }
        }
        
        if (site.is_local) {
            [[NSNotificationCenter defaultCenter] postNotificationName:CHANGEDISPLAYNAME object:site.name];
            if (site.remote_muted) {
                //被管理员禁言
                if (!self->isMuteforEnd) {
                    self->isMuteforEnd = YES;
                    self->hud.hidden = NO;
                    self->hudTitle.stringValue = localizationBundle(@"alert.nospeak");
                    [self getAlertViewWidth:self->hudTitle.stringValue];
                    self->isservermute = YES;
                    [self persendMethod:2];
                    self->handBtn.enabled = YES;
                    self->ismyselfmute = YES;
                    self.centerLine.constant = 35;
                    self.showContentleft.constant = 140;
                    DDLogInfo(@"[Info] 10026 user have been muted by meeting manager.");
                }
                
            }else{
                if (self->isMuteforEnd) {
                    self->isMuteforEnd = NO;
                    DDLogInfo(@"[Info] 10027 user have been unmuted by meeting manager.");
                    self->hud.hidden = NO;
                    self->hudTitle.stringValue = localizationBundle(@"alert.speak");
                    [self getAlertViewWidth:self->hudTitle.stringValue];
                    self->isservermute = NO;
                    [self persendMethod:2];
                    self->handBtn.enabled = NO;
                    self->ismyselfmute = NO;
                    self.centerLine.constant = 70;
                    self.showContentleft.constant = 70;
                }
                
            }

        }else {
            if (self->layoutType == EVLayoutGalleryMode) {
                
                if (site.mic_muted) {
                    [self->muteArr addObject:site.name];
                    DDLogInfo(@"[Info] user mute from device_id:%llu userName:%@", site.device_id, site.name);
                }else {
                    for (int i = 0; i<self->muteArr.count; i++) {
                        if ([self->muteArr[i] isEqualToString:site.name]) {
                            [self->muteArr removeObjectAtIndex:i];
                        }
                    }
                    DDLogInfo(@"[Info] user unmute from device_id:%llu userName:%@", site.device_id, site.name);
                }
                
                for (int i = 0; i<self->remoteList.count; i++)
                {
                    self->remotVideoController = self->remoteList[i];
                    self->remotVideoController.muteBg.hidden = YES;
                    self->remotVideoController.nameConstraint.constant = 5;
                    for (NSString *name in self->muteArr) {
                        if ([self->remotVideoController.userName.stringValue isEqualToString:name]) {
                            self->remotVideoController.muteBg.hidden = NO;
                            self->remotVideoController.nameConstraint.constant = 20;
                        }
                    }
                }
                
            }else {
                if (site.mic_muted) {
                    [self->muteArr addObject:site.name];
                    DDLogInfo(@"[Info] user mute from device_id:%llu userName:%@", site.device_id, site.name);
                }else {
                    for (int i = 0; i<self->muteArr.count; i++) {
                        if ([self->muteArr[i] isEqualToString:site.name]) {
                            [self->muteArr removeObjectAtIndex:i];
                        }
                    }
                    DDLogInfo(@"[Info] user mute from device_id:%llu userName:%@", site.device_id, site.name);
                }
                for (int i = 0; i<self->remoteList.count; i++)
                {
                    self->remotVideoController = self->remoteList[i];
                    self->remotVideoController.muteBg.hidden = YES;
                    self->remotVideoController.nameConstraint.constant = 5;
                    for (NSString *name in self->muteArr) {
                        if ([self->remotVideoController.userName.stringValue isEqualToString:name]) {
                            self->remotVideoController.muteBg.hidden = NO;
                            self->remotVideoController.nameConstraint.constant = 20;
                        }
                    }
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:MUTENAME object:self->muteArr];
            }
        }
    });
}

- (void)onMessageOverlay:(EVMessageOverlay *_Nonnull)msg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (msg.enable) {
            DDLogInfo(@"[Info] 10041 user receive open message");
            self->isNeedAnimation = NO;
            self->_messageView.hidden = YES;
            [self->_messageField.layer removeAllAnimations];
            self->isNeedAnimation = YES;
            self->_messageView.hidden = NO;
            self->verticalBorder = msg.verticalBorder;
            self->Messagecount = msg.displayRepetitions;
            self->_messageView.frame = CGRectMake(0, (WINDOWHEIGHT-76)*self->verticalBorder/100, WINDOWWIDTH, 40);
            CGFloat width = [self getWidthWithText:msg.content height:40 font:msg.fontSize];
            if (width>WINDOWWIDTH) {
                self->_messageField.frame = CGRectMake(0, 0, width+50, 40);
            }else {
                self->_messageField.frame = CGRectMake(0, 0, WINDOWWIDTH, 40);
            }
            self->_messageField.font = [NSFont systemFontOfSize:msg.fontSize];
            self->_messageField.textColor = [EVUtils colorWithHexString:msg.foregroundColor];
            float alphaValue = msg.transparency;
            [self->_messageView setBackgroundColor:[EVUtils colorWithHexString:msg.backgroundColor]withAlpha:(1-alphaValue/100)];
            self->_messageField.stringValue = msg.content;
            self->fontInteger = msg.fontSize;
            
            if (msg.displaySpeed == 0) {
                CGRect rect = [self getLabelHeightWithText:msg.content width:WINDOWWIDTH*2 font:msg.fontSize];
                CGFloat width = [self getWidthWithText:msg.content height:40 font:msg.fontSize];
                self->_messageField.hidden = YES;
                self->_staticField.hidden = NO;
                self->_staticField.font = [NSFont systemFontOfSize:msg.fontSize];
                self->_staticField.stringValue = msg.content;
                self->_staticField.textColor = [EVUtils colorWithHexString:msg.foregroundColor];
                self->_staticField.alignment = NSTextAlignmentCenter;
                if (width>WINDOWWIDTH) {
                    self->_messageField.hidden = NO;
                    self->_staticField.hidden = YES;
                    self->Messagecount = 10000;
                    self->timeInteger = 24;
                    [self setAnimation:self->_messageField withDuration:self->timeInteger];
                }else {
                    self->_staticField.frame = CGRectMake(0, (40-rect.size.height)/2, WINDOWWIDTH, rect.size.height);
                }
            }else {
                self->_messageField.hidden = NO;
                self->_staticField.hidden = YES;
                if (msg.displaySpeed == 2) {
                    self->timeInteger = 24;
                    [self setAnimation:self->_messageField withDuration:self->timeInteger];
                }else if (msg.displaySpeed == 5) {
                    self->timeInteger = 17;
                    [self setAnimation:self->_messageField withDuration:self->timeInteger];
                }else if (msg.displaySpeed == 8) {
                    self->timeInteger = 12;
                    [self setAnimation:self->_messageField withDuration:self->timeInteger];
                }
            }
            
        }else {
            DDLogInfo(@"[Info] 10042 user receive close message");
            self->isNeedAnimation = NO;
            self->_messageView.hidden = YES;
            [self->_messageField.layer removeAllAnimations];
        }
    });
}

- (void)onRecordingIndication:(EVRecordingInfo *_Nonnull)info
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (info.live) {
            self.recTitle.stringValue = @"LIVE";
            self.recordBg.hidden = NO;
            self->cancelVideoConstraint.constant = 90;
            if (self->cancelVideo.hidden) {
                self->_speakerConstraint.constant = 90;
            }else {
                self->_speakerConstraint.constant = 178;
            }
        }else {
            self.recTitle.stringValue = @"REC";
            if (info.state == EVRecordingStateNone) {
                DDLogInfo(@"[Info] 10043 Close recording");
                self.recordBg.hidden = YES;
                self->cancelVideoConstraint.constant = 20;
                if (self->cancelVideo.hidden) {
                    self->_speakerConstraint.constant = 20;
                }else {
                    self->_speakerConstraint.constant = 90;
                }
            }else if (info.state == EVRecordingStateOn) {
                DDLogInfo(@"[Info] 10044 Star recording");
                self.recordBg.hidden = NO;
                self->cancelVideoConstraint.constant = 90;
                if (self->cancelVideo.hidden) {
                    self->_speakerConstraint.constant = 90;
                }else {
                    self->_speakerConstraint.constant = 178;
                }
            }else if (info.state == EVRecordingStatePause) {
                DDLogInfo(@"[Info] 10045 Pause recording");
                self.recordBg.hidden = YES;
                self->cancelVideoConstraint.constant = 20;
                if (self->cancelVideo.hidden) {
                    self->_speakerConstraint.constant = 20;
                }else {
                    self->_speakerConstraint.constant = 90;
                }
            }
        }
    });
}

- (void)onMicMutedShow:(int)mic_muted
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self->ismute = mic_muted;
        if (self->ismute) {
            DDLogInfo(@"[Info] micEnabled:YES.");
            self->muteTitle.stringValue = localizationBundle(@"video.unmute");
            self->muteTitle.textColor = DEFAULREDCOLOR;
            [self->muteBtn setButtonState:SWSTAnswerButtonSelectedState];
        }else {
            DDLogInfo(@"[Info] micEnabled:NO.");
            self->muteTitle.stringValue = localizationBundle(@"video.mute");
            self->muteTitle.textColor = WHITECOLOR;
            [self->muteBtn setButtonState:SWSTAnswerButtonNormalState];
        }
    });
}

- (CGRect)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font: (CGFloat)font{
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[NSFont  systemFontOfSize:font]} context:nil];
    
    return rect;
}

- (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat)font{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)                                        options:NSStringDrawingUsesLineFragmentOrigin                                     attributes:@{NSFontAttributeName:[NSFont systemFontOfSize:font]}                                        context:nil];
    return rect.size.width;
}

#pragma mark - HIDDENHUD
- (void)persendMethod:(NSInteger)time
{
    dispatch_main_async_safe(^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self->hud.hidden = YES;
        });
    });
}

- (void)hiddenHUD
{
    dispatch_main_async_safe(^{
        self->hud.hidden = YES;
    });
}

- (void)showNotwordAlert
{
    isshowNotworkAlert = YES;
}

- (void)setAnimation:(NSView *)animationView withDuration:(NSInteger)time
{
    CGRect rect = [self getLabelHeightWithText:_messageField.stringValue width:WINDOWWIDTH*2 font:fontInteger];
    CGFloat width = [self getWidthWithText:_messageField.stringValue height:rect.size.height font:fontInteger];
    
    CABasicAnimation *basicAni   = [CABasicAnimation animation];
    basicAni.keyPath             = @"position";
    basicAni.fromValue           = [NSValue valueWithPoint:NSMakePoint(self.view.bounds.size.width, -(40-rect.size.height)/2)];
    basicAni.toValue             = [NSValue valueWithPoint:NSMakePoint(-width, -(40-rect.size.height)/2)];
    basicAni.duration            = time;
    basicAni.fillMode            = kCAFillModeForwards;
    basicAni.removedOnCompletion = YES;
    basicAni.delegate = self;
    [animationView.layer addAnimation:basicAni forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (isNeedAnimation) {
        Messagecount--;
        if (Messagecount==0) {
            self->isNeedAnimation = NO;
            self->_messageView.hidden = YES;
            [self->_messageField.layer removeAllAnimations];
            return;
        }
        [self setAnimation:_messageField withDuration:timeInteger];
    }
}

#pragma mark - HIDDENTOOL
- (void)hiddenTool
{
    if (isCanMove) {
        return;
    }
    isShowButtomBg = NO;
    buttomViewBg.hidden = YES;
    _menuViewBg.hidden = YES;
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    if (layoutType == EVLayoutSpeakerMode) {
        remotVideoController = remoteList[0];
        remotVideoController.nameConstraintH.constant = 10;
    }else {
        remotVideoController = remoteList[0];
        remotVideoController.nameConstraintH.constant = 10;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HIDDENLOCAL object:nil];
}

@end
