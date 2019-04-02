//
//  MeetingWebViewController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/9/19.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "MeetingWebViewController.h"
#import "macHUD.h"

@interface MeetingWebViewController ()<WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate, EVEngineDelegate>
{
    AppDelegate *appDelegate;
    macHUD *hub;
}
@end

@implementation MeetingWebViewController

@synthesize webView, reloadBtn;

- (void)viewDidDisappear
{
    [super viewDidDisappear];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CLOSEMEETINGWEBWINDOW object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UPLOADMEETINGWEBWINDOW object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UPDATETOKEN object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    appDelegate = APPDELEGATE;
    [reloadBtn changeCenterButtonattribute:localizationBundle(@"alert.reload") color:WHITECOLOR];
    [reloadBtn setBackgroundColor:BLUECOLOR];
    reloadBtn.layer.cornerRadius = 4;
    
    [_bgView setBackgroundColor:WHITECOLOR];
    
    hub = [macHUD creatMacHUD:@"" icon:@"" viewController:self];
    hub.hidden = YES;
}

- (void)viewWillAppear
{
    [super viewWillAppear];
    [self creatWebview];
}

- (void)creatWebview
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeWindow) name:CLOSEMEETINGWEBWINDOW object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadWindow) name:UPLOADMEETINGWEBWINDOW object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateToken:) name:UPDATETOKEN object:nil];
    
    webView.configuration.preferences.minimumFontSize = 10;
    webView.configuration.preferences.javaScriptEnabled = YES;
    webView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    [webView.configuration.userContentController addScriptMessageHandler:self name:@"callbackObj"];
    
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    
    [self setConferenceManagerUrl];
}

- (void)setConferenceManagerUrl
{
    NSDictionary *setDic = [PlistUtils loadUserInfoPlistFilewithFileName:SETINFO];
    EVUserInfo *userInfo = [appDelegate.evengine getUserInfo];
    NSString *token = userInfo.token;
    
    //http://cloud.hexmeet.com/webapp/#/confControl?numericId=13910001017&token=1209575050&lang=cn
    NSString *webUrl = [NSString stringWithFormat:@"%@/webapp/#/confControl?numericId=%@&token=%@",userInfo.customizedH5UrlPrefix, setDic[@"confId"],token];
#if DEBUG
    //    webUrl = [NSString stringWithFormat:@"http://172.16.0.82:8001/#/conferences?token=%@", token];
#endif
    
    DDLogInfo(@"[Info] 10010 Conference manager URL：%@", webUrl);
    
    NSString *language = [LanguageTool userLanguage];
    
    
    if ([language isEqualToString:@"en"]) {
        webUrl = [NSString stringWithFormat:@"%@&lang=%@",webUrl,@"en"];
    }else {
        webUrl = [NSString stringWithFormat:@"%@&lang=%@",webUrl,@"cn"];
    }
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webUrl]]];
    
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:@"callbackObj"]) {
        if (![message.body isKindOfClass:[NSString class]]) {
            return;
        }
        if ([message.body containsString:@"sendEmail"]) {
            NSString *emailLink = [[message.body componentsSeparatedByString:@"$"] objectAtIndex:1];
            [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:emailLink]];
        }else if ([message.body containsString:@"tokenExpired"]) {
            //重新登录回传token
            NSString *jsStr = [appDelegate.evengine getUserInfo].token;
            if (jsStr.length == 0) {
                //没有内容不传给WEB
                return;
            }
            [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                if (!error) {
                    // 成功
                } else {
                    // 失败
                }
            }];
        }
    }
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
    
}

//当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}

//页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    reloadBtn.hidden = YES;
    _bgView.hidden = YES;
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    reloadBtn.hidden = NO;
    _bgView.hidden = NO;
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

#pragma mark - Notification
- (void)closeWindow
{
    [self.view.window close];
}

- (void)uploadWindow
{
    [self setConferenceManagerUrl];
}

- (IBAction)reloadAction:(id)sender
{
    [self setConferenceManagerUrl];
    hub.hidden = NO;
    hub.hudTitleFd.stringValue = localizationBundle(@"alert.loading");
    [self persendMethod:3];
}

/**
 need update web token
 */
- (void)updateToken:(NSNotification *)sender
{
    NSString *jsStr = [appDelegate.evengine getUserInfo].token;
    if (jsStr.length == 0) {
        //没有内容不传给WEB
        return;
    }
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        if (!error) {
            // 成功
        } else {
            // 失败
        }
    }];
}

#pragma mark - HIDDENHUD
- (void)persendMethod:(NSInteger)time
{
    [self performSelector:@selector(hiddenHUD) withObject:self afterDelay:time];
}

- (void)hiddenHUD
{
    hub.hidden = YES;
}

@end
