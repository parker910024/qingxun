//
//  KEMenuItemTool.m
//  LTChat
//
//  Created by apple on 2019/8/3.
//  Copyright © 2019 wujie. All rights reserved.
//

#import "KEMenuItemTool.h"
#import "XCMacros.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"

@interface KEMenuItem ()
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@end

@implementation KEMenuItem

- (instancetype)initWithFrame:(CGRect)frame iconName:(NSString *)iconName text:(NSString *)text {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self initConstraints];
        _iconImageView.image = [UIImage imageNamed:iconName];
        _textLabel.text = text;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClickTap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)initViews {
    [self addSubview:self.textLabel];
    [self addSubview:self.iconImageView];
}

- (void)initConstraints {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(9);
        make.width.height.mas_equalTo(22);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(5);
    }];
}

- (void)itemClickTap:(UITapGestureRecognizer *)tap {
    !_itemClickBlock ? : _itemClickBlock(self.tag);
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = UIColorFromRGB(0xAFAFB2);
        _textLabel.font = [UIFont systemFontOfSize:12];
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}
@end


@interface KEMenuItemTool()

@property (nonatomic, copy) void (^completeBlock)(void);

@property (nonatomic, copy) void (^completeTypeBlock)(KEMenuItemToolType type);

@property (nonatomic, strong) UIButton *menuBtn;

@end

@implementation KEMenuItemTool


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFromSuperview)];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:tap];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
    }
    return self;
}
- (void)showRightMoreButton:(UIButton *)tagetBtn title:(NSString *)title complete:(void(^)(void))completeBlock{
    [self.menuBtn setBackgroundImage:[UIImage imageNamed:@"dynacmic_more_right_bg"] forState:UIControlStateNormal];
    [self.menuBtn setTitle:title forState:UIControlStateNormal];
    self.menuBtn.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 0);
    _menuBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    CGRect rect = [tagetBtn.superview convertRect:tagetBtn.frame toView:[UIApplication sharedApplication].keyWindow];
    self.menuBtn.frame = CGRectMake(rect.origin.x+rect.size.width/2-65, CGRectGetMaxY(rect)-11, 65, 40);
    self.completeBlock = completeBlock;
    if (!self.menuBtn.superview) {
        [self addSubview:self.menuBtn];
    }
}

- (void)showCenterMoreView:(UIView *)tagetView title:(NSString *)title complete:(void(^)(void))completeBlock{

    [self.menuBtn setBackgroundImage:[UIImage imageNamed:@"dynacmic_more_center_bg"] forState:UIControlStateNormal];
    [self.menuBtn setTitle:title forState:UIControlStateNormal];
    _menuBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.menuBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 5, 0);
    CGRect rect = [tagetView.superview convertRect:tagetView.frame toView:[UIApplication sharedApplication].keyWindow];
    self.menuBtn.frame = CGRectMake(rect.origin.x+rect.size.width/2-32, CGRectGetMinY(rect)-40, 65, 40);
    self.completeBlock = completeBlock;
    if (!self.menuBtn.superview) {
        [self addSubview:self.menuBtn];
    }
}

- (void)moreSubBtnClick:(UIButton*)btn{
   
    if (self.completeBlock) {
        self.completeBlock();
    }
    [self removeFromSuperview];
}

/**
 举报和删除和复制
 */
- (void)showMoreTypeView:(UIView *)tagetView actionNames:(NSArray<NSDictionary *> *)actionNames complete:(void(^)(KEMenuItemToolType type))completeTypeBlock {
    CGRect rect = [tagetView.superview convertRect:tagetView.frame toView:[UIApplication sharedApplication].keyWindow];

    CGFloat width = actionNames.count > 2 ? 210 : 150;
    NSString *bgImageName = actionNames.count > 2 ? @"dynamic_menu_more_bg" : @"dynamic_menu_normal_bg";
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(rect.size.width/2, CGRectGetMinY(rect)-65, width, 80)];
    bgView.layer.contents = (__bridge id _Nullable)([[UIImageView alloc] initWithImage:[UIImage imageNamed:bgImageName]].image.CGImage);
    
    [actionNames enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat h = 50;
        CGFloat w = 70;
        CGFloat x = idx * w;
        KEMenuItem *item = [[KEMenuItem alloc] initWithFrame:CGRectMake(x, 6, w, h) iconName:obj[kItemIconKey] text:obj[kItemTextKey]];
        item.tag = [obj[kItemTypeKey] integerValue];
        item.itemClickBlock = ^(NSInteger tagType) {
            completeTypeBlock((KEMenuItemToolType)tagType);
            [self removeFromSuperview];
        };
        [bgView addSubview:item];
    }];
    
//    self.completeTypeBlock  = completeTypeBlock;
    if (!bgView.superview) {
        [self addSubview:bgView];
    }
}

////用于举报和c删除
//- (void)showMoreTypeView:(UIView *)tagetView title:(NSString *)title secondTitle:(NSString *)secondTitle complete:(void(^)(KEMenuItemToolType type))completeTypeBlock{
//    self.completeTypeBlock = completeTypeBlock;
//    
//    UIImageView * imgBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dynacmic_more_double_bg"]];
//    CGRect rect = [tagetView.superview convertRect:tagetView.frame toView:KKeyWindow];
//    imgBg.frame = CGRectMake(rect.origin.x+rect.size.width/2-65, CGRectGetMinY(rect)-40, 65, 72);
//    imgBg.userInteractionEnabled = YES;
//    [self addSubview:imgBg];
//    
//    UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn1 setTitle:title forState:UIControlStateNormal];
//    [btn1 setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
//    btn1.frame = CGRectMake(0, 8, 65, 32);
//    btn1.tag = KEMenuItemToolTypeReport;
//    btn1.titleLabel.font = [UIFont systemFontOfSize:12];
//    [btn1 addTarget:self action:@selector(didMoreTypeClick:) forControlEvents:UIControlEventTouchUpInside];
//    [imgBg addSubview:btn1];
//    
//    
//    UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn2 setTitle:secondTitle forState:UIControlStateNormal];
//    [btn2 setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
//    btn2.frame = CGRectMake(0, btn1.bottom, 65, 32);
//    btn2.tag = KEMenuItemToolTypeDelete;
//    btn2.titleLabel.font = [UIFont systemFontOfSize:12];
//    [btn2 addTarget:self action:@selector(didMoreTypeClick:) forControlEvents:UIControlEventTouchUpInside];
//    [imgBg addSubview:btn2];
//    
//    
//    UIView * lineBg = [[UIView alloc] initWithFrame:CGRectMake(10, btn1.bottom, 44, 1)];
//    lineBg.backgroundColor = UIColorFromRGB(0x333333);
//    [imgBg addSubview:lineBg];
//}
//
//- (void)didMoreTypeClick:(UIButton *)btn{
//    if (self.completeTypeBlock) {
//        self.completeTypeBlock(btn.tag);
//    }
//    [self removeFromSuperview];
//}

- (UIButton *)menuBtn{
    if (!_menuBtn) {
        
        _menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_menuBtn setBackgroundImage:[UIImage imageNamed:@"dynacmic_more_right_bg"] forState:UIControlStateNormal];
        _menuBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_menuBtn addTarget:self action:@selector(moreSubBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _menuBtn;
}
@end
