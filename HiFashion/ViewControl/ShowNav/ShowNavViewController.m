//
//  ShowNavViewController.m
//  HiFashion
//
//  Created by apple on 15/7/22.
//  Copyright (c) 2015年 Reasonable. All rights reserved.
//

#import "BaseHead.h"
#import "ShowNavViewController.h"
#import "MBProgressHUD.h"

@interface ShowNavViewController (){
 
    
    UIWebView * _showNavWebView;
    NSString * _baseurl;

}
@property(nonatomic,copy)NSString *tempurl;
@property (strong, nonatomic) IBOutlet UIWebView *showNavWebView;
@property (weak, nonatomic) IBOutlet UILabel *ShowNavHintLabel;

@end

@implementation ShowNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNotification];
    [self initWebview];
    [self initNav];
   // self.navigationController.hidesBarsOnSwipe =YES;
   
}

- (void)initNav{
    UIBarButtonItem *temporaryBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    self.navigationItem.title=@"......";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:151.0/255.0 green:1.0/255.0 blue:2.0/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];


}
- (void)initWebview{
    
    
    [_showNavWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_baseurl]]];
    _showNavWebView.delegate=self;
    _showNavWebView.opaque=NO;
    UIScrollView *scollview=(UIScrollView *)[[_showNavWebView subviews]objectAtIndex:0];
    scollview.bounces=NO;
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    self.tempurl=request.URL.absoluteString;
    return true;
}

- (void)goBack{
    if (_showNavWebView.canGoBack) {
//        [_showNavWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_baseurl]]];
        NSRange range=[self.tempurl rangeOfString:TAOBAOLOGIN];
        /**
         *  淘宝链接如果包含登陆重定向则会一直跳转到登陆页面，所以要连续返回两次才能不被重定向到淘宝登陆页面
         */
        if(range.location!=NSNotFound){
            [_showNavWebView goBack];
            [_showNavWebView goBack];
        }else{
            [_showNavWebView goBack];
        }
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }

}


#pragma mark - webview
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.navigationItem.title=[_showNavWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading...";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
        self.ShowNavHintLabel.hidden = NO;
        _showNavWebView.hidden = YES;
    }
    
    if ([[dict objectForKey:@"NetType"] isEqualToString:@"1"]) { // 有移动网络
        
        self.ShowNavHintLabel.hidden = YES;
        _showNavWebView.hidden = NO;
        [self.showNavWebView reload];
    }
    
    if ([[dict objectForKey:@"NetType"] isEqualToString:@"2"]) { //Wifi
        self.ShowNavHintLabel.hidden = YES;
        _showNavWebView.hidden = NO;
        [_showNavWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_baseurl]]];
        //[self.homeWebview reload];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NETWORKCHANGE object:nil];
}

@end
