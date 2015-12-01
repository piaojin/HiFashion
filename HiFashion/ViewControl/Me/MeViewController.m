//
//  MeViewController.m
//  HiFashion
//
//  Created by apple on 15/8/10.
//  Copyright (c) 2015年 Reasonable. All rights reserved.
//

#import "Tool.h"
#import "PJNetWorkHelper.h"
#import "MeViewController.h"
#import "MBProgressHUD.h"
#import "BaseHead.h"
#import "CustomURLCache.h"
#import "ShowNavViewController.h"

@interface MeViewController ()
@property(nonatomic,assign)BOOL isFirstLoadSuc;
/**
 *  UIWebView第一次如果没有网络，加载会失败，则reload方法会无效，即使后面网络可以了reload还是无效
 */
@property (weak, nonatomic) IBOutlet UILabel* MeHintLabel;
@property (weak, nonatomic) IBOutlet UIWebView* MeWebView;

@end

@implementation MeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initWebview];
    [self initNotification];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NETWORKCHANGE object:nil];
}

#pragma mark - webview
- (void)webViewDidFinishLoad:(UIWebView*)webView
{
    self.isFirstLoadSuc=true;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webViewDidStartLoad:(UIWebView*)webView
{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading...";
    NSString* baseurl = webView.request.URL.absoluteString;

    if (_netType > 0 && ([baseurl isEqualToString:MEBASEURL] || ([baseurl rangeOfString:MEBASEURL].length > 0))) {
        CustomURLCache* urlCache = (CustomURLCache*)[NSURLCache sharedURLCache];
        [urlCache removeAllCachedResponses];
    }
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    if([PJNetWorkHelper isNetWorkAvailable]){
        return true;
    }else{
        
        [Tool show:@"网络不可用" InView:self.view];
        return false;
    }
}

- (void)initWebview
{ //http://192.168.2.209:8081

    [self.MeWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:MEBASEURL]]];
    self.MeWebView.delegate = self;
    // [self initGas];
    self.MeWebView.opaque = NO;
    UIScrollView* scollview = (UIScrollView*)[[self.MeWebView subviews] objectAtIndex:0];
    scollview.bounces = NO;
}

#pragma mark -创建通知
- (void)initNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(localUserChange:)
                                                 name:NETWORKCHANGE
                                               object:nil];
}

- (void)localUserChange:(NSNotification*)nt
{

    NSDictionary* dict = nt.userInfo;

    if ([[dict objectForKey:@"NetType"] isEqualToString:@"0"]) { // 没网
        MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.removeFromSuperViewOnHide = YES;
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"网络不可用";
        hud.minSize = CGSizeMake(132.f, 108.0f);
        [hud hide:YES afterDelay:1];
        if(!self.isFirstLoadSuc){
            
            self.MeHintLabel.hidden = NO;
            _MeWebView.hidden = YES;
        }else{
            
            [Tool show:@"网络不可用" InView:self.view];
        }
    }

    if ([[dict objectForKey:@"NetType"] isEqualToString:@"1"]) { // 有移动网络

        self.MeHintLabel.hidden = YES;
        _MeWebView.hidden = NO;
        if(!self.isFirstLoadSuc){
            
            [self.MeWebView reload];
        }
    }

    if ([[dict objectForKey:@"NetType"] isEqualToString:@"2"]) { //Wifi
        self.MeHintLabel.hidden = YES;
        _MeWebView.hidden = NO;
        if(!self.isFirstLoadSuc){
            
            [self.MeWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:MEBASEURL]]];
        }
    }
}

@end
