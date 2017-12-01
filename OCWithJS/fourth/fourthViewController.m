//
//  fourthViewController.m
//  OCWithJS
//
//  Created by mengminduan on 2017/11/30.
//  Copyright © 2017年 mengminduan. All rights reserved.
//

#import "fourthViewController.h"
#import "UIView+DUACategory.h"
#import <WebKit/WebKit.h>

@interface fourthViewController () <WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation fourthViewController

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
    
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"fourth" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:htmlPath];
    [self.webView loadFileURL:url allowingReadAccessToURL:url];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"callOC"];
}


#pragma mark - WKWebView delegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"fourth.html"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:0 handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
    completionHandler();
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:@"callOC"]) {
        [self doCustomProcessing:message.body];
    }
}

- (void)doCustomProcessing:(id)object
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[object objectForKey:@"title"] forKey:@"title"];
    [dict setObject:[object objectForKey:@"content"] forKey:@"content"];
    NSString *string = [NSString stringWithFormat:@"来自网页的消息: %@", dict.description];
    NSLog(@"%@", string);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"OC 弹窗"
                                                                   message:string
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:0 handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"callOC"];
}

@end

