//
//  routineViewController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/8/24.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "routineViewController.h"
#import "macHUD.h"

@interface routineViewController ()<NSComboBoxDelegate>
{
    OSSClient *_client;
    macHUD *hub;
    NSString *flieName;
    AppDelegate *appDelegate;
}
@end

@implementation routineViewController

NSString * const BUCKET_NAME = @"hexmeet-log";
NSString * const UPLOAD_OBJECT_KEY = @"hexmeethjt/mac";
NSString * const endPoint = @"http://oss-cn-beijing.aliyuncs.com";

@synthesize languagecomboBox, languageTitle, diagnosisBtn, diagnosisTitle, applicationTitle, autoLoginBtn, autoAnserBtn, highFrameRateBtn, enableHD;

- (void)viewWillAppear
{
    [super viewWillAppear];
    
    [self getSetInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self setRootViewAttribute];
    
    [self languageLocalization];
    
    appDelegate = APPDELEGATE;
}

- (void)setRootViewAttribute
{
    languagecomboBox.delegate = self;
    languagecomboBox.editable = NO;
    
    hub = [macHUD creatMacHUD:@"" icon:@"" viewController:self];
    hub.hidden = YES;
}

/**
 Language localization
 */
- (void)languageLocalization
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage:) name:CHANGELANGUAGE object:nil];
    
    [LanguageTool initUserLanguage];
    
    languageTitle.stringValue = localizationBundle(@"home.set.routine.language");
    
    [languagecomboBox removeAllItems];
    
    [languagecomboBox addItemWithObjectValue:localizationBundle(@"home.set.routine.chinese")];
    [languagecomboBox addItemWithObjectValue:localizationBundle(@"home.set.routine.english")];
    
    NSString *language = [LanguageTool userLanguage];
    
    if ([language isEqualToString:@"en"]) {
        [languagecomboBox selectItemAtIndex:1];
    }else{
        [languagecomboBox selectItemAtIndex:0];
    }
    
    diagnosisTitle.stringValue = localizationBundle(@"home.set.routine.diagnosis");
    [diagnosisBtn changeLeftButtonattribute:localizationBundle(@"home.set.routine.uploaddiagnosis") color:BLACKCOLOR];
    applicationTitle.stringValue = localizationBundle(@"home.set.routine.application");
    
    [autoLoginBtn changeLeftButtonattribute:localizationBundle(@"home.set.routine.autologin") color:BLACKCOLOR];
    [autoAnserBtn changeLeftButtonattribute:localizationBundle(@"home.set.routine.autoanswer") color:BLACKCOLOR];
    [highFrameRateBtn changeLeftButtonattribute:localizationBundle(@"home.set.routine.highframerate") color:BLACKCOLOR];
    [enableHD changeLeftButtonattribute:@"1080p" color:BLACKCOLOR];
}

- (void)getSetInfo
{
    NSDictionary *infoDic = [PlistUtils loadUserInfoPlistFilewithFileName:SETINFO];
    if (infoDic[@"autoLog"]) {
        if ([infoDic[@"autoLog"] isEqualToString:@"YES"]) {
            autoLoginBtn.state = NSOnState;
        }else {
            autoLoginBtn.state = NSOffState;
        }
    }
    if (infoDic[@"autoAnswer"]) {
        if ([infoDic[@"autoAnswer"] isEqualToString:@"YES"]) {
            autoAnserBtn.state = NSOnState;
        }else {
            autoAnserBtn.state = NSOffState;
        }
    }
    if (infoDic[@"highFrameRate"]) {
        if ([infoDic[@"highFrameRate"] isEqualToString:@"YES"]) {
            highFrameRateBtn.state = NSOnState;
        }else {
            highFrameRateBtn.state = NSOffState;
        }
    }
    if (infoDic[@"1080p"]) {
        if ([infoDic[@"1080p"] isEqualToString:@"YES"]) {
            enableHD.state = NSOnState;
        }else {
            enableHD.state = NSOffState;
        }
    }
}

#pragma mark - ButtonMethod
- (IBAction)buttonAction:(id)sender
{
    NSMutableDictionary *setDic = [NSMutableDictionary dictionaryWithDictionary:[PlistUtils loadUserInfoPlistFilewithFileName:SETINFO]];
    if (autoLoginBtn.state == NSOnState) {
        [setDic setValue:@"YES" forKey:@"autoLog"];
    }else {
        [setDic setValue:@"NO" forKey:@"autoLog"];
    }
    if (autoAnserBtn.state == NSOnState) {
        [setDic setValue:@"YES" forKey:@"autoAnswer"];
    }else {
        [setDic setValue:@"NO" forKey:@"autoAnswer"];
    }
    if (sender == diagnosisBtn) {
        
        [self CloseZipFile];
        
    }
    if (highFrameRateBtn.state == NSOnState) {
        [setDic setValue:@"YES" forKey:@"highFrameRate"];
        [appDelegate.evengine enableHighFPS:YES];
    }else {
        [setDic setValue:@"NO" forKey:@"highFrameRate"];
        [appDelegate.evengine enableHighFPS:NO];
    }
    if (enableHD.state == NSOnState) {
        [setDic setValue:@"YES" forKey:@"1080p"];
        [appDelegate.evengine enableHD:YES];
    }else {
        [appDelegate.evengine enableHD:NO];
    }
    
    [PlistUtils saveUserInfoPlistFile:(NSDictionary *)setDic withFileName:SETINFO];
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
    hub.hidden = NO;
    hub.hudTitleFd.stringValue = localizationBundle(@"alert.upload");
    
    // It's highly recommended to not use PlainText AK solution, use STS instead. Refer to Aliyun OSS SDK
    // documentation for details. 
    OSSPlainTextAKSKPairCredentialProvider *provider = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:APPAK secretKey:APPSK];

    [OSSLog disableLog];

    _client = [[OSSClient alloc] initWithEndpoint:endPoint credentialProvider:provider];

    OSSPutObjectRequest *put = [OSSPutObjectRequest new];
    put.bucketName = BUCKET_NAME;
    put.objectKey  = [NSString stringWithFormat:@"%@%@",@"hexmeethjt/mac",flieName];

    NSString *logDirectory = [paths objectAtIndex:0];
    NSData *fileData = [NSData dataWithContentsOfFile:[logDirectory stringByAppendingPathComponent:flieName]];

    put.uploadingData = fileData;

    OSSTask * putTask = [_client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                DDLogInfo(@"[Info] 10004 upload object success!");
                self->hub.hudTitleFd.stringValue = localizationBundle(@"alert.uploaded.successfully");
                [self persendMethod:2];
            });

        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                DDLogInfo(@"[Info] 10005 object failed, error: %@" , task.error);
                self->hub.hudTitleFd.stringValue = localizationBundle(@"alert.uploaded.failed");
                [self persendMethod:2];
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

#pragma mark - NSButtonMethod
- (IBAction)changecomboBoxValue:(id)sender
{
    if ([languagecomboBox.stringValue isEqualToString:localizationBundle(@"home.set.routine.chinese")]) {
        //zh
        [LanguageTool setUserlanguage:@"zh-Hans"];
    }else {
        //en
        [LanguageTool setUserlanguage:@"en"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGELANGUAGE object:self];
}

#pragma mark - Notification
/**
 Toggle language
 
 @param sender Notification
 */
- (void)changeLanguage:(NSNotification *)sender
{
    languageTitle.stringValue = localizationBundle(@"home.set.routine.language");
    
    [languagecomboBox removeAllItems];
    
    [languagecomboBox addItemWithObjectValue:localizationBundle(@"home.set.routine.chinese")];
    [languagecomboBox addItemWithObjectValue:localizationBundle(@"home.set.routine.english")];
    
    NSString *language = [LanguageTool userLanguage];
    
    if ([language isEqualToString:@"en"]) {
        [languagecomboBox selectItemAtIndex:1];
    }else{
        [languagecomboBox selectItemAtIndex:0];
    }
    
    diagnosisTitle.stringValue = localizationBundle(@"home.set.routine.diagnosis");
    [diagnosisBtn changeLeftButtonattribute:localizationBundle(@"home.set.routine.uploaddiagnosis") color:BLACKCOLOR];
    applicationTitle.stringValue = localizationBundle(@"home.set.routine.application");
    
    [autoLoginBtn changeLeftButtonattribute:localizationBundle(@"home.set.routine.autologin") color:BLACKCOLOR];
    [autoAnserBtn changeLeftButtonattribute:localizationBundle(@"home.set.routine.autoanswer") color:BLACKCOLOR];
    [highFrameRateBtn changeLeftButtonattribute:localizationBundle(@"home.set.routine.highframerate") color:BLACKCOLOR];
}

#pragma mark - HIDDENHUD
- (void)persendMethod:(NSInteger)time
{
    [self performSelector:@selector(hiddenHUD) withObject:self afterDelay:time];
}

- (void)hiddenHUD
{
    hub.hidden = YES;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingPathComponent:flieName]]) {
        [fileManager removeItemAtPath:[[paths objectAtIndex:0] stringByAppendingPathComponent:flieName] error:nil];
    }
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CHANGELANGUAGE object:nil];
}

@end
