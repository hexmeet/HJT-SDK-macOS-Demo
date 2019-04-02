//
//  CheckVersionViewController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/11/14.
//  Copyright © 2018 easyVideo. All rights reserved.
//

#import "CheckVersionViewController.h"

typedef enum _DownloadState {
    DdStateFD  = 0,//发现更新
    DdStateST,//开始更新
    DdStateFN,//更新结束
    DdStateFL//下载失败
} DownloadState;

@interface CheckVersionViewController ()<NSURLSessionDataDelegate, NSStreamDelegate>
{
    NSString *downloadUrl;
    NSString *filePath;//更新文件路径
}
@property (nonatomic, assign) float totalFileSize;//文件总大小
@property (nonatomic, assign) float tmpFileSize;//当前下载大小
@property (nonatomic, assign) float progressView;//当前进度
@property (nonatomic,assign) DownloadState state;//操作类型
/** 输出流 */
@property (nonatomic,strong) NSOutputStream *outputStream;

@end

@implementation CheckVersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self.view setBackgroundColor:WHITECOLOR];
    [self.topView setBackgroundColor:DEFAULTBGCOLOR];
    [self.bottomView setBackgroundColor:DEFAULTBGCOLOR];
    
    self.appIcon.image = [NSImage imageNamed:@"hjt_logo21024.png"];
    
    [self.leftBtn setBackgroundColor:WHITECOLOR];
    self.leftBtn.layer.cornerRadius = 4;
    [self.rightBtn setBackgroundColor:BLUECOLOR];
    self.rightBtn.layer.cornerRadius = 4;
    [self.leftBtn changeCenterButtonattribute:localizationBundle(@"alert.cancel") color:BLACKCOLOR];
    [self.rightBtn changeCenterButtonattribute:localizationBundle(@"alert.update") color:WHITECOLOR];
    self.topTitle.stringValue = localizationBundle(@"alert.software.update");
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadUrl:) name:DOWNLOADURL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage:) name:CHANGELANGUAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dontneedupload) name:DONTNEEDUPLODE object:nil];
    
}

- (void)viewDidDisappear
{
    [super viewDidDisappear];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DOWNLOADURL object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CHANGELANGUAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DONTNEEDUPLODE object:nil];
}

#pragma mark - ButtonMethod
- (IBAction)buttonMethod:(id)sender
{
    if (sender == self.leftBtn) {
        switch (self.state) {
            case DdStateFD:
                [self.view.window close];
                break;
            case DdStateST:
                
                break;
            case DdStateFN:
                [self.outputStream close];
                self.outputStream = nil;
                [self.view.window close];
                break;
                
            default:
                break;
        }
    }else if (sender == self.rightBtn) {
        switch (self.state) {
            case DdStateFD:
                //stat download file
                [self begindownload];
                break;
            case DdStateST:
                [self.outputStream close];
                self.outputStream = nil;
                [self.view.window close];
                break;
            case DdStateFN:
                [self openDownloadfile];
                break;
            case DdStateFL:
                [self.outputStream close];
                self.outputStream = nil;
                [self.view.window close];
            default:
                break;
        }
    }
}

#pragma mark - NSNotification
- (void)downloadUrl:(NSNotification *)sender
{
    //get download url
    NSDictionary *versionDic = sender.object;
    downloadUrl = versionDic[@"DOWNLOAD_URL"];
    self.versionTitle.stringValue = [NSString stringWithFormat:@"%@(%@)", localizationBundle(@"alert.foundnewversion"), versionDic[@"VERSION"]];
    self.state = DdStateFD;
}

- (void)changeLanguage:(NSNotification *)sender
{
    [self.leftBtn changeCenterButtonattribute:localizationBundle(@"alert.cancel") color:BLACKCOLOR];
    [self.rightBtn changeCenterButtonattribute:localizationBundle(@"alert.update") color:WHITECOLOR];
    self.topTitle.stringValue = localizationBundle(@"alert.software.update");
    self.versionTitle.stringValue = [NSString stringWithFormat:@"%@(%@)", localizationBundle(@"alert.dontneedupload"), [EVUtils getLocalAppVersion]];
}

- (void)dontneedupload
{
    self.leftBtn.hidden = YES;
    self.rightBtn.hidden = YES;
    self.versionTitle.stringValue = [NSString stringWithFormat:@"%@(%@)", localizationBundle(@"alert.dontneedupload"), [EVUtils getLocalAppVersion]];
}

/** user click download btn */
- (void)begindownload
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:downloadUrl]];
    [request setValue:[NSString stringWithFormat:@"bytes=%@-", NSFileSize] forHTTPHeaderField:@"Range"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    [dataTask resume];
}

/** user click open file btn */
- (void)openDownloadfile
{
    // 检查当前路径下是否含有某文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        DDLogInfo(@"[Info] 打开更新文件 文件路径为:%@", filePath);
        [[NSWorkspace sharedWorkspace] openFile:filePath];
    }
    else {
        DDLogWarn(@"[Warn] 更新文件不存在");
    }
}

#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    NSHTTPURLResponse * HTTPresponses = (NSHTTPURLResponse *)dataTask.response;
    // 更新文件的总大小
    self.totalFileSize = response.expectedContentLength + self.tmpFileSize;
    if (HTTPresponses.statusCode == 200)
    {
        //变为开始下载状态
        self.state = DdStateST;
        self.versionTitle.hidden = YES;
        self.downloadTitle.hidden = NO;
        self.downloadTitle.stringValue = localizationBundle(@"alert.installing");
        self.progressIndicatorBg.hidden = NO;
        self.downloadProgressFd.hidden = NO;
        self.leftBtn.hidden = YES;
        [self.rightBtn changeCenterButtonattribute:localizationBundle(@"alert.cancel") color:BLACKCOLOR];
        [self.rightBtn setBackgroundColor:WHITECOLOR];
        
        completionHandler(NSURLSessionResponseAllow);
        
        // 创建输出流
        self.outputStream = [[NSOutputStream alloc] initToFileAtPath:[[EVUtils get_download_app_path] stringByAppendingString:[NSString stringWithFormat:@"/%@",response.suggestedFilename]] append:NO];
        filePath = [[EVUtils get_download_app_path] stringByAppendingString:[NSString stringWithFormat:@"/%@",response.suggestedFilename]];
        [self.outputStream open];
    }else {
        //变为下载失败状态
        self.state = DdStateFL;
        self.leftBtn.hidden = YES;
        self.rightBtn.hidden = NO;
        [self.rightBtn changeCenterButtonattribute:localizationBundle(@"alert.yes") color:WHITECOLOR];
        [self.rightBtn setBackgroundColor:BLUECOLOR];
        self.downloadTitle.hidden = YES;
        self.versionTitle.hidden = NO;
        self.progressIndicatorBg.hidden = YES;
        self.downloadProgressFd.hidden = YES;
        self.versionTitle.stringValue = localizationBundle(@"alert.downloadfailed");
    }
    
}

// 接收到服务器返回数据
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    // 写入数据
    [self.outputStream write:data.bytes maxLength:data.length];
    
    // 当前下载大小
    self.tmpFileSize += data.length;
    
    self.downloadProgressFd.stringValue = [NSString stringWithFormat:@"%.2fMB/%.2fMB", self.tmpFileSize/1024.f/1024.f, self.totalFileSize/1024.f/1024.f];
    
    self.progressIndicatorBg.doubleValue = self.tmpFileSize/self.totalFileSize*100;
    
    // 进度
    self.progressView = 1.0 * self.tmpFileSize / self.totalFileSize;
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    //变为开始下载完成
    self.state = DdStateFN;
    self.downloadTitle.stringValue = localizationBundle(@"alert.sureinstallation");
    self.leftBtn.hidden = NO;
    [self.leftBtn setBackgroundColor:WHITECOLOR];
    [self.rightBtn setBackgroundColor:BLUECOLOR];
    [self.leftBtn changeCenterButtonattribute:localizationBundle(@"alert.no") color:BLACKCOLOR];
    [self.rightBtn changeCenterButtonattribute:localizationBundle(@"alert.yes") color:WHITECOLOR];
    
    [self.outputStream close];
    self.outputStream = nil;
}

#pragma mark - ButtonMethod
- (IBAction)hiddenWindow:(id)sender
{
    [self.outputStream close];
    self.outputStream = nil;
    [self.view.window close];
}

@end
