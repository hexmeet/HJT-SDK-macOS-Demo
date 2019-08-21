//
//  ScreenViewController.m
//  easyVideo-avc
//
//  Created by quanhao huang on 2019/4/9.
//  Copyright © 2019 EVSDK. All rights reserved.
//

#import "ScreenViewController.h"
#import "ScreenView.h"
#import "macHUD.h"

@interface ScreenViewController ()
{
    NSMutableArray *imageArr;
    AppDelegate *appDelegate;
    macHUD *hub;
}
@end

@implementation ScreenViewController

@synthesize scrollView, sureBtn, chooseTitle, scrollViewConstraint;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    imageArr = [NSMutableArray arrayWithCapacity:1];
    
    hub = [macHUD creatMacHUD:@"" icon:@"" viewController:self];
    hub.hidden = YES;
    
    [self setRootViewAttribute];
    
}

- (NSMutableArray *)getscreenCapture
{
    NSMutableArray *datas = [NSMutableArray array];
    //存储所有显示器显示id
    CGDirectDisplayID dspyIDArray[10];
    uint32_t dspyIDCount = 0;
    //获取当前活跃的所有显示器id及其个数
    if (CGGetActiveDisplayList(10, dspyIDArray, &dspyIDCount) != kCGErrorSuccess)
        return nil;
    CFStringRef dspyDestType = CFSTR("public.png");
    for(uint32_t i = 0; i < dspyIDCount; i++) {
        CGDirectDisplayID mainID = dspyIDArray[i];
        // 根据Quartz分配给显示器的id，生成显示器mainID的截图
        CGImageRef mainCGImage = CGDisplayCreateImage(mainID);
        CFMutableDataRef mainMutData = CFDataCreateMutable(NULL, 0);
        CGImageDestinationRef mainDest = CGImageDestinationCreateWithData(mainMutData, dspyDestType, 1, NULL);
        CGImageDestinationAddImage(mainDest, mainCGImage, NULL);
        CGImageRelease(mainCGImage);
        CGImageDestinationFinalize(mainDest);
        CFRelease(mainDest);
        [datas addObject:(__bridge NSData *)mainMutData];
        CFRelease(mainMutData);
    }
    CFRelease(dspyDestType);
    NSInteger imageCount = [datas count];
    if (imageCount <= 0) {
        return nil;
    }
    return datas;
}


- (void)setRootViewAttribute
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeWindow) name:CLOSESCREENWINDOW object:nil];
    
    [sureBtn changeCenterButtonattribute:localizationBundle(@"button.sure") color:WHITECOLOR];
    chooseTitle.stringValue = localizationBundle(@"video.sharescreen");
    
    NSArray *screenArr = [NSScreen screens];
    NSMutableArray *screenImage = [self getscreenCapture];
    
    if (screenArr.count == 1) {
        ScreenView *screen = [self creatScreenView];
        screen.frame = CGRectMake(190, 0, 190, 262);
        scrollViewConstraint.constant = 190;
        screen.chooseBtn.tag = 0;
        [screen.chooseBtn setAction:@selector(chooseScreen:)];
        NSImage *tmpImage = [[NSImage alloc] initWithData:screenImage[0]];
        screen.screenImage.image = tmpImage;
        screen.screenName.stringValue = [NSString stringWithFormat:@"%@ %@", localizationBundle(@"video.screenimage"), @"1"];
        [scrollView.contentView addSubview:screen];
        [imageArr addObject:screen];
    }else if (screenArr.count == 2) {
        for (int i = 0; i<screenArr.count; i++) {
            ScreenView *screen = [self creatScreenView];
            screen.frame = CGRectMake(190*i+95, 0, 190, 262);
            scrollViewConstraint.constant = 190*i;
            screen.chooseBtn.tag = i;
            [screen.chooseBtn setAction:@selector(chooseScreen:)];
            NSImage *tmpImage = [[NSImage alloc] initWithData:screenImage[i]];
            screen.screenImage.image = tmpImage;
            screen.screenName.stringValue = [NSString stringWithFormat:@"%@ %d", localizationBundle(@"video.screenimage"), i+1];
            [scrollView.contentView addSubview:screen];
            [imageArr addObject:screen];
        }
    }else {
        for (int i = 0; i<screenArr.count; i++) {
            ScreenView *screen = [self creatScreenView];
            screen.frame = CGRectMake(190*i, 0, 190, 262);
            scrollViewConstraint.constant = 190*i;
            screen.chooseBtn.tag = i;
            [screen.chooseBtn setAction:@selector(chooseScreen:)];
            NSImage *tmpImage = [[NSImage alloc] initWithData:screenImage[i]];
            screen.screenImage.image = tmpImage;
            screen.screenName.stringValue = [NSString stringWithFormat:@"%@ %d", localizationBundle(@"video.screenimage"), i+1];
            [scrollView.contentView addSubview:screen];
            [imageArr addObject:screen];
        }
    }
}

- (ScreenView *)creatScreenView
{
    NSBundle*            aBundle = [NSBundle mainBundle];
    NSMutableArray*      topLevelObjs = [NSMutableArray array];
    NSDictionary*        nameTable = [NSDictionary dictionaryWithObjectsAndKeys:
                                      self, NSNibOwner,
                                      topLevelObjs, NSNibTopLevelObjects,
                                      nil];
    
    if (![aBundle loadNibFile:@"ScreenView" externalNameTable:nameTable withZone:nil])
    {
        
    }
    
    ScreenView *myView = nil;
    
    for (id classtpye in topLevelObjs) {
        if ([classtpye isKindOfClass:[ScreenView class]]) {
            myView = classtpye;
        }
    }
    
    return myView;
}

#pragma mark - ButtonMethod
- (void)chooseScreen:(NSButton *)sender
{
    ScreenView *view = imageArr[sender.tag];
    view.screenImage.wantsLayer = YES;
    view.screenImage.layer.borderWidth = 2;
    view.screenImage.layer.borderColor = BLUECOLOR.CGColor;
    
    NSScreen *screens = [[NSScreen screens] objectAtIndex:sender.tag];
    NSLog(@"%@", screens.deviceDescription[@"NSScreenNumber"]);
    
    //屏幕共享相关
    [[NSNotificationCenter defaultCenter] postNotificationName:SENDCONTENT object:screens.deviceDescription[@"NSScreenNumber"]];
    
    [self.view.window close];
}

#pragma mark - HUDHIDDEN
- (void)persendMethod:(NSInteger)time
{
    [self performSelector:@selector(hiddenHUD) withObject:self afterDelay:time];
}

- (void)hiddenHUD
{
    hub.hidden = YES;
    [self.view.window close];
}

#pragma mark - ButtonMethod
- (IBAction)sureAction:(id)sender
{
    
}
- (IBAction)closeTheWindow:(id)sender
{
    [self.view.window close];
}

#pragma mark - Notification
- (void)closeWindow
{
    [self.view.window close];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CLOSESCREENWINDOW object:nil];
}

@end
