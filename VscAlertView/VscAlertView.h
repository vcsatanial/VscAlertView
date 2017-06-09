//
//  VscAlertView.h
//  VscDemos
//
//  Created by VincentChou on 2017/5/3.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@class VscAlertView;
@class VscButton;
@protocol VscAlertDelegate <NSObject>
@optional
-(void)vsc_alertView:(VscAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end
@protocol VscAlertDataSource <NSObject>
@optional
-(VscButton *)vsc_alertView:(VscAlertView *)alertView buttonNeedToResign:(VscButton *)buttonCell buttonIndex:(NSInteger)buttonIndex;
@end
typedef void(^VscAlertBlock)(VscAlertView *alertView,NSInteger buttonIndex);
typedef VscButton *(^VscButtonBlock)(VscButton *cell,NSInteger buttonIndex);
@interface VscAlertView : UIWindow<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    @public
    //可以自定义title样式
    UILabel *titleLabel;
    //可以自定义message样式
    UILabel *msgLabel;
}
//title颜色
@property (nonatomic,strong) UIColor *titleColor;
//message颜色
@property (nonatomic,strong) UIColor *msgColor;
//代理 可通过代理传值或者Block
@property (nonatomic,weak) id<VscAlertDelegate>delegate;
//数据源 可通过数据源或者Block
@property (nonatomic,weak) id<VscAlertDataSource>dataSource;
//按键的数组
@property (nonatomic,strong,readonly) NSArray *buttonsArray;
/**
 初始化方法

 @param title title信息可为空
 @param message message新课可为空,当title,message都为空只有按键
 @param otherButtonTitles 按键的名称
 */
-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSString *)otherButtonTitles, ...;

/**
 点击按键的Block回调方法

 @param block Block中包含一个__weak VscAlertView(可持有此VscAlertView<做成属性>)
 */
-(void)vscAlertBlock:(VscAlertBlock)block;

/**
 自定义按键的样式
 Block中有VscButton 可以对其属性进行更改
 */
-(void)vscCustomButton:(VscButtonBlock)block;

/**
 调用此方法 VscAlertView即会出现 请修改样式的工作均在此方法之前执行
 */
-(void)show;
@end
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
//获取到使用VscButton的VscAlertView
@property (nonatomic,weak) VscAlertView *superAlertView;
-(void)defaultStyle;
-(void)displayFrames;
@end
