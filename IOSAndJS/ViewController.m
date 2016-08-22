//
//  ViewController.m
//  IOSAndJS
//
//  Created by md on 16/8/18.
//  Copyright © 2016年 HKQ. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "MyWebViewController.h"

@interface ViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *mWebView;
@property (nonatomic) JSContext *jsContext;
@property (nonatomic, strong) UIButton *btn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _mWebView.delegate = self;
    [self.view addSubview:_mWebView];
    NSString *string = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    [_mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:string]]];
    
    self.btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.btn.frame = CGRectMake(100, 400, 100, 40);
    self.btn.backgroundColor = [UIColor redColor];
    [self.btn setTitle:@"alert" forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(showAlert) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn];
    
}
- (void)showAlert
{
    //要将script的alert（）方法转换为string类型
    NSString *alertJs = @"alert('Hello word')";
    [_jsContext evaluateScript:alertJs];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    __weak ViewController *weakSelf = self;
    _jsContext[@"startFunction"] = ^(id obj){
        //这里通过block回调从而获得h5传来的json数据
        /*block中捕获JSContexts
         我们知道block会默认强引用它所捕获的对象，如下代码所示，如果block中直接使用context也会造成循环引用，这使用我们最好采用[JSContext currentContext]来获取当前的JSContext:
         */
        [JSContext currentContext];
        NSData *data = [(NSString *)obj dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dictionary = %@",dictionary);
       
        MyWebViewController *myWebVC = [[MyWebViewController alloc] init];
        myWebVC.mDict = dictionary;
        [weakSelf.navigationController pushViewController:myWebVC animated:YES];
    };
    _jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue){
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@",exceptionValue);
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
