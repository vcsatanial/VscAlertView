//
//  VscAlertView.m
//  VscDemos
//
//  Created by VincentChou on 2017/5/3.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "VscAlertView.h"
#import "VscColorHeader.h"
#import "VscItem.h"

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
    NSMutableArray <VscItem *>*items;
}
@property (nonatomic,strong) VscAlertView *mySelf;
//当不调用show方法同时调用Block时,为防止内存不能释放,增加栈block,当成功调用show时,将栈block转化成堆block(ARC)
@property (nonatomic,copy) VscAlertBlock alertBlock;
@property (nonatomic,assign) VscAlertBlock alertTempBlock;
@property (nonatomic,copy) VscButtonBlock btnBlock;
@property (nonatomic,assign) VscButtonBlock btnTempBlock;
@end
static NSString *myId = @"AlertViewTableCell";
@implementation VscAlertView
@synthesize buttonsArray = _buttonsArray;
-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSString *)otherButtonTitles, ...{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        [self initializeSettings];
        
        _title  = [title copy];
        _message = [message copy];
        items = @[].mutableCopy;
        if (otherButtonTitles) {
            NSMutableArray *btns = @[].mutableCopy;
            NSString *arg = nil;
            va_list argumentList;
            
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
            if (otherButtonTitles) {
                VscItem *item = [[VscItem alloc] init];
                item.title = otherButtonTitles;
                [items addObject:item];
                [array addObject:otherButtonTitles];
                
                va_start(argumentList, otherButtonTitles);
                while ((arg = va_arg(argumentList, NSString *))) {
                    VscItem *item = [[VscItem alloc] init];
                    item.title = arg;
                    [items addObject:item];
                    [btns addObject:arg];
                }
                va_end(argumentList);
            }
        }else{
            VscItem *item = [[VscItem alloc] init];
            item.title = @"确定";
            [items addObject:item];
        }
    }
    return self;
}
-(NSArray *)buttonsArray{
    if (!_buttonsArray) {
        NSMutableArray *btns = @[].mutableCopy;
        for (VscItem *item in items) {
            [btns addObject:item.title];
        }
        _buttonsArray = btns.copy;
    }
    return _buttonsArray;
}
-(void)setButtonsArray:(NSArray *)buttonsArray{
    [items removeAllObjects];
    _buttonsArray = buttonsArray;
    for (NSString *string in buttonsArray) {
        VscItem *item = [[VscItem alloc] init];
        item.title = string;
        [items addObject:item];
    }
    if (items.count == 0) {
        VscItem *item = [[VscItem alloc] init];
        item.title = @"确定";
        [items addObject:item];
    }
}
-(void)initializeSettings{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    self.windowLevel = UIWindowLevelAlert - 1;
    
    _titleColor = [UIColor blackColor];
    _msgColor = [UIColor blackColor];
    
    CGSize allSize = [UIScreen mainScreen].bounds.size;
    float width = 274;
    backgroundView = [[UIView alloc] initWithFrame:CGRectMake((allSize.width - width )/ 2, 200, width, 200)];
    backgroundView.backgroundColor = [UIColor clearColor];
    backgroundView.layer.cornerRadius = 10;
    backgroundView.clipsToBounds = YES;
    [self addSubview:backgroundView];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, backgroundView.frame.size.width - 40, 30)];
    titleLabel.textColor = _titleColor;
    titleLabel.textAlignment = 1;
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    
    msgLabel = [[UILabel alloc] init];
    msgLabel.textColor = _msgColor;
    msgLabel.textAlignment = 1;
    msgLabel.numberOfLines = 0;
}
-(void)displayTitle{
    if (_title && ![_title isEqualToString:@""]) {
        [backgroundView addSubview:titleLabel];
        titleLabel.text = _title;
    }
}
-(void)displayMessage{
    float lineY = 0.f;
    if (_message && ![_message isEqualToString:@""]) {
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
    if (_message.length == 0) {
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
    if (_message.length == 0) {
        height = CGRectGetMaxY(titleLabel.frame) + 25;
    }
    if (items.count > 2) {
        CGFloat allHeight = 0;
        for (VscItem *item in items) {
            CGFloat height = [item.title boundingRectWithSize:CGSizeMake(backgroundView.frame.size.width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18]} context:NULL].size.height + 21;
            if (height > 44) {
                item.height = height;
            }else{
                item.height = 44;
            }
            allHeight += item.height;
        }
        CGFloat tableHeight = MIN(_height, allHeight);
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
        for (int index = 0; index < items.count; index ++) {
            float width = items.count == 1 ? backgroundView.frame.size.width : backgroundView.frame.size.width / 2  ;
            if (items.count == 2 && index == 0) {
                width -= 0.5;
            }
            VscPressButton *button = [[VscPressButton alloc] initWithFrame:CGRectMake(index * backgroundView.frame.size.width / 2,height  + 1,width ,44)];
            button.tag = 1000 + index;
            [button addTarget:self action:@selector(alertButtonClick:) forControlEvents:64];
            button.highliColor = [[UIColor blackColor] colorWithAlphaComponent:0.05];
            [backgroundView addSubview: button];
            NSString *title = items[index].title;
            button.text = title;
            VscButton *cell = [[VscButton alloc] init];
            cell.textColor = UIColorFromRGB(0x4b95f2);
            if (self.dataSource) {
                cell = [self.dataSource vsc_alertView:self buttonNeedToResign:cell buttonIndex:index];
            }
            if (self.btnBlock) {
                cell = self.btnBlock(cell,index);
            }
            button.isBold = cell.isBold;
            button.image = cell.image;
            [button setTitleColor:cell.textColor forState:0];
        }
        CGRect frame = backgroundView.frame;
        frame.size.height = height + 44 + 0.5;
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
    _alertTempBlock = block;
}
-(void)vscCustomButton:(VscButtonBlock)block{
    _btnTempBlock = block;
}
-(void)show{
    _mySelf = self;
    _alertBlock = _alertTempBlock;
    _btnBlock  = _btnTempBlock;
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
#pragma mark - TableView
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    VscItem *item = items[indexPath.row];
    if (item.height == 0) {
        CGFloat height = [item.title boundingRectWithSize:CGSizeMake(backgroundView.frame.size.width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18]} context:NULL].size.height + 21;
        if (height > 44) {
            item.height = height;
        }else{
            item.height = 44;
        }
    }
    return item.height;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return items.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VscButton *cell = [tableView dequeueReusableCellWithIdentifier:myId];
    [cell defaultStyle];
    cell.text = items[indexPath.row].title;
    if (self.dataSource) {
        cell = [self.dataSource vsc_alertView:self buttonNeedToResign:cell buttonIndex:indexPath.row];
    }
    if (self.btnBlock) {
        cell = self.btnBlock(cell,indexPath.row);
    }
    return cell;
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
