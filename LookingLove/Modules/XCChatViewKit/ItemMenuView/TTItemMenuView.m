//
//  TTItemMenuView.m
//  TuTu
//
//  Created by 卫明 on 2018/11/6.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTItemMenuView.h"

//theme
#import "XCTheme.h"

//cell
#import "TTItemMenuCell.h"

//tool
#import "NSArray+Safe.h"

//consr
#import "XCMacros.h"

@interface TTItemMenuView ()
<
    UITableViewDelegate,
    UITableViewDataSource
>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray<TTItemMenuItem *> *items;

@property (strong, nonatomic) TTItemsMenuConfig *config;

@end



@implementation TTItemMenuView

- (instancetype)initWithFrame:(CGRect)frame withConfig:(TTItemsMenuConfig *)config items:(NSArray<TTItemMenuItem *>*)items {
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor clearColor];
        self.backgroundColor = UIColorRGBAlpha(0x000000, 0.5);
        self.config = config;
        self.items = items;
        [self initView];
        [self initConstrations];
    }
    return self;
}

- (void)initView {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:pan];
    
    [self addSubview:self.tableView];
    [self.tableView registerClass:[TTItemMenuCell class] forCellReuseIdentifier:@"TTItemMenuCell"];
    
}

- (void)initConstrations {
    
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        [self setAlpha:0.f];
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            [self setAlpha:1.f];
        }
    }];
}

- (BOOL)isShow {
    return self.superview != nil;
}
#pragma makr - public method
- (void)configMenuViewWithItems:(NSArray<TTItemMenuItem *> *)items{
    if (items) {
        self.items = items;
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TTItemMenuItem *item = [self.items safeObjectAtIndex:indexPath.row];
    item.indexPath = indexPath;
    if (self.itemSelectedAction) {
        self.itemSelectedAction(self, item);
    }
    if ([self.delegate respondsToSelector:@selector(menuView:didSelectedItem:)]) {
        [self.delegate menuView:self didSelectedItem:item];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self dismiss];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.config.itemHeight;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTItemMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TTItemMenuCell" forIndexPath:indexPath];
    [cell setBackgroundColor:self.config.backgroudColor?self.config.backgroudColor:[UIColor whiteColor]];
    [cell.contentView setBackgroundColor:self.config.backgroudColor?self.config.backgroudColor:[UIColor whiteColor]];
    [cell setItem:[self.items safeObjectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - private

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismiss];
}

- (void)drawRect:(CGRect)rect {
    CGFloat startX = self.frame.size.width - 30;
    CGFloat startY = statusbarHeight + 44 + 3;
    CGFloat endY   = statusbarHeight + 44 + 10;
    CGFloat width  = 6;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, startX, startY);
    CGContextAddLineToPoint(context, startX + width, endY);
    CGContextAddLineToPoint(context, startX - width, endY);
    CGContextClosePath(context);
    [self.config.backgroudColor setFill];
    [self.config.backgroudColor setStroke];
    CGContextDrawPath(context, kCGPathFillStroke);

}

- (void)showInView:(UIView *)view {
    [view addSubview:self];
    [self setNeedsDisplay];
    [self setFrame:view.bounds];
    
    CGRect rect = CGRectMake(view.frame.size.width - self.config.menuWidth - 5, statusbarHeight + 44 + 7, self.config.menuWidth, self.items.count * self.config.itemHeight);
    [self.tableView setFrame:rect];
}

#pragma mark - getter && setter

- (void)setCustomBackgroundColor:(UIColor *)customBackgroundColor {
    _customBackgroundColor = customBackgroundColor;
    self.backgroundColor = customBackgroundColor;
}

- (void)setIsShowMask:(BOOL)isShowMask {
    _isShowMask = isShowMask;
    if (!isShowMask) {
        self.backgroundColor = self.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    }
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.config.backgroudColor?self.config.backgroudColor:[UIColor whiteColor];
        _tableView.separatorColor = self.config.separatorColor?self.config.separatorColor:UIColorFromRGB(0xebebeb);
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.cornerRadius = 5.f;
    }
    return _tableView;
}
@end
