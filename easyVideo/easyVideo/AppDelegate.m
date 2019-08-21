//
//  AppDelegate.m
//  easyVideo
//
//  Created by quanhao huang on 2018/8/9.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "AppDelegate.h"
#import "SignalHandler.h"
#import "UncaughtExceptionHandler.h"
#import <IOKit/pwr_mgt/IOPMLib.h>

//NSString * const BUCKET_NAME = ;
//NSString * const UPLOAD_OBJECT_KEY = @"hexmeethjt/mac";
//NSString * const endPoint = ;
@interface AppDelegate ()<NSURLSessionDataDelegate>
{
    EVEngineObj *evengine;
    OSSClient *_client;
    NSString *flieName;
}
@property (nonatomic, strong) NSMutableData *responseData;

- (IBAction)saveAction:(id)sender;

@end

@implementation AppDelegate

- (NSMutableData *)responseData
{
    if (_responseData == nil) {
        _responseData = [NSMutableData data];
    }
    return _responseData;
}

@synthesize evengine;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    //add signal and exception handler
    
    InstallSignalHandler();
    
    InstallUncaughtExceptionHandler();
    
    self.appName.title = infoPlistStringBundle(@"CFBundleDisplayName");

    self.islogin = NO;
    self.isInTheMeeting = NO;
    self.isautocheck = YES;
    [NSUSERDEFAULT setValue:@"YES" forKey:@"isonce"];
    [NSUSERDEFAULT synchronize];
    
    [self redirectNSLogToDocumentFolder];
    
    [self checktheVersion];
    
    self.joinMeetingWindow = [JoinMeetingWindowController windowController];
    self.uploadWindow = [UploadWindowController windowController];
    
    [self languageLocalization];
    
    [self preventSystemSleep];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucceed) name:LOGINGSUCCEED object:nil];
}

/**
 Language localization
 */
- (void)languageLocalization
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage:) name:CHANGELANGUAGE object:nil];
    
    [LanguageTool initUserLanguage];
    self.MeunName.title = localizationBundle(@"menu.menuName");
    self.sendDiagnosticInfo.title = localizationBundle(@"menu.send");
    self.checkVersion.title = localizationBundle(@"alert.checkversion");
    self.aboutApp.title = localizationBundle(@"menu.about");
    self.exitApp.title = localizationBundle(@"menu.exit");
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

/** check app version */
- (void)checktheVersion
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
#if DEBUG
    urlStr = @"http://swinfo.cninnovatel.com/macos/com.hexmeet.machjt/dev.appinfo.json";
#endif
    //给一个随机数防止取相同地址
    int random = arc4random() % 1000;
    urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"?v=%d", random]];
    
    DDLogInfo(@"[Info] 10053 check version json Url:%@", urlStr);

    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    
    [dataTask resume];
}

/** add log */
- (void)redirectNSLogToDocumentFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *logDirectory = [[paths objectAtIndex:0]stringByAppendingPathComponent:@"Log"];
    NSString *uilogDirectory = [[paths objectAtIndex:0]stringByAppendingPathComponent:@"UILog"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    if ([EVUtils getFileSize:[uilogDirectory stringByAppendingPathComponent:@"EVUILOG.log"]]>20000000) {
        [fileManager removeItemAtPath:[uilogDirectory stringByAppendingPathComponent:@"EVUILOG2.log"] error:nil];
        [self saveFile];
        [fileManager removeItemAtPath:[uilogDirectory stringByAppendingPathComponent:@"EVUILOG.log"] error:nil];
    }
    
    [EVUtils saveNewLogWhenOldLogTooBig];
    
    DDLogFileManagerDefault *fileManagerTwo = [[DDLogFileManagerDefault alloc] initWithLogsDirectory:uilogDirectory];
    DDFileLogger *fileLogger = [[DDFileLogger alloc] initWithLogFileManager:fileManagerTwo];
    
    fileLogger.rollingFrequency = 60 * 60 * 24 * 1000;
    
    fileLogger.maximumFileSize = 40 * 1024 * 1024;
    
    fileLogger.logFileManager.maximumNumberOfLogFiles = 1;
    
    [DDLog addLogger:fileLogger];
    
    BOOL fileExists = [fileManager fileExistsAtPath:logDirectory];
    if (!fileExists) {
        NSError *error = nil;
        [fileManager createDirectoryAtPath:logDirectory withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"error = %@",[error localizedDescription]);
        }
    }
    
    DDLogInfo(@"[Info] ++++++++++++++++++++++++++++++ app start ++++++++++++++++++++++++++++++");
    
    //INIT SDK
    evengine = [[EVEngineObj alloc] init];
    [evengine initialize:logDirectory filename:@"config"];
    [evengine setMaxRecvVideo:9];
    [evengine enablePreview:NO];
    [evengine setRootCA:[EVUtils bundleFile:@"rootca.pem"]];
    [evengine setUserImage:[EVUtils bundleFile:@"bg_videomute.png"] filename:[EVUtils bundleFile:@"image_defaultuser.png"]];
    
    Notifications(AUTOLOGIN);
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    [PlistUtils saveUserInfoPlistFile:infoDictionary withFileName:COMPUTERINFO];
    
    NSDictionary *infoDic = [PlistUtils loadUserInfoPlistFilewithFileName:SETINFO];
    if (infoDic[@"highFrameRate"]) {
        if ([infoDic[@"highFrameRate"] isEqualToString:@"YES"]) {
            [evengine enableHighFPS:YES];
        }else {
            [evengine enableHighFPS:NO];
        }
    }else{
        [evengine enableHighFPS:YES];
        NSMutableDictionary *setDic = [NSMutableDictionary dictionaryWithDictionary:[PlistUtils loadUserInfoPlistFilewithFileName:SETINFO]];
        [setDic setValue:@"YES" forKey:@"highFrameRate"];
        [PlistUtils saveUserInfoPlistFile:(NSDictionary *)setDic withFileName:SETINFO];
    }
    
    //第一次默认开启自动登录
    if (!infoDic[@"autoLog"]) {
        NSMutableDictionary *setDic = [NSMutableDictionary dictionaryWithDictionary:[PlistUtils loadUserInfoPlistFilewithFileName:SETINFO]];
        [setDic setValue:@"YES" forKey:@"autoLog"];
        [PlistUtils saveUserInfoPlistFile:(NSDictionary *)setDic withFileName:SETINFO];
    }
    
    if ([infoDic[@"http"] isEqualToString:@"https"]) {
        [evengine enableSecure:YES];
    }else {
        [evengine enableSecure:NO];
    }
    
    [evengine setBandwidth:2048];
    
    [evengine setLog:EVLogLevelMessage path:logDirectory file:@"evsdk" size:20*1024*1024];
    [evengine enableLog:YES];
    
}

- (void)saveFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"UILog/EVUILOG2.log"];
    
    NSError *error = nil;
    NSString *srcPath = [documentsDirectory stringByAppendingPathComponent:@"UILog/EVUILOG.log"];
    
    BOOL success = [[NSFileManager defaultManager] copyItemAtPath:srcPath toPath:dataPath error:&error];
    if (success == YES)
    {
        NSLog(@"Copied");
    }
    else
    {
        NSLog(@"Not Copied %@", error);
    }
}

/** web Url */
- (void)application:(NSApplication *)application openURLs:(NSArray<NSURL *> *)urls
{
    DDLogInfo(@"[Info] 10013 user click web star app url:%@", [urls[0] absoluteString]);
    if (_isInTheMeeting) {
        return;
    }
    NSURL *webUrl = [urls firstObject];
    
    NSMutableDictionary *dic = [self getURLParameters:[webUrl absoluteString]];
    [dic setValue:[webUrl host] forKey:@"server"];
    
    if([[webUrl absoluteString] rangeOfString:@"join"].location != NSNotFound) {
        if (_islogin) {
            NSDictionary *setInfo = [PlistUtils loadUserInfoPlistFilewithFileName:SETINFO];
            if ([setInfo[@"iscloudLogin"]isEqualToString:@"YES"]) {
                NSDictionary *userinfo = [PlistUtils loadUserInfoPlistFilewithFileName:CLOUDUSERINFO];
                if ([[webUrl host] isEqualToString:userinfo[@"server"]]) {
                    if ([dic[@"protocol"] isEqualToString:@"https"]) {
                        [evengine enableSecure:YES];
                    }else {
                        [evengine enableSecure:NO];
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:WEBJOIN object:dic];
                }else{
                    [[NSNotificationCenter defaultCenter] postNotificationName:LOGINGOUT object:dic];
                }
            }else {
                NSDictionary *userinfo = [PlistUtils loadUserInfoPlistFilewithFileName:PRIVATEUSERINFO];
                if ([[webUrl host] isEqualToString:userinfo[@"server"]]) {
                    if ([dic[@"protocol"] isEqualToString:@"https"]) {
                        [evengine enableSecure:YES];
                    }else {
                        [evengine enableSecure:NO];
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:WEBJOIN object:dic];
                }else{
                    [[NSNotificationCenter defaultCenter] postNotificationName:LOGINGOUT object:dic];
                }
            }
        }else {
            //User set up automatic login
            NSDictionary *infoDic = [PlistUtils loadUserInfoPlistFilewithFileName:SETINFO];
            if (infoDic[@"autoLog"]) {
                if ([infoDic[@"autoLog"] isEqualToString:@"YES"]) {
                    [NSUSERDEFAULT setValue:@"1" forKey:@"canautoLogin"];
                    [NSUSERDEFAULT synchronize];
                    
                    if ([dic[@"protocol"] isEqualToString:@"https"]) {
                        [evengine enableSecure:YES];
                    }else {
                        [evengine enableSecure:NO];
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:ANONYMOUSWEBLOGIN object:dic];
                }else {
                    if ([dic[@"protocol"] isEqualToString:@"https"]) {
                        [evengine enableSecure:YES];
                    }else {
                        [evengine enableSecure:NO];
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:ANONYMOUSWEBLOGIN object:dic];
                }
            }else {
                [[NSNotificationCenter defaultCenter] postNotificationName:ANONYMOUSWEBLOGIN object:dic];
            }
        }
    }else {
        //location server
        if (_islogin) {
            NSDictionary *setInfo = [PlistUtils loadUserInfoPlistFilewithFileName:SETINFO];
            if ([setInfo[@"iscloudLogin"]isEqualToString:@"YES"]) {
                NSDictionary *userinfo = [PlistUtils loadUserInfoPlistFilewithFileName:CLOUDUSERINFO];
                DDLogInfo(@"[Info] location server address:%@", userinfo[@"locationServer"]);
                if ([[webUrl host] isEqualToString:userinfo[@"locationServer"]]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:WEBJOIN object:dic];
                }else{
                    [[NSNotificationCenter defaultCenter] postNotificationName:LOGINGOUT object:dic];
                }
            }else {
                NSDictionary *userinfo = [PlistUtils loadUserInfoPlistFilewithFileName:PRIVATEUSERINFO];
                DDLogInfo(@"[Info] location server address:%@", userinfo[@"locationServer"]);
                if ([[webUrl host] isEqualToString:userinfo[@"locationServer"]]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:WEBJOIN object:dic];
                }else{
                    [[NSNotificationCenter defaultCenter] postNotificationName:LOGINGOUT object:dic];
                }
            }
        }else {
            //User set up automatic login
            NSDictionary *infoDic = [PlistUtils loadUserInfoPlistFilewithFileName:SETINFO];
            if (infoDic[@"autoLog"]) {
                if ([infoDic[@"autoLog"] isEqualToString:@"YES"]) {
                    [NSUSERDEFAULT setValue:@"1" forKey:@"canautoLogin"];
                    [NSUSERDEFAULT synchronize];
                    if ([dic[@"protocol"] isEqualToString:@"https"]) {
                        [evengine enableSecure:YES];
                    }else {
                        [evengine enableSecure:NO];
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:ANONYMOUSLOCATIONWEBLOGIN object:dic];
                }else {
                    if ([dic[@"protocol"] isEqualToString:@"https"]) {
                        [evengine enableSecure:YES];
                    }else {
                        [evengine enableSecure:NO];
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:ANONYMOUSLOCATIONWEBLOGIN object:dic];
                }
            }else {
                if ([dic[@"protocol"] isEqualToString:@"https"]) {
                    [evengine enableSecure:YES];
                }else {
                    [evengine enableSecure:NO];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:ANONYMOUSLOCATIONWEBLOGIN object:dic];
            }
        }
    }
}

- (void)autoLogWeb
{
    NSMutableDictionary *dic = [self getURLParameters:[self.joinurl absoluteString]];
    if (_islogin) {
        NSDictionary *setInfo = [PlistUtils loadUserInfoPlistFilewithFileName:SETINFO];
        if ([setInfo[@"iscloudLogin"]isEqualToString:@"YES"]) {
            NSDictionary *userinfo = [PlistUtils loadUserInfoPlistFilewithFileName:CLOUDUSERINFO];
            if ([[self.joinurl host] isEqualToString:userinfo[@"server"]]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:WEBJOIN object:dic];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:LOGINGOUT object:dic];
            }
        }else {
            NSDictionary *userinfo = [PlistUtils loadUserInfoPlistFilewithFileName:PRIVATEUSERINFO];
            if ([[self.joinurl host] isEqualToString:userinfo[@"server"]]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:WEBJOIN object:dic];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:LOGINGOUT object:dic];
            }
        }
    }else {
        
    }
}

- (void)loginSucceed
{
    NSMutableDictionary *dic = [self getURLParameters:[self.joinurl absoluteString]];
    NSDictionary *setInfo = [PlistUtils loadUserInfoPlistFilewithFileName:SETINFO];
    if ([setInfo[@"iscloudLogin"]isEqualToString:@"YES"]) {
        [NSUSERDEFAULT setValue:@"NO" forKey:@"anonymous"];
        [NSUSERDEFAULT synchronize];
        NSDictionary *userinfo = [PlistUtils loadUserInfoPlistFilewithFileName:CLOUDUSERINFO];
        if ([[self.joinurl host] isEqualToString:userinfo[@"server"]]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:WEBJOIN object:dic];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:LOGINGOUT object:dic];
        }
    }else {
        NSDictionary *userinfo = [PlistUtils loadUserInfoPlistFilewithFileName:PRIVATEUSERINFO];
        if ([[self.joinurl host] isEqualToString:userinfo[@"server"]]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:WEBJOIN object:dic];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:LOGINGOUT object:dic];
        }
    }
}

- (NSMutableDictionary *)getURLParameters:(NSString *)str {
    // 查找参数
    NSRange range = [str rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return nil;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 截取参数
    NSString *parametersString = [str substringFromIndex:range.location + 1];
    // 判断参数是单个参数还是多个参数
    if ([parametersString containsString:@"&"]) {
        // 多个参数，分割参数
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        for (NSString *keyValuePair in urlComponents) {
            // 生成Key/Value
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            // Key不能为nil
            if (key == nil || value == nil) {
                continue;
            }
            id existValue = [params valueForKey:key];
            if (existValue != nil) {
                // 已存在的值，生成数组
                if ([existValue isKindOfClass:[NSArray class]]) {
                    // 已存在的值生成数组
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    [params setValue:items forKey:key];
                } else {
                    // 非数组
                    [params setValue:@[existValue, value] forKey:key];
                }
            } else {
                // 设置值
                [params setValue:value forKey:key];
            }
        }
    } else {
        // 单个参数
        // 生成Key/Value
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        // 只有一个参数，没有值
        if (pairComponents.count == 1) {
            return nil;
        }
        // 分割值
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        // Key不能为nil
        if (key == nil || value == nil) {
            return nil;
        }
        // 设置值
        [params setValue:value forKey:key];
    }
    return params;
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication
                    hasVisibleWindows:(BOOL)flag{
    if (!flag){
        [NSApp activateIgnoringOtherApps:NO];
        [self.mainWindowController.window makeKeyAndOrderFront:self];
    }
    return YES;
}


#pragma mark - 防止系统休眠
- (void)preventSystemSleep {
    // kIOPMAssertionTypeNoDisplaySleep prevents display sleep,
    // kIOPMAssertionTypeNoIdleSleep prevents idle sleep
    
    // reasonForActivity is a descriptive string used by the system whenever it needs
    // to tell the user why the system is not sleeping. For example,
    // "Mail Compacting Mailboxes" would be a useful string.
    
    //  NOTE: IOPMAssertionCreateWithName limits the string to 128 characters.
    CFStringRef reasonForActivity= CFSTR("Describe Activity Type");
    
    IOPMAssertionID assertionID;
    IOReturn success = IOPMAssertionCreateWithName(kIOPMAssertionTypeNoDisplaySleep,
                                                   kIOPMAssertionLevelOn, reasonForActivity, &assertionID);
    if (success == kIOReturnSuccess)
    {
        
        // Add the work you need to do without
        // the system sleeping here.
        
        //        success = IOPMAssertionRelease(assertionID);
        // The system will be able to sleep again.
    }
    
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
        DDLogInfo(@"[Info] 10049 check Version info:%@ local Version info:%@", appVersiondict[@"VERSION"], [EVUtils getLocalAppVersion]);
        
        //版本比较
        if ([EVUtils compareVersion:appVersiondict[@"VERSION"] to:[EVUtils getLocalAppVersion]] == 1) {
            //发现新版本
            [self.checkVersionWindow.window close];
            self.checkVersionWindow = nil;
            self.checkVersionWindow = [CheckVersionWindowController windowController];
            [self.checkVersionWindow.window orderFront:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:DOWNLOADURL object:appVersiondict];
        }else{
            if (!self.isautocheck) {
                [self.checkVersionWindow.window close];
                self.checkVersionWindow = nil;
                self.checkVersionWindow = [CheckVersionWindowController windowController];
                [self.checkVersionWindow.window orderFront:nil];
                Notifications(DONTNEEDUPLODE);
            }
        }
    }else {
        DDLogError(@"[Error] 10050 check Version error");
    }
    self.isautocheck = NO;
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"easyVideo"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving and Undo support

- (IBAction)saveAction:(id)sender {
    // Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
    NSManagedObjectContext *context = self.persistentContainer.viewContext;

    if (![context commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    NSError *error = nil;
    if (context.hasChanges && ![context save:&error]) {
        // Customize this code block to include application-specific recovery steps.              
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
    // Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
    return self.persistentContainer.viewContext.undoManager;
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    // Save changes in the application's managed object context before the application terminates.
    NSManagedObjectContext *context = self.persistentContainer.viewContext;

    if (![context commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    
    if (!context.hasChanges) {
        return NSTerminateNow;
    }
    
    NSError *error = nil;
    if (![context save:&error]) {

        // Customize this code block to include application-specific recovery steps.
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertSecondButtonReturn) {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}

/** 发送诊断信息 */
- (IBAction)sendInfo:(id)sender
{
    [self.uploadWindow.window orderFront:nil];
    [self CloseZipFile];
}

/** 检查版本信息 */
- (IBAction)checkVersion:(id)sender
{
    //清空保存的数据
    [self.responseData resetBytesInRange:NSMakeRange(0, self.responseData.length)];
    [self.responseData setLength:0];
    [self checktheVersion];
}

- (void)CloseZipFile
{
    ZipArchive* zip = [[ZipArchive alloc] init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    NSString * zipFile = [documentPath stringByAppendingString:[self getFileName]] ;
    
    NSString *image1 = [documentPath stringByAppendingString:@"/clouduserInfo.plist"] ;
    NSString *image2 = [documentPath stringByAppendingString:@"/privateuserInfo.plist"] ;
    NSString *image3 = [documentPath stringByAppendingString:@"/setInfo.plist"] ;
    NSString *image4 = [documentPath stringByAppendingString:@"/Log/config"] ;
    NSString *image5 = [documentPath stringByAppendingString:@"/Log/EVLOG.log"] ;
    NSString *image6 = [documentPath stringByAppendingString:@"/Log/evsdk1.log"] ;
    NSString *image7 = [documentPath stringByAppendingString:@"/Log/evsdk2.log"] ;
    NSString *image8 = [documentPath stringByAppendingString:@"/Log/UncaughtException.log"] ;
    NSString *image9 = [documentPath stringByAppendingString:@"/computerinfo.plist"] ;
    NSString *image10 = [documentPath stringByAppendingString:@"/UILog/EVUILOG.log"] ;
    
    [zip CreateZipFile2:zipFile];
    [zip addFileToZip:image1 newname:@"clouduserInfo.plist"];
    [zip addFileToZip:image2 newname:@"privateuserInfo.plist"];
    [zip addFileToZip:image3 newname:@"setInfo.plist"];
    [zip addFileToZip:image4 newname:@"config"];
    [zip addFileToZip:image5 newname:@"EVLOG.log"];
    [zip addFileToZip:image6 newname:@"evsdk1.log"];
    [zip addFileToZip:image7 newname:@"evsdk2.log"];
    [zip addFileToZip:image8 newname:@"UncaughtException.log"];
    [zip addFileToZip:image9 newname:@"computerinfo.log"];
    [zip addFileToZip:image10 newname:@"EVUILOG.log"];
    
    if( ![zip CloseZipFile2] ){
        
    }
    //upload
    
    // It's highly recommended to not use PlainText AK solution, use STS instead. Refer to Aliyun OSS SDK
    // documentation for details.
    OSSPlainTextAKSKPairCredentialProvider *provider = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:APPAK secretKey:APPSK];
    
    [OSSLog disableLog];
    
    _client = [[OSSClient alloc] initWithEndpoint:@"http://oss-cn-beijing.aliyuncs.com" credentialProvider:provider];
    
    OSSPutObjectRequest *put = [OSSPutObjectRequest new];
    put.bucketName = @"hexmeet-log";
    put.objectKey  = [NSString stringWithFormat:@"%@%@",@"hexmeethjt/mac",flieName];
    
    NSString *logDirectory = [paths objectAtIndex:0];
    NSData *fileData = [NSData dataWithContentsOfFile:[logDirectory stringByAppendingPathComponent:flieName]];
    
    put.uploadingData = fileData;
    
    OSSTask * putTask = [_client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                DDLogError(@"[Error] 10004 upload object success!");
                Notifications(UPLOADSU);
                [self removeLogFile];
            });
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                Notifications(UPLOADFAIL);
                [self removeLogFile];
            });
        }
        return nil;
    }];
    [putTask waitUntilFinished];
    
}

- (NSString *)getFileName
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd-HH:mm:ss"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSDictionary *setInfo = [PlistUtils loadUserInfoPlistFilewithFileName:SETINFO];
    NSString *userName = @"";
    if ([setInfo[@"iscloudLogin"]isEqualToString:@"YES"]) {
        NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithDictionary:[PlistUtils loadUserInfoPlistFilewithFileName:CLOUDUSERINFO]];
        userName = userinfo[@"username"];
    }else {
        NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithDictionary:[PlistUtils loadUserInfoPlistFilewithFileName:PRIVATEUSERINFO]];
        userName = userinfo[@"username"];
    }
    flieName = [NSString stringWithFormat:@"/EVINFO-%@-%@.zip", currentTimeString , userName];
    return flieName;
}

- (void)removeLogFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingPathComponent:flieName]]) {
        [fileManager removeItemAtPath:[[paths objectAtIndex:0] stringByAppendingPathComponent:flieName] error:nil];
    }
}

#pragma mark - Notification
/**
 Toggle language
 
 @param sender Notification
 */
- (void)changeLanguage:(NSNotification *)sender
{
    self.MeunName.title = localizationBundle(@"menu.menuName");
    self.sendDiagnosticInfo.title = localizationBundle(@"menu.send");
    self.checkVersion.title = localizationBundle(@"alert.checkversion");
    self.aboutApp.title = localizationBundle(@"menu.about");
    self.exitApp.title = localizationBundle(@"menu.exit");
}

@end

