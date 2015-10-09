//
//  BaseViewController.h
//  HiFashion
//
//  Created by apple on 15/7/16.
//  Copyright (c) 2015年 Reasonable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
{
    NSInteger _netType;
}

@property (assign,nonatomic) NSInteger netType;
-(BOOL) isConnectionAvailable;
@end
