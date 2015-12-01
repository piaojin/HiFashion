//
//  PJNetWorkHelper.m
//  IMReasonable
//
//  Created by 翁金闪 on 15/10/21.
//  Copyright © 2015年 Reasonable. All rights reserved.
//

#import "PJNetWorkHelper.h"
#import "Reachability.h"

@implementation PJNetWorkHelper

+(BOOL)isNetWorkAvailable{
 Reachability* reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    return [reach isReachable];
}
@end
