//
//  WebViewController.m
//  PlainNote
//
//  Created by zjc on 17/1/2.
//  Copyright © 2017年 wxw. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

@synthesize myWebView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // 获取index.html文件路径
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSURL *bundleUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    NSString *html = [[NSString alloc] initWithContentsOfFile:htmlPath];
    // 载入到myWebView页面
    [self.myWebView loadHTMLString:html baseURL:bundleUrl];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
