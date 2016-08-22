//
//  MyWebViewController.m
//  IOSAndJS
//
//  Created by md on 16/8/22.
//  Copyright © 2016年 HKQ. All rights reserved.
//

#import "MyWebViewController.h"



@interface MyWebViewController ()<UIWebViewDelegate>
{
    UIWebView *mWebView;
}
@end

@implementation MyWebViewController
@synthesize mDict;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = mDict[@"title"];
    self.view.backgroundColor = [UIColor purpleColor];
    
    mWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    mWebView.delegate = self;
    [mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:mDict[@"shareUrl"]]]];
    [self.view addSubview:mWebView];
    
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
