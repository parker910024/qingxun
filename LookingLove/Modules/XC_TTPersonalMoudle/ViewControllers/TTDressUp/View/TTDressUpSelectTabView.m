//
//  TTDressUpSelectTabView.m
//  TuTu
//
//  Created by Macx on 2018/10/29.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTDressUpSelectTabView.h"

//t
#import "XCTheme.h"
#import <Masonry/Masonry.h>
//cate
#import "UIView+ZJFrame.h"

NSInteger const button_tag = 200;

@interface TTDressUpSelectTabView()

@property (nonatomic, strong) UIView  *buttonContainView;// the button ContaintView
@property (nonatomic, strong) NSArray  *titlesArray;// a Array contain titles

@property (nonatomic, strong) UIView  *lineContainView;// scroll line Contain
@property (nonatomic, strong) UIView  *lineView;//scroll line

@property (nonatomic, strong) NSMutableArray  *buttonArray;//
@property (nonatomic, strong) UIButton *selectedBtn;

@end

@implementation TTDressUpSelectTabView

- (instancetype)initWithFrame:(CGRect)frame  titles:(NSArray *)titles {
    
    if (self = [super initWithFrame:frame]) {
        self.titlesArray = titles;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    [self addSubview:self.buttonContainView];
    [self addSubview:self.lineContainView];
    [self.lineContainView addSubview:self.lineView];
    
    CGFloat width = self.zj_width / self.titlesArray.count;
    for (int i = 0; i < self.titlesArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:self.titlesArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateSelected];
        [button setTitleColor:[XCTheme getTTDeepGrayTextColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onClickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(i * width, 0, width, self.zj_height);
        button.tag = button_tag + i;
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        
        [self addSubview:button];
        [self.buttonArray addObject:button];
        
        if (i == 0) { // 默认选中第一个
            self.selectedBtn = button;
        }
    }
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.buttonContainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [self.lineContainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(3);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(3);
        make.width.mas_equalTo(16);
        make.bottom.mas_equalTo(self.lineContainView);
        make.centerX.mas_equalTo(self.selectedBtn); // 默认是选中第一个，居中显示
    }];
}

#pragma mark - Event

- (void)onClickButtonAction:(UIButton *)btn {
    [self updateIndex:btn needBlock:YES];
}

- (void)updateIndex:(UIButton *)btn needBlock:(BOOL)needBlock {
    for (UIButton *button in self.buttonArray) {
        button.selected = NO;
    }
    
    btn.selected = YES;
    if (needBlock) {
        !self.selectBlock ?: self.selectBlock(btn.tag - button_tag);
    }
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(3);
        make.width.mas_equalTo(16);
        make.bottom.mas_equalTo(self.lineContainView).inset(5);
        make.centerX.mas_equalTo(btn);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.lineContainView layoutIfNeeded];
    }];
}

#pragma mark - Setter && Getter

- (void)setTitlesArray:(NSArray *)titlesArray {
    _titlesArray = titlesArray;
}

- (void)setIndex:(int)index {
    _index = index;
    UIButton *btn = self.buttonArray[index];
  [self updateIndex:btn needBlock:NO];
}

- (UIView *)buttonContainView {
    if (!_buttonContainView) {
        _buttonContainView = [[UIView alloc] init];
    }
    return _buttonContainView;
}

- (UIView *)lineContainView {
    if (!_lineContainView) {
        _lineContainView = [[UIView alloc] init];
    }
    return _lineContainView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [XCTheme getTTMainColor];
        _lineView.layer.cornerRadius = 1.5;
        _lineView.layer.masksToBounds = YES;
    }
    return _lineView;
}

- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = @[].mutableCopy;
    }
    return _buttonArray;
}

@end
