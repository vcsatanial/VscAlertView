//
//  ViewController.m
//  VscAlertViewDemo
//
//  Created by VincentChou on 2017/6/7.
//  Copyright © 2017年 SouFun. All rights reserved.
//

#import "ViewController.h"
#import "VscAlertView.h"
#import "VscColorHeader.h"

@interface ViewController ()

@end

@implementation ViewController
-(void)mixedColorsWithFrame:(CGRect)frame colorsArray:(NSArray *)colorArray andTargetView:(UIView *)targetView{
    CAGradientLayer *gradientColorLayer = [CAGradientLayer layer];
    gradientColorLayer.frame = frame;
    int colorsArrayCount = (int)colorArray.count;
    
    NSMutableArray *colorM_Array = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *locationsArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (UIColor *color in colorArray) {
        [colorM_Array addObject:(id)color.CGColor];
    }
    float minColorInterval = 1.0/(colorsArrayCount-1);
    for (int index = 0; index < colorsArrayCount; index++) {
        [locationsArr addObject:[NSNumber numberWithFloat:index * minColorInterval]];
    }
    gradientColorLayer.colors = colorM_Array;
    gradientColorLayer.locations = locationsArr;
    [targetView.layer insertSublayer:gradientColorLayer atIndex:0];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *array = @[UIColorFromRGB(0xcc0000),UIColorFromRGB(0xeeee00),UIColorFromRGB(0x00ff00),UIColorFromRGB(0x0000aa),UIColorFromRGB(0x7700bb)];
    [self mixedColorsWithFrame:self.view.frame colorsArray:array andTargetView:self.view];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 75, 30)];
    button.backgroundColor = [UIColor clearColor];
    [button setTitle:@"使用点卷" forState:0];
    [button setTitleColor:UIColorFromRGB(0x4b95f2) forState:0];
    button.layer.borderColor = button.currentTitleColor.CGColor;
    button.layer.borderWidth = 1;
    [button addTarget:self action:@selector(showAlertView) forControlEvents:64];
    [self.view addSubview:button];
}
-(void)showAlertView{
    VscAlertView *alertView1 = [[VscAlertView alloc] initWithTitle:@"收到一个错误提示" message:@"因为你已经花光所有点卷,如想继续使用,需要充值" buttonTitles:@"确定",@"取消",nil];
    alertView1.titleColor = [UIColor redColor];
    alertView1.msgColor = [UIColor orangeColor];
    [alertView1 vscAlertBlock:^(VscAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            [self showAlert2];
        }
    }];
    [alertView1 vscCustomButton:^VscButton *(VscButton *cell, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            cell.image = [UIImage imageNamed:@"second"];
        }
        return cell;
    }];
    [alertView1 show];
}
-(void)showAlert2{
    VscAlertView *alertView2 = [[VscAlertView alloc] initWithTitle:@"充值提示" message:@"请选择充值金额" buttonTitles:@"充值512元",@"充值1024元",@"充值2048元",@"充值4096元",@"充值8192元",@"充值16384元",@"充值32768元",@"充值65536元",@",太贵了,不充了,太贵了,不充了,太贵了,不充了,太贵了,不充了,太贵了,不充了",nil];
    [alertView2 vscAlertBlock:^(VscAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == alertView.buttonsArray.count - 1) {
            [self showAlert3];
        }else{
            NSLog(@"%@",alertView.buttonsArray[buttonIndex]);
        }
    }];
    [alertView2 vscCustomButton:^VscButton *(VscButton *cell, NSInteger buttonIndex) {
        if (buttonIndex != alertView2.buttonsArray.count - 1) {
            cell.image = [UIImage imageNamed:@"dollor.jpeg"];
            if (buttonIndex %2 == 0) {
                cell.textColor = [UIColor redColor];
            }else{
                cell.textColor = [UIColor magentaColor];
            }
        }else{
            cell.isBold = YES;
        }
        return cell;
    }];
    [alertView2 show];
}
-(void)showAlert3{
    VscAlertView *alertView3 = [[VscAlertView alloc] initWithTitle:@"充值提示" message:@"其实我们还有小额充值金额" buttonTitles:@"充值1元",@"充值6元",@"充值12元",@"充值30元",@"确定放弃",nil];
    [alertView3 vscAlertBlock:^(VscAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex != 4) {
            NSLog(@"%@",alertView.buttonsArray[buttonIndex]);
        }
    }];
    [alertView3 vscCustomButton:^VscButton *(VscButton *cell, NSInteger buttonIndex) {
        if (buttonIndex != 4) {
            cell.image = [UIImage imageNamed:@"yuan"];
        }else{
            cell.isBold = YES;
        }
        return cell;
    }];
    [alertView3 show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
