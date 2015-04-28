//
//  ViewController.m
//  WKWebView
//
//  Created by harry on 2/20/15.
//  Copyright (c) 2015 Harry Cheung. All rights reserved.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface ViewController ()
  @property(strong,nonatomic) WKWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor whiteColor];
  CGRect parent = self.view.bounds;
  CGRect frame = CGRectMake(0.0f, 40.0f, parent.size.width, parent.size.height);
  NSURL *url = [NSURL URLWithString:@"http://harrycheung.github.io/Mobile-App-Performance/run.html"];
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
  _webView = [[WKWebView alloc] initWithFrame:frame
                                configuration:configuration];
  [_webView loadRequest:request];
  [self.view addSubview:_webView];
}

@end
