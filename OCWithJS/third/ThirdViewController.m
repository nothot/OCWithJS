//
//  ThirdViewController.m
//  OCWithJS
//
//  Created by mengminduan on 2017/11/30.
//  Copyright © 2017年 mengminduan. All rights reserved.
//

#import "ThirdViewController.h"
#import "UIView+DUACategory.h"
#import <WebKit/WebKit.h>

@interface ThirdViewController () <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"callToJS" style:UIBarButtonItemStylePlain target:self action:@selector(callToJS)];
    self.navigationItem.rightBarButtonItem = right;
    self.navigationItem.title = @"WKWebView";
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *userCC = [WKUserContentController new];
    [userCC addUserScript:wkUScript];
    configuration.userContentController = userCC;
    
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.minimumFontSize = 30.0;
    configuration.preferences = preferences;
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(self.view.dua_x, self.view.dua_y + 64, self.view.dua_width, self.view.dua_height*2) configuration:configuration];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
    
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"third" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:htmlPath];
    [self.webView loadFileURL:url allowingReadAccessToURL:url];
}


#pragma mark - WKWebView delegate
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *url = navigationAction.request.URL;
    if ([[url scheme] isEqualToString:@"nothot"]) {
        /*
         * 拦截URL实现JS调用OC
         */
        [self doCustomProcessing:url];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)doCustomProcessing:(NSURL *)url
{
    NSString *queryString = [url query];
    NSArray *array = [queryString componentsSeparatedByString:@"&"];
    if (array.count) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for (NSString *pairs in array) {
            NSArray *arr = [pairs componentsSeparatedByString:@"="];
            [dict setObject:arr[1] forKey:arr[0]];
        }
        NSString *string = [NSString stringWithFormat:@"来自网页的消息: %@", dict.description];
        NSLog(@"%@", string);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"OC 弹窗"
                                                                       message:string
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:0 handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"third.html"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:0 handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
    completionHandler();
}

/*
 * OC调用JS
 */
- (void)callToJS
{
    NSString *string = [NSString stringWithFormat:@"来自OC的消息: %@", @"吃葡萄不吐葡萄皮"];
    NSString *jsString = [NSString stringWithFormat:@"showAlert('%@')", string];
    [self.webView evaluateJavaScript:jsString completionHandler:nil];
}

@end
