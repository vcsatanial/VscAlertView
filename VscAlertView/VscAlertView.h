//
//  VscAlertView.h
//  VscDemos
//
//  Created by VincentChou on 2017/5/3.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VscButton.h"
#import "VscPressButton.h"

@class VscAlertView;
@protocol VscAlertDelegate <NSObject>
@optional
-(void)vsc_alertView:(VscAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end
@protocol VscAlertDataSource <NSObject>
@optional
-(VscButton *)vsc_alertView:(VscAlertView *)alertView buttonNeedToResign:(VscButton *)buttonCell buttonIndex:(NSInteger)buttonIndex;
@end
typedef void(^VscAlertBlock)(VscAlertView *alertView,NSInteger buttonIndex);
typedef VscButton *(^VscButtonBlock)(VscButton *button,NSInteger buttonIndex);
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
@property (nonatomic,strong) NSArray *buttonsArray;
//显示的提示框的高度(不设定默认为200)
@property (nonatomic,assign) CGFloat height;
//如果按钮只有2个 依然使用table选择样式
@property (nonatomic,assign) BOOL useTableStyle;

/**
 初始化方法

 @param title title信息可为空
 @param message message新课可为空,当title,message都为空只有按键
 @param otherButtonTitles 按键的名称
 */
-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSString *)otherButtonTitles, ...;

/**
 点击按键的Block回调方法

 @param block Block中包含一个VscAlertView(可持有此VscAlertView<做成属性>)
 */
-(void)vscAlertBlock:(VscAlertBlock)block;

/**
 自定义按键的样式
 Block中有VscButton 可以对其属性进行更改
 */
-(void)vscCustomButton:(VscButtonBlock)block;

/**
 调用此方法 VscAlertView即会出现 请修改属性的工作均在此方法之前执行
 */
-(void)show;
@end
