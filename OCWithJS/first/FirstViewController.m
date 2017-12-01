//
//  FirstViewController.m
//  OCWithJS
//
//  Created by mengminduan on 2017/11/30.
//  Copyright © 2017年 mengminduan. All rights reserved.
//

#import "FirstViewController.h"
#import "UIView+DUACategory.h"

@interface FirstViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];

    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"callToJS" style:UIBarButtonItemStylePlain target:self action:@selector(callToJS)];
    self.navigationItem.rightBarButtonItem = right;
    self.navigationItem.title = @"UIWebView";
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(self.view.dua_x, self.view.dua_y + 64, self.view.dua_width, self.view.dua_height * 2)];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"first" ofType:@"html"];
    NSURL *url = [NSURL URLWithString:htmlPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}



#pragma mark - UIWebView delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.URL;
    if ([[url scheme] isEqualToString:@"nothot"]) {
        /*
         * 拦截URL实现JS调用OC
         */
        [self doCustomProcessing:url];
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"load finished");
    [self.webView.window makeKeyAndVisible];
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

/*
 * OC调用JS
 */
- (void)callToJS
{
    NSString *string = [NSString stringWithFormat:@"来自OC的消息: %@", @"吃葡萄不吐葡萄皮"];
    NSString *jsString = [NSString stringWithFormat:@"showAlert('%@')", string];
    [self.webView stringByEvaluatingJavaScriptFromString:jsString];
}




@end
