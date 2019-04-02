//
//  aboutViewController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/8/24.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "aboutViewController.h"

@interface aboutViewController ()<NSURLSessionDataDelegate>
{
    AppDelegate *appDelegate;
}
@property (nonatomic, strong) NSMutableData *responseData;

@end

@implementation aboutViewController

- (NSMutableData *)responseData
{
    if (_responseData == nil) {
        _responseData = [NSMutableData data];
    }
    return _responseData;
}

@synthesize aboutImageBg, appName, cRightTtitle, version;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self languageLocalization];
    
    appDelegate = APPDELEGATE;
    
    [self.checkBtn setBackgroundColor:BLUECOLOR];
    self.checkBtn.layer.cornerRadius = 4;
    aboutImageBg.image = [NSImage imageNamed:@"hjt_logo21024.png"];
}

/**
 Language localization
 */
- (void)languageLocalization
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage:) name:CHANGELANGUAGE object:nil];

    [LanguageTool initUserLanguage];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = infoDictionary[@"CFBundleVersion"];
    
    cRightTtitle.stringValue = infoPlistStringBundle(@"NSHumanReadableCopyright");
    version.stringValue = [NSString stringWithFormat:@"%@%@", localizationBundle(@"home.set.about.version"), app_Version];
    appName.stringValue = localizationBundle(@"APPNAME");
    [self.checkBtn changeCenterButtonattribute:localizationBundle(@"alert.checkversion") color:WHITECOLOR];
}

#pragma mark - ButtonMethod
- (IBAction)buttonMethod:(id)sender
{
    if (sender == self.checkBtn) {
        //清空保存的数据
        [self.responseData resetBytesInRange:NSMakeRange(0, self.responseData.length)];
        [self.responseData setLength:0];
        [self checkVersion];
    }
}

/** check app version */
- (void)checkVersion
{
    NSDictionary *infoDic = [PlistUtils loadUserInfoPlistFilewithFileName:SETINFO];
    NSString *appinfo;
    if (infoDic) {
        if (infoDic[@"appinfo"]) {
            appinfo = infoDic[@"appinfo"];
        }else {
            appinfo = infoPlistStringBundle(@"APPINFO.NAME");
        }
    }else {
        appinfo = infoPlistStringBundle(@"APPINFO.NAME");
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%@", infoPlistStringBundle(@"APPINFO.JSON"), [EVUtils getBundleID], appinfo];
    DDLogInfo(@"[Info] 10053 check version json Url:%@", urlStr);
#if DEBUG
    urlStr = @"http://swinfo.cninnovatel.com/macos/com.hexmeet.machjt/appinfo.json";
#endif
    //给一个随机数防止取相同地址
    int random = arc4random() % 1000;
    urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"?v=%d", random]];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    
    [dataTask resume];
}

#pragma mark - NSURLSessionDataDelegate
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    //在该方法中可以得到响应头信息，即response
    NSLog(@"didReceiveResponse--%@",[NSThread currentThread]);
    
    //注意：需要使用completionHandler回调告诉系统应该如何处理服务器返回的数据
    //默认是取消的
    
    completionHandler(NSURLSessionResponseAllow);
}

//2.接收到服务器返回数据的时候会调用该方法，如果数据较大那么该方法可能会调用多次
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    NSLog(@"didReceiveData--%@",[NSThread currentThread]);
    //拼接服务器返回的数据
    [self.responseData appendData:data];
}

//3.当请求完成(成功|失败)的时候会调用该方法，如果请求失败，则error有值
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"didCompleteWithError--%@",[NSThread currentThread]);
    if(error == nil)
    {
        //解析数据
        NSDictionary *appVersiondict = [NSJSONSerialization JSONObjectWithData:self.responseData options:kNilOptions error:nil];
        DDLogInfo(@"[Info] 10049 check Version info:%@", appVersiondict[@"VERSION"]);
        
        //版本比较
        if ([EVUtils compareVersion:appVersiondict[@"VERSION"] to:[EVUtils getLocalAppVersion]] == 1) {
            //发现新版本
            [appDelegate.checkVersionWindow.window close];
            appDelegate.checkVersionWindow = nil;
            appDelegate.checkVersionWindow = [CheckVersionWindowController windowController];
            [appDelegate.checkVersionWindow.window orderFront:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:DOWNLOADURL object:appVersiondict];
        }else {
            [appDelegate.checkVersionWindow.window close];
            appDelegate.checkVersionWindow = nil;
            appDelegate.checkVersionWindow = [CheckVersionWindowController windowController];
            [appDelegate.checkVersionWindow.window orderFront:nil];
            Notifications(DONTNEEDUPLODE);
        }
        
    }else {
        DDLogInfo(@"[Info] 10050 check Version error");
    }
}

#pragma mark - Notification
/**
 Toggle language
 
 @param sender Notification
 */
- (void)changeLanguage:(NSNotification *)sender
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = infoDictionary[@"CFBundleVersion"];
    
    cRightTtitle.stringValue = infoPlistStringBundle(@"NSHumanReadableCopyright");
    version.stringValue = [NSString stringWithFormat:@"%@%@", localizationBundle(@"home.set.about.version"), app_Version];
    appName.stringValue = localizationBundle(@"APPNAME");
    [self.checkBtn changeCenterButtonattribute:localizationBundle(@"alert.checkversion") color:WHITECOLOR];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CHANGELANGUAGE object:nil];
}

@end
