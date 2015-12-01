//
//  Tool.m
//  HiFashion
//
//  Created by 翁金闪 on 15/12/1.
//  Copyright © 2015年 Reasonable. All rights reserved.
//

#import "MBProgressHUD.h"
#import "Tool.h"

@implementation Tool
+(void)show:(NSString *)msg InView:(UIView *)view{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = msg;
    hud.minSize = CGSizeMake(132.f, 108.0f);
    [hud hide:YES afterDelay:1];
}
@end
