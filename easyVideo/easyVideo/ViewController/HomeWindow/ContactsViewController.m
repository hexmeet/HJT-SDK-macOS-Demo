//
//  ContactsViewController.m
//  easyVideo
//
//  Created by quanhao huang on 2019/11/12.
//  Copyright © 2019 easyVideo. All rights reserved.
//

#import "ContactsViewController.h"

@interface ContactsViewController ()<WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate, EVEngineDelegate>
{
    AppDelegate *appDelegate;
    BOOL flag;
}
@end

@implementation ContactsViewController

@synthesize webView, loadViewBg, gifView, errorBg, prompttitel, loadBg, loadBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self setRootViewAttribute];
    
    [self languageLocalization];
    
    [self creatWebview];
    
    [self setConferenceManagerUrl];
    
}

- (void)viewWillAppear {
    [super viewWillAppear];
    
    flag = YES;
}

- (void)setRootViewAttribute
{
    [self.view setBackgroundColor:WHITECOLOR];
    [webView setBackgroundColor:BLUECOLOR];
    [loadViewBg setBackgroundColor:WHITECOLOR];
    [loadBg setBackgroundColor:BLUECOLOR];
    loadBg.layer.cornerRadius = 4;
    
    [gifView setImage:[NSImage imageNamed:@"loading.gif"]];
    
    appDelegate = APPDELEGATE;
}

- (void)languageLocalization
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage:) name:CHANGELANGUAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateToken:) name:UPDATETOKEN object:nil];
    
    [LanguageTool initUserLanguage];
    
    [loadBtn changeCenterButtonattribute:localizationBundle(@"alert.reload") color:WHITECOLOR];
    prompttitel.stringValue = localizationBundle(@"alert.loadingerror");
}

- (void)creatWebview
{
    webView.configuration.preferences.minimumFontSize = 10;
    webView.configuration.preferences.javaScriptEnabled = YES;
    webView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    [webView.configuration.userContentController addScriptMessageHandler:self name:@"callbackObj"];
    
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
}

- (void)setConferenceManagerUrl
{
    NSDictionary *setDic = [PlistUtils loadUserInfoPlistFilewithFileName:SETINFO];
    NSDictionary *userDic;
    if ([setDic[@"iscloudLogin"] isEqualToString:@"YES"]) {
        userDic = [PlistUtils loadUserInfoPlistFilewithFileName:CLOUDUSERINFO];
    }else {
        userDic = [PlistUtils loadUserInfoPlistFilewithFileName:PRIVATEUSERINFO];
    }
    
    
    NSString *webUrl = [NSString stringWithFormat:@"%@/webapp/#/contacts?token=%@", [EVUtils queryUserInfo:@"customizedH5UrlPrefix"], [appDelegate.evengine getUserInfo].token];
#if DEBUG
//    webUrl = [NSString stringWithFormat:@"http://172.16.0.103:8001/#/conferences?token=%@", @"96f67621f338461da98f252c1fbc0818"];
#endif
    
    NSString *language = [LanguageTool userLanguage];
    
    if ([language isEqualToString:@"en"]) {
        webUrl = [NSString stringWithFormat:@"%@&lang=%@",webUrl,@"en"];
    }else {
        webUrl = [NSString stringWithFormat:@"%@&lang=%@",webUrl,@"cn"];
    }
    
    DDLogInfo(@"[Info] 10014 weburl = %@", webUrl);
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webUrl]]];

}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:@"callbackObj"]) {
        
        if (![message.body isKindOfClass:[NSString class]]) {
            return;
        }
        
        if ([message.body containsString:@"p2pCall"]) {
            //p2p呼叫
            NSString *jsonStr = [[message.body componentsSeparatedByString:@"$"] objectAtIndex:1];
            NSDictionary *dict = [EVUtils dictionaryWithJsonString:jsonStr];
            if (dict[@"userId"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:P2PCALL object:nil userInfo:dict];
            }
        }else if ([message.body containsString:@"tokenExpired"]) {
            if (flag) {
                flag = NO;
                if (appDelegate.islogin) {
                    NSString *jsStr =[NSString stringWithFormat:@"window.updateToken('%@')", [appDelegate.evengine getUserInfo].token];
                    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                        if (!error) {
                            // 成功
                        } else {
                            // 失败
                        }
                    }];
                    
                    [self setConferenceManagerUrl];
                }else if ([message.body containsString:@"clearCache"]) {
                    //清除缓存
                    [EVUtils deleteWebCache];
                    //重新加载
                    [self setConferenceManagerUrl];
                }
            }else {
                [self performSelector:@selector(updateTokenMethod) withObject:nil afterDelay:2];
            }
        }
    }
}

- (void)updateTokenMethod
{
    flag = YES;
}

#pragma mark = WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSString *hostname = navigationAction.request.URL.host.lowercaseString;
    NSLog(@"hostname - %@",hostname);
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated
        && ![hostname containsString:@".baidu.com"]) {
        
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    decisionHandler(WKNavigationResponsePolicyAllow);
}

//接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
    }
}

//开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    errorBg.hidden = YES;
    loadBg.hidden = YES;
    prompttitel.hidden = YES;
    gifView.hidden = NO;
    loadViewBg.hidden = NO;
}

//当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}

//页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    loadViewBg.hidden = YES;
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    errorBg.hidden = NO;
    loadBg.hidden = NO;
    prompttitel.hidden = NO;
    gifView.hidden = YES;
    loadViewBg.hidden = NO;
}

#pragma mark WKUIDelegate
//alert 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    
}

//confirm 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
    
}

#pragma mark - EVEngineDelegate
- (void)onError:(EVError *)err
{
    
}

#pragma mark Button Method
- (IBAction)loadAciton:(id)sender
{
    [self setConferenceManagerUrl];
}

#pragma mark - Notification
/**
 Toggle language
 
 @param sender Notification
 */
- (void)changeLanguage:(NSNotification *)sender
{
    [self setConferenceManagerUrl];
    
    [loadBtn changeCenterButtonattribute:localizationBundle(@"alert.reload") color:WHITECOLOR];
    prompttitel.stringValue = localizationBundle(@"alert.loadingerror");
}

/**
 need update web token
 */
- (void)updateToken:(NSNotification *)sender
{
//    NSString *jsStr =[NSString stringWithFormat:@"window.updateToken('%@')", [appDelegate.evengine getUserInfo].token];
//    if (jsStr.length == 0) {
//        //没有内容不传给WEB
//        return;
//    }
//    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable response, NSError * _Nullable error) {
//        if (!error) {
//            // 成功
//        } else {
//            // 失败
//        }
//    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CHANGELANGUAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UPDATETOKEN object:nil];
}

@end
