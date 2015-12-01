//
//  BaseHead.h
//  HiFashion
//
//  Created by apple on 15/7/16.
//  Copyright (c) 2015年 Reasonable. All rights reserved.
//



#ifndef HiFashion_BaseHead_h
#define HiFashion_BaseHead_h

#ifndef __OPTIMIZE__
#define BASEURL @"http://192.168.2.209:8081/"
#else
#define  BASEURL @"http://hifashion.12mart.net/"
#endif

#define TAOBAOLOGIN @"https://ynuf.alipay.com/la.htm?"
//#define HOMEBASEURL  @"http://hifashion.12mart.net/"
//#define CATEGORYBASEURL  @"http://hifashion.12mart.net/category.html"
//#define MEBASEURL  @"http://hifashion.12mart.net/user.aspx"
//#define NETWORKCHANGE @"netWorkChange"

#define HOMEBASEURL  BASEURL
#define CATEGORYBASEURL    [NSString stringWithFormat:@"%@%@",BASEURL,@"category.html"]
#define MEBASEURL   [NSString stringWithFormat:@"%@%@",BASEURL,@"user.aspx"] 
#define NETWORKCHANGE @"netWorkChange"
#define NONETWORK @"网络不可用"
#define LOADERROR @"加载失败"


#endif
