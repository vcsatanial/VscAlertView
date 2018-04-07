//
//  VscButton.m
//  VscAlertViewDemo
//
//  Created by VincentChou on 2017/6/9.
//  Copyright © 2017年 SouFun. All rights reserved.
//

#import "VscButton.h"
#import "VscColorHeader.h"
@interface VscButton (){
    BOOL _isBold;
    UIVisualEffectView *effectView;
}
@end
@implementation VscButton

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        imgView = [[UIImageView alloc] init];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        displayLabel = [[UILabel alloc] init];
        displayLabel.textColor = UIColorFromRGB(0x4b95f2);
        displayLabel.backgroundColor = [UIColor clearColor];
        displayLabel.textAlignment = 1;
        displayLabel.numberOfLines = 0;
        displayLabel.font = [UIFont systemFontOfSize:18];
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:displayLabel];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self displayFrames];
}
-(void)defaultStyle{
    displayLabel.textColor = UIColorFromRGB(0x4b95f2);
    self.image = nil;
    self.isBold = NO;
}
-(void)displayFrames{
    CGSize size = CGSizeMake(self.contentView.frame.size.width - 30, self.contentView.frame.size.height);
    CGSize fitSize = [displayLabel sizeThatFits:size];
    displayLabel.frame = CGRectMake((self.contentView.frame.size.width - fitSize.width)/2, (self.contentView.frame.size.height - fitSize.height)/2, fitSize.width, fitSize.height);
    imgView.frame = CGRectMake(displayLabel.frame.origin.x - 30, 5, 30, self.contentView.frame.size.height - 10);
    
    if (!effectView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        [self.contentView insertSubview:effectView atIndex:0];
    }
    effectView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height-0.5);
}
-(void)setIsBold:(BOOL)isBold{
    if (isBold) {
        displayLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    }else{
        displayLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
    }
    _isBold = isBold;
}
-(BOOL)isBold{
    return _isBold;
}
-(NSString *)text{
    return displayLabel.text;
}
-(void)setText:(NSString *)text{
    displayLabel.text = [text copy];
}
-(void)setImage:(UIImage *)image{
    imgView.image = image;
    [self.contentView addSubview:imgView];
}
-(UIImage *)image{
    return imgView.image;
}
-(void)setTextColor:(UIColor *)textColor{
    displayLabel.textColor = textColor;
}
-(UIColor *)textColor{
    return displayLabel.textColor;
}
@end
