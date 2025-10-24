//
//  TTGuildGroupCollectionContentCell.m
//  TuTu
//
//  Created by lvjunhang on 2019/1/9.
//  Copyright © 2019年 YiZhuan. All rights reserved.
//

#import "TTGuildGroupCollectionContentCell.h"

#import <Masonry/Masonry.h>

#import "UIImageView+QiNiu.h"
#import "XCTheme.h"
#import "TTHomeRecommendDetailData.h"

@interface TTGuildGroupCollectionContentCell ()

@property (nonatomic, strong) UIImageView *coverImageView;

@end

@implementation TTGuildGroupCollectionContentCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstraints];
    }
    return self;
}

- (void)initView {
    [self.contentView addSubview:self.coverImageView];
    
    self.coverImageView.backgroundColor = UIColor.grayColor;
}

- (void)initConstraints {
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - Getter Setter
- (void)setModel:(NSString *)model {
    _model = model;
    if (![model isKindOfClass:[NSNull class]]) {
        [self.coverImageView qn_setImageImageWithUrl:model placeholderImage:[XCTheme defaultTheme].default_avatar type:ImageTypeHomePageItem];
    }
}

- (UIImageView *)coverImageView {
    if (_coverImageView == nil) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.image = [UIImage imageNamed:[[XCTheme defaultTheme] default_avatar]];
        _coverImageView.layer.masksToBounds = YES;
        _coverImageView.layer.cornerRadius = CGRectGetWidth(self.contentView.frame)/2;
    }
    return _coverImageView;
}

@end
