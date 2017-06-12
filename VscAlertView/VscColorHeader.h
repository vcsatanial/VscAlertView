//
//  VscColorHeader.h
//  VscAlertViewDemo
//
//  Created by VincentChou on 2017/6/9.
//  Copyright © 2017年 SouFun. All rights reserved.
//

#ifndef VscColorHeader_h
#define VscColorHeader_h
#endif /* VscColorHeader_h */
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
