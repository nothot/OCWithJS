//
//  SecondViewController.m
//  OCWithJS
//
//  Created by mengminduan on 2017/11/30.
//  Copyright © 2017年 mengminduan. All rights reserved.
//

#import "SecondViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "UIView+DUACategory.h"

@interface SecondViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"callToJS" style:UIBarButtonItemStylePlain target:self action:@selector(callToJS)];
    self.navigationItem.rightBarButtonItem = right;
    self.navigationItem.title = @"JavaScriptCore";
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(self.view.dua_x, self.view.dua_y + 64, self.view.dua_width, self.view.dua_height*2)];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"second" ofType:@"html"];
    NSURL *url = [NSURL URLWithString:htmlPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}



#pragma mark - UIWebView delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"load finished");
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    // 将OC的block赋值给JS的函数，实现JS调用OC的目的
    
    __weak typeof(self) weakSelf = self;
    context[@"popOCAlert"] = ^() {
        NSArray *args = [JSContext currentArguments] ;
        NSString *title = args[0];
        NSString *content = args[1];
        NSDictionary *dict = @{
                               @"title":title,
                               @"content":content
                               };
        
        NSString *string = [NSString stringWithFormat:@"来自网页的消息: %@", dict.description];
        NSLog(@"%@", string);
        dispatch_async(dispatch_get_main_queue(), ^() {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"OC 弹窗"
                                                                           message:string
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:0 handler:nil];
            [alert addAction:action];
            [weakSelf presentViewController:alert animated:YES completion:nil];
        });
    };
}

/*
 * OC调用JS
 */
- (void)callToJS
{
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    // 方式一
    NSString *string = [NSString stringWithFormat:@"来自OC的消息: %@", @"吃葡萄不吐葡萄皮"];
    NSString *jsString = [NSString stringWithFormat:@"showAlert('%@')", string];
    [context evaluateScript:jsString];
    
    // 方式二
//    JSValue *showAlert = context[@"showAlert"];
//    [showAlert callWithArguments:@[string]];
}


@end
