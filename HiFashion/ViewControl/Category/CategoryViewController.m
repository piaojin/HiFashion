//
//  CategoryViewController.m
//  HiFashion
//
//  Created by apple on 15/8/10.
//  Copyright (c) 2015年 Reasonable. All rights reserved.
//

#import "Tool.h"
#import "PJNetWorkHelper.h"
#import "CategoryViewController.h"
#import "MBProgressHUD.h"
#import "BaseHead.h"
#import "CustomURLCache.h"

#import "ShowNavViewController.h"

@interface CategoryViewController ()
//第一次是否加载成功
@property(nonatomic,assign)BOOL isFirstLoadSuc;
@property (weak, nonatomic) IBOutlet UIWebView *mainWebView;
@property (weak, nonatomic) IBOutlet UILabel *CategoryHintLabel;
@end

@implementation CategoryViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWebview];
    [self initNotification];
    // self.navigationController.navigationBar.translucent = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NETWORKCHANGE object:nil];
}


#pragma mark - webview
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.isFirstLoadSuc=true;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading...";
    NSString * baseurl=webView.request.URL.absoluteString;
    
    if (_netType>0&&([baseurl isEqualToString:CATEGORYBASEURL]||([baseurl rangeOfString:CATEGORYBASEURL].length>0))) {
        CustomURLCache *urlCache = (CustomURLCache *)[NSURLCache sharedURLCache];
        [urlCache removeAllCachedResponses];
    }
    
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString * urlstr=request.URL.absoluteString;
    
    if (UIWebViewNavigationTypeLinkClicked==navigationType) {
        
        if([PJNetWorkHelper isNetWorkAvailable]){
            if (!([urlstr rangeOfString:CATEGORYBASEURL].length>0)) {
                
                
                UIStoryboard *story      = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                ShowNavViewController *showNavVC = [story instantiateViewControllerWithIdentifier:@"CT"];
                showNavVC.baseurl=urlstr;
                self.navigationController.navigationBarHidden=NO;
                showNavVC.hidesBottomBarWhenPushed=YES;
                
                UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
                backItem.title =@"返回";
                self.navigationItem.backBarButtonItem = backItem;
                
                [self.navigationController pushViewController:showNavVC animated:YES];
                return false;
            }
        }else{
            
            [Tool show:@"网络不可用" InView:self.view];
        }
        NSLog(@"%@--",urlstr);
    }
    return true;
}

- (void)initWebview{//http://192.168.2.209:8081
    
//    [_showNavWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_baseurl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:16.0]];
    [self.mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:CATEGORYBASEURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:16.0]];
    self.mainWebView.delegate=self;
    // [self initGas];
    self.mainWebView.opaque=NO;
    UIScrollView *scollview=(UIScrollView *)[[self.mainWebView subviews]objectAtIndex:0];
    scollview.bounces=NO;
}

#pragma mark-创建通知
- (void)initNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(localUserChange:)
                                                 name:NETWORKCHANGE
                                               object:nil];
}

- (void)localUserChange:(NSNotification *)nt{
    NSDictionary * dict=nt.userInfo;
    
    if ([[dict objectForKey:@"NetType"] isEqualToString:@"0"]) {// 没网
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.removeFromSuperViewOnHide =YES;
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText =@"网络不可用";
        hud.minSize = CGSizeMake(132.f, 108.0f);
        [hud hide:YES afterDelay:1];
        if(!self.isFirstLoadSuc){
            
            self.CategoryHintLabel.hidden=NO;
            _mainWebView.hidden=YES;
        }else{
            
            [Tool show:@"网络不可用" InView:self.view];
        }
    }
    
    if ([[dict objectForKey:@"NetType"] isEqualToString:@"1"]) {// 有移动网络
        self.CategoryHintLabel.hidden=YES;
        _mainWebView.hidden=NO;
        if(!self.isFirstLoadSuc){
            
            [self.mainWebView reload];
        }
    }
    
    if([[dict objectForKey:@"NetType"] isEqualToString:@"2"]){//Wifi
        self.CategoryHintLabel.hidden=YES;
        _mainWebView.hidden=NO;
        if(!self.isFirstLoadSuc){
            
            [self.mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:CATEGORYBASEURL]]];
        }
        //[self.mainWebView reload];
        
    }
    
}


@end
