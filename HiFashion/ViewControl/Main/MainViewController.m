//
//  MainViewController.m
//  HiFashion
//
//  Created by apple on 15/7/15.
//  Copyright (c) 2015年 Reasonable. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    self.tabBar.tintColor = [UIColor colorWithRed:238.0 / 255 green:18.0 / 255 blue:137.0 / 255 alpha:1];
    UITabBarItem* tabBarItem0 = [self.tabBar.items objectAtIndex:0];
    tabBarItem0.selectedImage = [UIImage imageNamed:@"tabbar_contactsHL"];
    UITabBarItem* tabBarItem2 = [self.tabBar.items objectAtIndex:1];
    tabBarItem2.selectedImage = [UIImage imageNamed:@"tabbar_discoverHL"];
    UITabBarItem* tabBarItem3 = [self.tabBar.items objectAtIndex:2];
    tabBarItem3.selectedImage = [UIImage imageNamed:@"tabbar_meHL"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
