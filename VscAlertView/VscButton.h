//
//  VscButton.h
//  VscAlertViewDemo
//
//  Created by VincentChou on 2017/6/9.
//  Copyright © 2017年 SouFun. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface VscButton : UITableViewCell{
@public
    //可自定义的imgView
    UIImageView *imgView;
    //可自定义的displayLabel
    UILabel *displayLabel;
}
//增加自定义的Image 当为Nil时 不展示
@property (nonatomic,strong) UIImage *image;
//展示的文本
@property (nonatomic,copy) NSString *text;
//按键的字体颜色
@property (nonatomic,strong) UIColor *textColor;
//是否文本加粗
@property (nonatomic,assign) BOOL isBold;
-(void)defaultStyle;
@end
