//
//  BaseViewController.m
//  HiFashion
//
//  Created by apple on 15/7/16.
//  Copyright (c) 2015年 Reasonable. All rights reserved.
//



#import "BaseViewController.h"
#import "Reachability.h"
#import "BaseHead.h"
#import "CustomURLCache.h"

typedef NS_ENUM(NSInteger, NetType) {
    NoNet     = 0 , //没网
    WiFiNet  = 1 , // 图片
    MobileNet= 2 ,  // 语音

};


@interface BaseViewController ()

@end

@implementation BaseViewController





- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    //[self initWebCache];
    [self checkNetwork];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    CustomURLCache *urlCache = (CustomURLCache *)[NSURLCache sharedURLCache];
    [urlCache removeAllCachedResponses];
}



#pragma mark-设置状态栏隐藏掉
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;//uis
}
//
- (BOOL)prefersStatusBarHidden//for iOS7.0
{
   return NO;
}

#pragma mark-添加网络缓存
- (void)initWebCache{
    CustomURLCache *urlCache = [[CustomURLCache alloc] initWithMemoryCapacity:20 * 1024 * 1024
                                                                 diskCapacity:200 * 1024 * 1024
                                                                     diskPath:nil
                                                               cacheTime:0];
    [CustomURLCache setSharedURLCache:urlCache];
}


#pragma mark-添加网络检测
- (void)checkNetwork{

    Reachability* reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    [reach startNotifier];
}


- (void) reachabilityChanged: (NSNotification*)note {
    Reachability * reach = [note object];
     NSString * type;
    CustomURLCache *urlCache = (CustomURLCache *)[NSURLCache sharedURLCache];
    
    if(![reach isReachable])
    { //网络不可用
     
        type=@"0";
        _netType=0;
        NSLog(@"没网");
    }
   
    if (reach.isReachableViaWWAN) {//@"当前通过2g or 3g连接"
         NSLog(@"移动网络");
        _netType=1;
        
        [urlCache removeAllCachedResponses];

        type=@"1";
    }
    
    if (reach.isReachableViaWiFi) {//@"当前通过wifi连接";
        _netType=2;
        type=@"2";
        NSLog(@"Wifi");
        [urlCache removeAllCachedResponses];
    }
     NSMutableDictionary * dict=[[NSMutableDictionary alloc] initWithObjectsAndKeys:type,@"NetType", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:NETWORKCHANGE
                                                        object:self userInfo:dict];
}

//判断网络是否可用
-(BOOL) isConnectionAvailable{
    BOOL isExistenceNetwork = NO;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }
    return isExistenceNetwork;
    //return [Reachability networkAvailable];
}
@end
