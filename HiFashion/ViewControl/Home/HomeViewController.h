//
//  ViewController.h
//  HiFashion
//
//  Created by apple on 15/7/15.
//  Copyright (c) 2015年 Reasonable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"



@interface HomeViewController : BaseViewController<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *homeWebview;

@end

