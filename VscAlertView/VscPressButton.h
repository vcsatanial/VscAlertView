//
//  VscPressButton.h
//  VscAlertViewDemo
//
//  Created by VincentChou on 2017/6/9.
//  Copyright © 2017年 SouFun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VscPressButton : UIButton
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) NSString *text;
@property (nonatomic,assign) BOOL isBold;
@property (nonatomic,strong) UIColor *normalColor;
@property (nonatomic,strong) UIColor *highliColor;
@end
