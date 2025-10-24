//
//  TTFamilyMonSearchView.m
//  TuTu
//
//  Created by gzlx on 2018/11/5.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFamilyMonSearchView.h"
#import <YYLabel.h>
#import <Masonry/Masonry.h>
#import "TTFamilyAttributedString.h"
@interface TTFamilyMonSearchView()
@property (nonatomic, strong) UIView * bakcView;
@property (nonatomic, strong) YYLabel * searchLabel;
@end

@implementation TTFamilyMonSearchView

#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initContrations];
    }
    return self;
}
#pragma mark - private method
- (void)initView{
    [self addSubview:self.bakcView];
    [self addSubview:self.searchLabel];
}

- (void)initContrations{
    [self.bakcView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(15);
        make.right.mas_equalTo(self).offset(-15);
        make.top.mas_equalTo(self).offset(14);
        make.height.mas_equalTo(35);
    }];
    
    [self.searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.bakcView);
    }];
    
    self.searchLabel.attributedText = [TTFamilyAttributedString createFamilySearchAttributedString];
    self.searchLabel.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - setters and getters
- (UIView *)bakcView{
    if (!_bakcView) {
        _bakcView = [[UIView alloc] init];
        _bakcView.layer.cornerRadius = 35/ 2;
        _bakcView.layer.masksToBounds= YES;
        _bakcView.backgroundColor = [UIColor whiteColor];
    }
    return _bakcView;
}

- (YYLabel *)searchLabel{
    if (!_searchLabel) {
        _searchLabel = [[YYLabel alloc] init];
    }
    return _searchLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
