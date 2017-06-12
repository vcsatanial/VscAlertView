//
//  VscPressButton.m
//  VscAlertViewDemo
//
//  Created by VincentChou on 2017/6/9.
//  Copyright © 2017年 SouFun. All rights reserved.
//

#import "VscPressButton.h"
#import "VscColorHeader.h"

UIImage *getImageWithColor(UIColor *color){
    CGRect rect = CGRectMake(0, 0, 1.f, 1.f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@interface VscPressButton (){
    UIImageView *imgView;
    UILabel *label;
}

@end
@implementation VscPressButton
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    label = [[UILabel alloc] init];
    label.font = [UIFont fontWithName:@"Helvetica" size:18];
    label.textColor = UIColorFromRGB(0x4b95f2);
    imgView = [[UIImageView alloc] init];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = self.bounds;
    effectView.userInteractionEnabled = NO;
    [self addSubview:effectView];
    [self addSubview:label];
    return self;
}
-(void)setIsBold:(BOOL)isBold{
    _isBold = isBold;
    if (isBold) {
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    }else{
        label.font = [UIFont fontWithName:@"Helvetica" size:18];
    }
}
-(void)setText:(NSString *)text{
    label.text = text;
    [self displayFrames];
}
-(void)setImage:(UIImage *)image{
    if (image) {
        imgView.image = image;
        [self addSubview:imgView];
    }
    [self displayFrames];
}
-(void)setNormalColor:(UIColor *)normalColor{
    [self setBackgroundImage:getImageWithColor(normalColor) forState:0];
}
-(void)setHighliColor:(UIColor *)highliColor{
    [self setBackgroundImage:getImageWithColor(highliColor) forState:1];
}
-(void)displayFrames{
    float rightMove = 0;
    if (imgView.image) {
        rightMove += 15;
    }
    CGSize size = CGSizeMake(self.frame.size.width - 30, self.frame.size.height);
    CGSize fitSize = [label sizeThatFits:size];
    float y = (self.frame.size.height - fitSize.height)/2.f;
    label.frame = CGRectMake((self.frame.size.width - fitSize.width)/2 + rightMove, y, fitSize.width, fitSize.height);
    imgView.frame = CGRectMake(label.frame.origin.x - 30, 5, 30, self.frame.size.height - 10);
    imgView.contentMode = UIViewContentModeScaleAspectFit;
}
@end
