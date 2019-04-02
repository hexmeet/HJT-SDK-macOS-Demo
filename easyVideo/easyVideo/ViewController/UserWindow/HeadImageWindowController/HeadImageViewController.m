//
//  HeadImageViewController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/8/29.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "HeadImageViewController.h"
#import "macHUD.h"

@interface HeadImageViewController ()<EVEngineDelegate>
{
    CGRect t;
    CGPoint _sourcePoint;
    BOOL iscanMove;
    AppDelegate *appDelegate;
    macHUD *hub;
}
@end

@implementation HeadImageViewController

@synthesize topViewBg, editHeadTitle, headImageView, imageBg, imagePromptTitle, openBg, openBtn, updataBg, updataBtn, smallerBtn, biggerBtn, sliderBg, sliderConstraint, sliderValue, slidervalueBg;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self setRootViewAttribute];
    
    [self languageLocalization];
}

- (void)setRootViewAttribute
{
    appDelegate = APPDELEGATE;
    
    [appDelegate.evengine setDelegate:self];
    
    hub = [macHUD creatMacHUD:@"" icon:@"" viewController:self];
    hub.hidden = YES;
    
    [self.view setBackgroundColor:WHITECOLOR];
    [openBg setBackgroundColor:BLUECOLOR];
    [updataBg setBackgroundColor:BLUECOLOR];
    [topViewBg setBackgroundColor:DEFAULTBGCOLOR];
    [imagePromptTitle setBackgroundColor:CLEARCOLOR];
    [editHeadTitle setBackgroundColor:CLEARCOLOR];
    [updataBtn setBackgroundColor:BLUECOLOR];
    [imageBg setBackgroundColor:DEFAULTBGCOLOR];
    [headImageView setBackgroundColor:CLEARCOLOR];
    
    imageBg.layer.borderWidth = 1.;
    imageBg.layer.borderColor = BORDERCOLOR.CGColor;
    
    openBg.layer.cornerRadius = 4;
    updataBg.layer.cornerRadius = 4;
    
    [sliderBg setBackgroundColor:HEXCOLOR(0xd4d1d3)];
    sliderBg.layer.cornerRadius = 2;
    
    sliderValue = 0;
    sliderConstraint.constant = 4;
    
    t = CGRectMake(0, 0, 200, 200);
    
    iscanMove = NO;
    
    NSTrackingArea *area = [[NSTrackingArea alloc] initWithRect:imageBg.bounds options:NSTrackingMouseEnteredAndExited|NSTrackingActiveInKeyWindow|NSTrackingEnabledDuringMouseDrag|NSTrackingActiveWhenFirstResponder owner:self userInfo:nil];
    
    [imageBg addTrackingArea:area];
}

- (void)languageLocalization
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage:) name:CHANGELANGUAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeHeadImageWindow) name:CLOSEHEADIMAGEWINDOW object:nil];
    
    [LanguageTool initUserLanguage];
    
    [openBtn changeCenterButtonattribute:localizationBundle(@"home.user.head.open") color:WHITECOLOR];
    [updataBtn changeCenterButtonattribute:localizationBundle(@"home.user.head.updata") color:WHITECOLOR];
    editHeadTitle.stringValue = localizationBundle(@"home.user.head.edithead");
    imagePromptTitle.stringValue = localizationBundle(@"home.user.head.alert");
}

#pragma mark - MOUSE
- (void)mouseUp:(NSEvent *)theEvent
{
    _sourcePoint = CGPointMake(0, 0);
}

- (void)mouseDragged:(NSEvent *)event
{
    NSLog(@"locationInWindow x = %fsadasd y = %f",event.locationInWindow.x, event.locationInWindow.y);
    CGPoint p = CGPointMake(event.locationInWindow.x, event.locationInWindow.y);
    
    NSLog(@"%g  %g",p.x,p.y);
    
    if (_sourcePoint.x==0 && _sourcePoint.y==0) {
        _sourcePoint=p;
    }
    else
    {
        CGRect r = headImageView.frame;
        
        headImageView.frame = CGRectMake(r.origin.x+(p.x-_sourcePoint.x), r.origin.y+(p.y-_sourcePoint.y), r.size.width, r.size.height);
        _sourcePoint=p;
    }
}

#pragma mark - NSButtonMethod
- (IBAction)closeWindow:(id)sender
{
    [self.view.window close];
}

- (IBAction)buttonMethod:(id)sender
{
    if (sender == openBtn) {
        hub.hidden = NO;
        hub.hudTitleFd.stringValue = localizationBundle(@"alert.connection");
        NSOpenPanel *panel = [NSOpenPanel openPanel];
        [panel setAllowsMultipleSelection:NO];
        [panel setCanChooseDirectories:YES];
        [panel setCanChooseFiles:YES];
        [panel setAllowedFileTypes:@[@"png", @"jpeg", @"jpg"]];
        [panel setAllowsOtherFileTypes:YES];
        [panel beginWithCompletionHandler:^(NSInteger result) {
            self->hub.hidden = YES;
            if (result == NSModalResponseOK) {
                NSString *path = [panel.URLs.firstObject path];
                self->iscanMove = YES;
                self->headImageView.image = [[NSImage alloc] initWithContentsOfFile:path];
                self->headImageView.frame = CGRectMake(0, 0, 200, 200);
                self->headImageView.image = [EVUtils resizeImage:self->headImageView.image size:self->headImageView.frame.size];
            }
        }];

    }else if (sender == updataBtn) {
        if (!iscanMove) {
            return;
        }
        smallerBtn.hidden = YES;
        biggerBtn.hidden  = YES;
        sliderBg.hidden   = YES;
        slidervalueBg.hidden = YES;
        [imageBg lockFocus];
        NSImage *image = [[NSImage alloc] initWithData:[imageBg dataWithPDFInsideRect:CGRectMake(0, 0, 200, 200)]];
        [imageBg unlockFocus];
        [image lockFocus];
        NSBitmapImageRep *bits = [[NSBitmapImageRep alloc]initWithFocusedViewRect:CGRectMake(0, 0, 200, 200)];
        [image unlockFocus];
        NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:0] forKey:NSImageCompressionFactor];
        NSString *downloadimagepath = [[EVUtils get_current_app_path]stringByAppendingPathComponent:@"header.jpg"];
        NSData *imageData = [bits representationUsingType:NSPNGFileType properties:imageProps];
        [imageData writeToFile:[[[NSString alloc] initWithFormat:@"%@", downloadimagepath] stringByExpandingTildeInPath]atomically:YES];
        smallerBtn.hidden = NO;
        biggerBtn.hidden  = NO;
        sliderBg.hidden   = NO;
        slidervalueBg.hidden = NO;
        float imageSize = [self getFileSize:downloadimagepath];
        if (imageSize<1) {
            [appDelegate.evengine uploadUserImage:downloadimagepath];
        }else{
            //need compression
            NSString *inPath = downloadimagepath;
            NSString *outPath = downloadimagepath;
            float compress =  0.1;
            NSImage *simg = [[NSImage alloc]initWithContentsOfFile:inPath];
            NSData *imgDt = [simg TIFFRepresentation];
            NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imgDt];
            NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:compress] forKey:NSImageCompressionFactor];
            imgDt = [imageRep representationUsingType:NSJPEGFileType properties:imageProps];
            int ret = [imgDt writeToFile:outPath atomically:YES];
            if (ret>0) {
            }else
            {
            }
            [appDelegate.evengine uploadUserImage:downloadimagepath];
        }
        hub.hidden = NO;
        hub.hudTitleFd.stringValue = localizationBundle(@"alert.connection");
        [self persendMethod:60];
    }else if (sender == smallerBtn) {
        if (iscanMove) {
            if (sliderValue > 0) {
                sliderValue--;
                sliderConstraint.constant = 4+sliderValue*7;
                headImageView.frame = CGRectMake(-t.size.width*sliderValue/10/2, -t.size.height*sliderValue/10/2, t.size.width*sliderValue/10+t.size.width, t.size.height*sliderValue/10+t.size.width);
                headImageView.image = [EVUtils resizeImage:headImageView.image size:headImageView.frame.size];
            }
        }
    }else if (sender == biggerBtn) {
        if (iscanMove) {
            if (sliderValue < 10) {
                sliderValue++;
                sliderConstraint.constant = 4+sliderValue*7;
                headImageView.frame = CGRectMake(-t.size.width*sliderValue/10/2, -t.size.height*sliderValue/10/2, t.size.width*sliderValue/10+t.size.width, t.size.height*sliderValue/10+t.size.width);
                headImageView.image = [EVUtils resizeImage:headImageView.image size:headImageView.frame.size];
            }
        }
    }
}

#pragma mark - Notification
- (void)changeLanguage:(NSNotification *)sender
{
    [openBtn changeCenterButtonattribute:localizationBundle(@"home.user.head.open") color:WHITECOLOR];
    [updataBtn changeCenterButtonattribute:localizationBundle(@"home.user.head.updata") color:WHITECOLOR];
    editHeadTitle.stringValue = localizationBundle(@"home.user.head.edithead");
    imagePromptTitle.stringValue = localizationBundle(@"home.user.head.alert");
}

- (void)closeHeadImageWindow
{
    [self.view.window close];
}

#pragma mark - Delegate
- (void)onUploadUserImageComplete:(NSString *_Nonnull)path
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self->hub.hidden = NO;
        self->hub.hudTitleFd.stringValue = localizationBundle(@"alert.uploaded.successfully");
        [self persendMethod:2];
        Notifications(UPLOADIMAGE);
    });
}

#pragma mark - HIDDENHUD
- (void)persendMethod:(NSInteger)time
{
    [self performSelector:@selector(hiddenHUD) withObject:self afterDelay:time];
}

- (void)hiddenHUD
{
    hub.hidden = YES;
    Notifications(CLOSEUSERWINDOW);
    [self.view.window close];
}

- (float)getFileSize:(NSString *)url{
    NSFileManager *file = [NSFileManager defaultManager];
    NSDictionary *dict = [file attributesOfItemAtPath:url error:nil];
    unsigned long long size = [dict fileSize];
    return (NSInteger)size/(1024.0*1024.0);
}

@end
