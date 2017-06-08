//
//  VscAlertView.m
//  VscDemos
//
//  Created by VincentChou on 2017/5/3.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "VscAlertView.h"
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

UIImage *imageWithColor(UIColor *color){
    CGRect rect = CGRectMake(0, 0, 1.f, 1.f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - VscAlertView代码
@interface VscAlertView (){
    NSString *_title;
    NSString *_message;
    UITableView *_tableView;
    UIView *backgroundView;
    CGFloat _buttonHeight;
}
@property (nonatomic,strong) VscAlertView *mySelf;
@property (nonatomic,copy) VscAlertBlock alertBlock;
@property (nonatomic,assign) VscAlertBlock alertTempBlock;
@property (nonatomic,copy) VscButtonBlock btnBlock;
@property (nonatomic,assign) VscButtonBlock btnTempBlock;
@end
static NSString *myId = @"AlertViewTableCell";
@implementation VscAlertView
-(void)dealloc{
    NSLog(@"VscAlertView dealloc");
}
-(void)setButtonHeight:(CGFloat)buttonHeight{
    if (buttonHeight < 30) {
        buttonHeight = 30;
    }
    _buttonHeight = buttonHeight;
}
-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message
                            buttonTitles:(NSString *)otherButtonTitles, ...{
    CGSize allSize = [UIScreen mainScreen].bounds.size;
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        float width = 274;
        backgroundView = [[UIView alloc] initWithFrame:CGRectMake((allSize.width - width )/ 2, 200, width, 200)];
        backgroundView.backgroundColor = [UIColor clearColor];
        backgroundView.layer.cornerRadius = 10;
        backgroundView.clipsToBounds = YES;
        [self addSubview:backgroundView];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        self.windowLevel = UIWindowLevelAlert - 1;
        
        _title  = [title copy];
        _message = [message copy];
        if (otherButtonTitles) {
            NSString *arg = nil;
            va_list argumentList;
            
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
            [array addObject:otherButtonTitles];
            va_start(argumentList, otherButtonTitles);
            
            while ((arg = va_arg(argumentList, NSString *))) {
                [array addObject:arg];
            }
            va_end(argumentList);
            _buttonsArray = [array copy];
        }
        _buttonHeight = 44;
        
        _titleColor = [UIColor blackColor];
        _msgColor = [UIColor blackColor];
        
        [self addSubview:_tableView];
    }
    return self;
}
-(void)displayTitle{
    if (_title && ![_title isEqualToString:@""]) {
        if (!titleLabel) {
            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, backgroundView.frame.size.width - 40, 30)];
            titleLabel.textColor = _titleColor;
            titleLabel.textAlignment = 1;
            titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        }
        [backgroundView addSubview:titleLabel];
        titleLabel.text = _title;
    }
}
-(void)displayMessage{
    float lineY = 0.f;
    if (_message && ![_message isEqualToString:@""]) {
        if (!msgLabel) {
            msgLabel = [[UILabel alloc] init];
            msgLabel.textColor = _msgColor;
            msgLabel.textAlignment = 1;
            msgLabel.numberOfLines = 0;
        }
        [backgroundView addSubview:msgLabel];
        msgLabel.text = _message;
        UIFont *font = [UIFont systemFontOfSize:13];
        CGSize size = CGSizeMake(backgroundView.frame.size.width - 30, MAXFLOAT);
        msgLabel.font = font;
        CGSize labelSize = [msgLabel sizeThatFits:size];
        CGFloat y = CGRectGetMaxY(titleLabel.frame);
        if (y == 0) {
            y += 25;
        }
        msgLabel.frame = CGRectMake(15, y, backgroundView.frame.size.width-30, labelSize.height);
    }
    if (!msgLabel) {
        lineY = CGRectGetMaxY(titleLabel.frame) + 25;
    }else{
        lineY = CGRectGetMaxY(msgLabel.frame) + 25;
    }
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, backgroundView.frame.size.width, lineY);
    [backgroundView insertSubview:effectView atIndex:0];
}
-(void)displayButtons{
    CGFloat height = CGRectGetMaxY(msgLabel.frame) + 25;
    if (!msgLabel) {
        height = CGRectGetMaxY(titleLabel.frame) + 25;
    }
    if (_buttonsArray.count > 2) {
        BOOL lessThanSix = _buttonsArray.count <= 6;
        CGFloat tableHeight = lessThanSix ? _buttonHeight * _buttonsArray.count : _buttonHeight * 6;
        if (!_tableView) {
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, height + 0.5, backgroundView.frame.size.width, tableHeight) style:UITableViewStylePlain];
            _tableView.backgroundColor = [UIColor clearColor];
            _tableView.backgroundView.backgroundColor = [UIColor clearColor];
            _tableView.dataSource = self;
            _tableView.delegate = self;
            [_tableView flashScrollIndicators];
            _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [backgroundView addSubview:_tableView];
            [_tableView registerClass:[VscButton class] forCellReuseIdentifier:myId];
        }
        _tableView.bounces = NO;
        
        CGRect frame = backgroundView.frame;
        frame.size.height = CGRectGetMaxY(_tableView.frame);
        frame.origin.y = (self.frame.size.height - frame.size.height)/2;
        backgroundView.frame = frame;
    }else{
        if (!_buttonsArray || _buttonsArray.count == 0) {
            _buttonsArray = @[@"确定"];
        }
        for (int index = 0; index < _buttonsArray.count; index ++) {
            float width = backgroundView.frame.size.width / 2;
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(index * backgroundView.frame.size.width / 2, height  + 1,_buttonsArray.count == 1 ? width * 2 : width , _buttonHeight)];
            if (index == 0) {
                button.frame = CGRectMake(0, height + 1, (_buttonsArray.count == 1 ? width * 2 : width) - 0.5, _buttonHeight);
            }
            button.tag = 1000 + index;
            [button addTarget:self action:@selector(alertButtonClick:) forControlEvents:64];
            button.backgroundColor = [UIColor clearColor];
            
            UIImage *backImg = imageWithColor([[UIColor blackColor] colorWithAlphaComponent:0.05]);
            [button setBackgroundImage:backImg forState:1<<0];
            
            UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
            UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
            effectView.frame = button.frame;
            
            [backgroundView addSubview:effectView];
            [backgroundView addSubview: button];
            
            NSString *title = _buttonsArray[index];
            [button setTitle:title forState:0];
            [button setTitleColor:UIColorFromRGB(0x4b95f2) forState:0];
            
            VscButton *cell = [[VscButton alloc] init];
            BOOL customDesign = NO;
            if (self.dataSource) {
                cell = [self.dataSource vsc_alertView:self buttonNeedToResign:cell buttonIndex:index];
                customDesign = YES;
            }
            if (self.btnBlock) {
                cell = self.btnBlock(cell,index);
                customDesign = YES;
            }
            if (customDesign) {
                UIColor *color = cell.textColor;
                if (!color) {
                    color = UIColorFromRGB(0x4b95f2);
                }
                if (cell.isBold) {
                    button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
                }
                [button setTitleColor:color forState:0];
                if (cell.image) {
                    [button setImage:cell.image forState:0];
                    [button setImageEdgeInsets:UIEdgeInsetsMake(10,0,10,-25)];
                    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
                }
            }
        }
        CGRect frame = backgroundView.frame;
        frame.size.height = height + _buttonHeight + 0.5;
        frame.origin.y = (self.frame.size.height - frame.size.height)/2;
        backgroundView.frame = frame;
    }
}
-(void)alertButtonClick:(UIButton *)sender{
    NSInteger index = sender.tag - 1000;
    if (self.delegate) {
        [self.delegate vsc_alertView:self clickedButtonAtIndex:index];
    }
    if (self.alertBlock) {
        self.alertBlock(self,index);
    }
    [self removeMyself];
}
-(void)vscAlertBlock:(VscAlertBlock)block{
//    _alertBlock = block;
    _alertTempBlock = block;
}
-(void)vscCustomButton:(VscButtonBlock)block{
//    _btnBlock = block;
    _btnTempBlock = block;
}
-(void)show{
    _mySelf = self;
    _alertBlock = [_alertTempBlock copy];
    _btnBlock = [_btnTempBlock copy];
    [self displayTitle];
    [self displayMessage];
    [self displayButtons];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = backgroundView.bounds;
    [backgroundView insertSubview:effectView atIndex:0];
    
    [self makeKeyAndVisible];
    
    backgroundView.alpha = 0;
    backgroundView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    [UIView animateWithDuration:0.3 animations:^{
        backgroundView.alpha = 1;
        backgroundView.transform = CGAffineTransformIdentity;
    }];
}
-(void)removeMyself{
    [self resignKeyWindow];
    _mySelf = nil;
    self.btnBlock = nil;
    self.alertBlock = nil;
    self.hidden = YES;
}
#pragma mark TableView
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _buttonHeight;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _buttonsArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VscButton *cell = [tableView dequeueReusableCellWithIdentifier:myId];
    cell.superAlertView = self;
    NSAssert([_buttonsArray[indexPath.row] isKindOfClass:[NSString class]], @"数组中必须是NSString类型");
    [cell defaultStyle];
    cell.text = _buttonsArray[indexPath.row];
    if (self.dataSource) {
        cell = [self.dataSource vsc_alertView:self buttonNeedToResign:cell buttonIndex:indexPath.row];
    }
    if (self.btnBlock) {
        cell = self.btnBlock(cell,indexPath.row);
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    VscButton *vscCell = (VscButton *)cell;
    vscCell.backgroundColor = [UIColor clearColor];
    [vscCell displayFrames];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate) {
        [self.delegate vsc_alertView:self clickedButtonAtIndex:indexPath.row];
    }
    if (self.alertBlock) {
        self.alertBlock(self,indexPath.row);
    }
    [self removeMyself];
}

@end
#pragma mark - VscButton代码

@interface VscButton (){
    BOOL _isBold;
    UIVisualEffectView *effectView;
}
@end
@implementation VscButton
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        imgView = [[UIImageView alloc] init];
        displayLabel = [[UILabel alloc] init];
        displayLabel.textColor = UIColorFromRGB(0x4b95f2);
        displayLabel.backgroundColor = [UIColor clearColor];
        displayLabel.textAlignment = 1;
        displayLabel.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:displayLabel];
    }
    return self;
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
    imgView.contentMode = UIViewContentModeScaleAspectFit;

    if (!effectView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height-0.5);
        [self.contentView insertSubview:effectView atIndex:0];
    }
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
