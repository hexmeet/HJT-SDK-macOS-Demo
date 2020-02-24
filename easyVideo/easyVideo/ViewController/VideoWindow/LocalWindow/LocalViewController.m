//
//  LocalViewController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/9/17.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "LocalViewController.h"
#import "VideoController.h"

@interface LocalViewController ()
{
    VideoController *locaVideoController;
    VideoController *remotVideoController;
    AppDelegate *appDelegate;
    NSArray *remotearr;
    NSMutableArray *remoteList;
    NSTrackingArea *trackingArea;
    void * remoteArr[5];
    EVLayoutMode layoutType;
    BOOL isspeaker;
    
    BOOL ishiddenLocal;
    BOOL ishover;
    BOOL localMute;
}
@end

@implementation LocalViewController

- (void)viewWillDisappear
{
    [super viewWillDisappear];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CLOSELOCALWINDOW object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HIDDENLOCAL object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:REFACTORINGLOCAL object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:REDUCTION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MUTENAME object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ISLOCALMUTE object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self.view setBackgroundColor:CLEARCOLOR];
    
    ishiddenLocal = NO;
    localMute = NO;
    
    [self.topBg setBackgroundColor:CONTENTCOLOR];
    [self.buttomBg setBackgroundColor:CONTENTCOLOR];
    
    self.topBg.hidden = YES;
    self.buttomBg.hidden = YES;
    
    NSTrackingAreaOptions options = NSTrackingInVisibleRect|NSTrackingMouseEnteredAndExited|NSTrackingActiveAlways;
    trackingArea = [[NSTrackingArea alloc] initWithRect:self.topView.bounds options:options owner:self userInfo:nil];
    
    [self.topView addTrackingArea:trackingArea];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeWindow) name:CLOSELOCALWINDOW object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showWindow) name:SHOWLOCAL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setVideo:) name:REFACTORINGLOCAL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reductionVideo) name:REDUCTION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(muteName:) name:MUTENAME object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localMute:) name:ISLOCALMUTE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenLocal) name:HIDDENLOCALWINDOW object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeDisplayName:) name:CHANGEDISPLAYNAME object:nil];
    
    appDelegate = APPDELEGATE;
    
    remoteList = [NSMutableArray arrayWithCapacity:1];
    
    locaVideoController = [[VideoController alloc] initWithViewAndType:LOCAL viewFrame:CGRectMake(0, self.view.bounds.size.height-110, 160, 90)];
    locaVideoController.view.layer.borderWidth = 2;
    locaVideoController.view.layer.borderColor = BLUECOLOR.CGColor;
//    locaVideoController.muteBg.hidden = NO;
    locaVideoController.userBg.hidden = NO;
    locaVideoController.userName.hidden = NO;
    if (localMute) {
        locaVideoController.muteBg.hidden = NO;
        locaVideoController.nameConstraint.constant = 20;
    }else {
        locaVideoController.muteBg.hidden = YES;
        locaVideoController.nameConstraint.constant = 5;
    }

    [self.view addSubview:locaVideoController.view];
    
    [appDelegate.evengine setLocalVideoWindow:(__bridge void *)(locaVideoController.videoView)];
    
    for (int i = 0; i<4; i++) {
        VideoController *remotVideo = [[VideoController alloc] initWithViewAndType:REMOTE viewFrame:CGRectMake(0, (3-i)*90, 160, 90)];
        [remotVideo.view setBackgroundColor:CLEARCOLOR];
        [self.view addSubview:remotVideo.view];
        remotVideo.userName.hidden = YES;
        remotVideo.userBg.hidden = YES;
        remoteArr[i+1] = (__bridge void *)(remotVideo.videoView);
        remotVideo.nameConstraint.constant = 5;
        remotVideo.userName.font = [NSFont systemFontOfSize:10];
        [remoteList addObject:remotVideo];
    }
    DDLogInfo(@"[Info] 10031 Set Local Video Window");
}

- (void)changeDisplayName:(NSNotification *)sender
{
    locaVideoController.userName.stringValue = sender.object;
}

- (void)setVideo:(NSNotification *)sender
{
    if ([appDelegate.evengine getDisplayName] != nil) {
        locaVideoController.userName.stringValue = [appDelegate.evengine getDisplayName];
    }else{
        locaVideoController.userName.stringValue = localizationBundle(@"video.localdisplayname");
    }
    
    layoutType = EVLayoutSpeakerMode;
    self.upBtn.hidden = YES;
    self.buttomBg.hidden = YES;
    isspeaker = NO;
    self.buttomBg.hidden = YES;
    self.upBtn.hidden = NO;
    NSMutableDictionary *data = sender.object;
    remotearr = data[@"remoteArr"];
    remotVideoController = data[@"remote"];
    
    self.topHConstraint.constant = 90*remotearr.count+40;
    NSTrackingAreaOptions options = NSTrackingInVisibleRect|NSTrackingMouseEnteredAndExited|NSTrackingActiveAlways;
    trackingArea = [[NSTrackingArea alloc] initWithRect:self.topView.bounds options:options owner:self userInfo:nil];
    [self.topView addTrackingArea:trackingArea];
    
    remoteArr[0] = (__bridge void *)(remotVideoController.videoView);
    
    [appDelegate.evengine setRemoteVideoWindow:remoteArr andSize:5];
    if (remotearr.count == 1) {
        for (int i = 0; i < remoteList.count; i++) {
            VideoController *remotVideo = remoteList[i];
            [remotVideo.view setFrame:CGRectMake(0, 0, 0, 0)];
        }
        self.buttomConstraint.constant = self.view.bounds.size.height-130;
    }else if (remotearr.count == 2) {
        for (int i = 0; i < remoteList.count; i++) {
            VideoController *remotVideo = remoteList[i];
            if (i == 0) {
                [remotVideo.view setFrame:CGRectMake(0, (3-i)*90+20, 160, 90)];
                EVSite *site = remotearr[i+1];
                remotVideo.userName.stringValue = site.name;
                self.buttomConstraint.constant = (3-i)*90;
            }else{
                [remotVideo.view setFrame:CGRectMake(0, 0, 0, 0)];
            }
        }
    }else if (remotearr.count == 3) {
        for (int i = 0; i < remoteList.count; i++) {
            VideoController *remotVideo = remoteList[i];
            if (i == 0 || i == 1) {
                [remotVideo.view setFrame:CGRectMake(0, (3-i)*90+20, 160, 90)];
                EVSite *site = remotearr[i+1];
                remotVideo.userName.stringValue = site.name;
                self.buttomConstraint.constant = (3-i)*90;
            }else{
                [remotVideo.view setFrame:CGRectMake(0, 270, 0, 0)];
            }
        }
    }else if (remotearr.count == 4) {
        for (int i = 0; i < remoteList.count; i++) {
            VideoController *remotVideo = remoteList[i];
            if (i == 0 || i == 1 || i == 2) {
                [remotVideo.view setFrame:CGRectMake(0, (3-i)*90+20, 160, 90)];
                EVSite *site = remotearr[i+1];
                remotVideo.userName.stringValue = site.name;
                self.buttomConstraint.constant = (3-i)*90;
            }else{
                [remotVideo.view setFrame:CGRectMake(0, 270, 0, 0)];
            }
        }
    }else if (remotearr.count == 5) {
        for (int i = 0; i < remoteList.count; i++) {
            VideoController *remotVideo = remoteList[i];
            [remotVideo.view setFrame:CGRectMake(0, (3-i)*90+20, 160, 90)];
            EVSite *site = remotearr[i+1];
            remotVideo.userName.stringValue = site.name;
            self.buttomConstraint.constant = (3-i)*90;
        }
        if (!ishiddenLocal && ishover) {
            self.buttomBg.hidden = NO;
        }
        self.upBtn.hidden = NO;
        isspeaker = YES;
    }
    
    if (ishiddenLocal) {
        for (int i = 0; i < remoteList.count; i++) {
            VideoController *remotVideo = remoteList[i];
            [remotVideo.view setFrame:CGRectMake(0, 0, 0, 0)];
        }
    }
}

- (void)reductionVideo
{
    layoutType = EVLayoutGalleryMode;
    isspeaker = NO;
    for (int i = 0; i < remoteList.count; i++) {
        VideoController *remotVideo = remoteList[i];
        [remotVideo.view setFrame:CGRectMake(0, 0, 0, 0)];
        remotVideo.userName.stringValue = @"";
        remotVideo.userBg.hidden = YES;
        self.buttomConstraint.constant = self.view.bounds.size.height-130;
    }
    self.topHConstraint.constant = 130;
    self.upBtn.hidden = NO;
    self.buttomBg.hidden = YES;
}

- (void)muteName:(NSNotification *)sender
{
    NSMutableArray *arr = sender.object;
    for (int i = 0; i < remoteList.count; i++) {
        VideoController *remotVideo = remoteList[i];
        remotVideo.muteBg.hidden = YES;
        remotVideo.nameConstraint.constant = 5;
        for (NSString *name in arr) {
            if ([remotVideo.userName.stringValue isEqualToString:name]) {
                if (ishover) {
                    remotVideo.muteBg.hidden = NO;
                }
                remotVideo.nameConstraint.constant = 20;
            }
        }
    }
}

- (void)localMute:(NSNotification *)sender
{
    if ([sender.object isEqualToString:@"mute"]) {
        localMute = YES;
        locaVideoController.muteBg.hidden = NO;
        locaVideoController.nameConstraint.constant = 20;
    }else {
        localMute = NO;
        locaVideoController.muteBg.hidden = YES;
        locaVideoController.nameConstraint.constant = 5;
    }
}

#pragma mark - Mouse
- (void)mouseEntered:(NSEvent *)theEvent
{
    ishover = YES;
    if (ishiddenLocal) {
        return;
    }
    if (layoutType == EVLayoutGalleryMode) {
        self.upBtn.hidden = YES;
        self.topBg.hidden = NO;
        self.buttomBg.hidden = YES;
    }else{
        self.topBg.hidden = NO;
        if (isspeaker) {
            self.buttomBg.hidden = NO;
        }
    }
//    locaVideoController.userBg.hidden = NO;
//    locaVideoController.userName.hidden = NO;
//    if (localMute) {
//        locaVideoController.muteBg.hidden = NO;
//        locaVideoController.nameConstraint.constant = 20;
//    }else {
//        locaVideoController.muteBg.hidden = YES;
//        locaVideoController.nameConstraint.constant = 5;
//    }
    for (int i = 0; i < remoteList.count; i++) {
        VideoController *remotVideo = remoteList[i];
        if (layoutType == EVLayoutGalleryMode) {
            remotVideo.userName.hidden = YES;
            remotVideo.userBg.hidden = YES;
        }else {
            remotVideo.userName.hidden = NO;
            remotVideo.userBg.hidden = NO;
        }
    }
}

- (void)mouseExited:(NSEvent *)theEvent
{
    ishover = NO;
    if (ishiddenLocal) {
        return;
    }
    self.topBg.hidden = YES;
    self.buttomBg.hidden = YES;
    for (int i = 0; i < remoteList.count; i++) {
        VideoController *remotVideo = remoteList[i];
        remotVideo.userName.hidden = YES;
        remotVideo.muteBg.hidden = YES;
        remotVideo.userBg.hidden = YES;
    }
//    locaVideoController.userBg.hidden = YES;
//    locaVideoController.userName.hidden = YES;
}

- (void)mouseDown:(NSEvent *)event
{
    
    if (event.pressure == 1 && event.clickCount == 2) {
        // Double click happened 
        //判断点击的是某一个window
        if (110>event.locationInWindow.y && event.locationInWindow.y>20) {
            //4
            EVLayoutRequest *layout = [[EVLayoutRequest alloc] init];
            layout.page = EVLayoutCurrentPage;
            layout.mode = EVLayoutSpeakerMode;
            layout.max_type = EVLayoutType_5_4T_1B;
            EVVideoSize vsize;
            vsize.width = 0;
            vsize.height = 0;
            layout.max_resolution = vsize;
            remotVideoController = remoteList[3];
            NSArray *window = @[remotVideoController.videoView];
            layout.windows = window;
            [appDelegate.evengine setLayout:layout];
            [[NSNotificationCenter defaultCenter] postNotificationName:CHOOSEVIDEO object:remotVideoController.userName.stringValue];
        }else if (200>event.locationInWindow.y && event.locationInWindow.y>110) {
            //3
            EVLayoutRequest *layout = [[EVLayoutRequest alloc] init];
            layout.page = EVLayoutCurrentPage;
            layout.mode = EVLayoutSpeakerMode;
            layout.max_type = EVLayoutType_5_4T_1B;
            EVVideoSize vsize;
            vsize.width = 0;
            vsize.height = 0;
            layout.max_resolution = vsize;
            remotVideoController = remoteList[2];
            NSArray *window = @[remotVideoController.videoView];
            layout.windows = window;
            [appDelegate.evengine setLayout:layout];
            [[NSNotificationCenter defaultCenter] postNotificationName:CHOOSEVIDEO object:remotVideoController.userName.stringValue];
        }else if (290>event.locationInWindow.y && event.locationInWindow.y>200) {
            //2
            EVLayoutRequest *layout = [[EVLayoutRequest alloc] init];
            layout.page = EVLayoutCurrentPage;
            layout.mode = EVLayoutSpeakerMode;
            layout.max_type = EVLayoutType_5_4T_1B;
            EVVideoSize vsize;
            vsize.width = 0;
            vsize.height = 0;
            layout.max_resolution = vsize;
            remotVideoController = remoteList[1];
            NSArray *window = @[remotVideoController.videoView];
            layout.windows = window;
            [appDelegate.evengine setLayout:layout];
            [[NSNotificationCenter defaultCenter] postNotificationName:CHOOSEVIDEO object:remotVideoController.userName.stringValue];
        }else if (380>event.locationInWindow.y && event.locationInWindow.y>290) {
            //1
            EVLayoutRequest *layout = [[EVLayoutRequest alloc] init];
            layout.page = EVLayoutCurrentPage;
            layout.mode = EVLayoutSpeakerMode;
            layout.max_type = EVLayoutType_5_4T_1B;
            EVVideoSize vsize;
            vsize.width = 0;
            vsize.height = 0;
            layout.max_resolution = vsize;
            remotVideoController = remoteList[0];
            NSArray *window = @[remotVideoController.videoView];
            layout.windows = window;
            [appDelegate.evengine setLayout:layout];
            [[NSNotificationCenter defaultCenter] postNotificationName:CHOOSEVIDEO object:remotVideoController.userName.stringValue];
        }
    }
}

#pragma mark - ButtonMethod
- (IBAction)hiddenLocalAction:(id)sender
{
    Notifications(HIDDENLOCAL);
    DDLogInfo(@"[Info] 10031 User Hidden Local Windwo");
    ishiddenLocal = YES;
    self.topBg.hidden = YES;
    self.buttomBg.hidden = YES;
    locaVideoController.view.hidden = YES;
    for (int i = 0; i < remoteList.count; i++) {
        VideoController *remotVideo = remoteList[i];
        [remotVideo.view setFrame:CGRectMake(0, 0, 0, 0)];
        remotVideo.userName.hidden = YES;
        remotVideo.userBg.hidden = YES;
    }
}

- (void)hiddenLocal
{
    Notifications(HIDDENLOCAL);
    DDLogInfo(@"[Info] 10031 User Hidden Local Windwo");
    ishiddenLocal = YES;
    self.topBg.hidden = YES;
    self.buttomBg.hidden = YES;
    locaVideoController.view.hidden = YES;
    for (int i = 0; i < remoteList.count; i++) {
        VideoController *remotVideo = remoteList[i];
        [remotVideo.view setFrame:CGRectMake(0, 0, 0, 0)];
        remotVideo.userName.hidden = YES;
        remotVideo.userBg.hidden = YES;
    }
}

- (IBAction)prevPageAction:(id)sender
{
    EVLayoutRequest *layout = [[EVLayoutRequest alloc] init];
    layout.page = EVLayoutPrevPage;
    layout.max_type = EVLayoutType_5_4T_1B;
    layout.mode = EVLayoutSpeakerMode;
    EVVideoSize vsize;
    vsize.width = 0;
    vsize.height = 0;
    layout.max_resolution = vsize;
    [appDelegate.evengine setLayout:layout];
}

- (IBAction)nextPageAction:(id)sender
{
    EVLayoutRequest *layout = [[EVLayoutRequest alloc] init];
    layout.page = EVLayoutNextPage;
    layout.max_type = EVLayoutType_5_4T_1B;
    layout.mode = EVLayoutSpeakerMode;
    EVVideoSize vsize;
    vsize.width = 0;
    vsize.height = 0;
    layout.max_resolution = vsize;
    [appDelegate.evengine setLayout:layout];
}

#pragma mark - Notification
- (void)closeWindow
{
    [self.view.window close];
}

- (void)showWindow
{
    DDLogInfo(@"[Info] 10034 Receive user magnification requests");
    
    ishiddenLocal = NO;
    self.topBg.hidden = NO;
    if (isspeaker) {
        if (!ishiddenLocal && ishover) {
            self.buttomBg.hidden = NO;
        }
    }
    locaVideoController.view.hidden = NO;
    if (remotearr.count == 1) {
        for (int i = 0; i < remoteList.count; i++) {
            VideoController *remotVideo = remoteList[i];
            [remotVideo.view setFrame:CGRectMake(0, 270, 0, 0)];
            remotVideo.userName.hidden = YES;
            remotVideo.userBg.hidden = YES;
        }
    }else if (remotearr.count == 2) {
        for (int i = 0; i < remoteList.count; i++) {
            VideoController *remotVideo = remoteList[i];
            if (i == 0) {
                [remotVideo.view setFrame:CGRectMake(0, (3-i)*90+20, 160, 90)];
                if (layoutType == EVLayoutGalleryMode) {
                    remotVideo.userName.hidden = YES;
                    remotVideo.userBg.hidden = YES;
                }else {
                    remotVideo.userName.hidden = NO;
                    remotVideo.userBg.hidden = NO;
                }
            }else{
                [remotVideo.view setFrame:CGRectMake(0, 270, 0, 0)];
                remotVideo.userName.hidden = YES;
                remotVideo.userBg.hidden = YES;
            }
        }
    }else if (remotearr.count == 3) {
        for (int i = 0; i < remoteList.count; i++) {
            VideoController *remotVideo = remoteList[i];
            if (i == 0 || i == 1) {
                [remotVideo.view setFrame:CGRectMake(0, (3-i)*90+20, 160, 90)];
                if (layoutType == EVLayoutGalleryMode) {
                    remotVideo.userName.hidden = YES;
                    remotVideo.userBg.hidden = YES;
                }else {
                    remotVideo.userName.hidden = NO;
                    remotVideo.userBg.hidden = NO;
                }
            }else{
                [remotVideo.view setFrame:CGRectMake(0, 270, 0, 0)];
                remotVideo.userName.hidden = YES;
                remotVideo.userBg.hidden = YES;
            }
        }
    }else if (remotearr.count == 4) {
        for (int i = 0; i < remoteList.count; i++) {
            VideoController *remotVideo = remoteList[i];
            if (i == 0 || i == 1 || i == 2) {
                [remotVideo.view setFrame:CGRectMake(0, (3-i)*90+20, 160, 90)];
                if (layoutType == EVLayoutGalleryMode) {
                    remotVideo.userName.hidden = YES;
                    remotVideo.userBg.hidden = YES;
                }else {
                    remotVideo.userName.hidden = NO;
                    remotVideo.userBg.hidden = NO;
                }
            }else{
                [remotVideo.view setFrame:CGRectMake(0, 270, 0, 0)];
                remotVideo.userName.hidden = YES;
                remotVideo.userBg.hidden = YES;
            }
        }
    }else if (remotearr.count == 5) {
        for (int i = 0; i < remoteList.count; i++) {
            VideoController *remotVideo = remoteList[i];
            [remotVideo.view setFrame:CGRectMake(0, (3-i)*90+20, 160, 90)];
            if (layoutType == EVLayoutGalleryMode) {
                remotVideo.userName.hidden = YES;
                remotVideo.userBg.hidden = YES;
            }else {
                remotVideo.userName.hidden = NO;
                remotVideo.userBg.hidden = NO;
            }
        }
    }
}

@end
