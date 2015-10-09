//
//  ViewController.m
//  HiFashion
//
//  Created by apple on 15/7/15.
//  Copyright (c) 2015年 Reasonable. All rights reserved.
//

#import "HomeViewController.h"
#import "MBProgressHUD.h"
#import "BaseHead.h"
#import "CustomURLCache.h"

#import "ShowNavViewController.h"

@interface HomeViewController () {

    UIWebView* _homeWebview;
}
@property (weak, nonatomic) IBOutlet UILabel* HomeHintLabel;
@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initWebview];
    [self initNotification];
    // self.navigationController.navigationBar.translucent = YES;
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

    if (_netType > 0 && ([baseurl isEqualToString:HOMEBASEURL] || ([baseurl rangeOfString:HOMEBASEURL].length > 0))) {
        CustomURLCache* urlCache = (CustomURLCache*)[NSURLCache sharedURLCache];
        [urlCache removeAllCachedResponses];
    }
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{

    NSString* urlstr = request.URL.absoluteString;

    if (UIWebViewNavigationTypeLinkClicked == navigationType) {
        
            NSLog(@"%@--", urlstr);
            if (!([urlstr rangeOfString:HOMEBASEURL].length > 0)) {
                
                UIStoryboard* story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                ShowNavViewController* showNavVC = [story instantiateViewControllerWithIdentifier:@"CT"];
                showNavVC.baseurl = urlstr;
                self.navigationController.navigationBarHidden = NO;
                showNavVC.hidesBottomBarWhenPushed = YES;
                
                UIBarButtonItem* backItem = [[UIBarButtonItem alloc] init];
                backItem.title = @"返回";
                self.navigationItem.backBarButtonItem = backItem;
                
                [self.navigationController pushViewController:showNavVC animated:YES];
                return false;
            }
    }
    return true;
}

- (void)initWebview
{ //http://192.168.2.209:8081

    [self.homeWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:HOMEBASEURL]]];
    self.homeWebview.delegate = self;
    // [self initGas];
    self.homeWebview.opaque = NO;
    UIScrollView* scollview = (UIScrollView*)[[self.homeWebview subviews] objectAtIndex:0];
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
        self.HomeHintLabel.hidden = NO;
        _homeWebview.hidden = YES;
    }

    if ([[dict objectForKey:@"NetType"] isEqualToString:@"1"]) { // 有移动网络

        self.HomeHintLabel.hidden = YES;
        _homeWebview.hidden = NO;
        [self.homeWebview reload];
    }

    if ([[dict objectForKey:@"NetType"] isEqualToString:@"2"]) { //Wifi
        self.HomeHintLabel.hidden = YES;
        _homeWebview.hidden = NO;
        [self.homeWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:HOMEBASEURL]]];
        //[self.homeWebview reload];
    }
}
@end
