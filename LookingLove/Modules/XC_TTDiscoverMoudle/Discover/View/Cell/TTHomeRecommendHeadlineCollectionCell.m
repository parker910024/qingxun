//
//  TTHeadlineCollectionViewCell.m
//  TuTu
//
//  Created by lvjunhang on 2018/10/30.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTHomeRecommendHeadlineCollectionCell.h"
#import "BaseAttrbutedStringHandler+Discover.h"
#import "HomebaseModel.h"

#import <YYLabel.h>
#import <YYText.h>
#import <Masonry/Masonry.h>

#import "BaseAttrbutedStringHandler.h"
#import "NSArray+Safe.h"
#import "XCMacros.h"
#import "UIImageView+QiNiu.h"
#import "XCTheme.h"
#import "TTHomeRecommendDetailData.h"
#import "DiscoveryHeadLineNews.h"

@interface TTHomeRecommendHeadlineCollectionCell ()
@property (nonatomic, strong) YYLabel *topLabel;//显示最新的头条
@property (nonatomic, strong) YYLabel *downLable;//关于我的头条
@property (nonatomic, strong) UIImageView *rightImageView;//右边的logo
@end

@implementation TTHomeRecommendHeadlineCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self setUpConstraints];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)initView {
    [self addSubview:self.topLabel];
    [self addSubview:self.downLable];
    [self addSubview:self.rightImageView];
}

- (void)setUpConstraints {
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(6);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.mas_right).offset(-15);
    }];

    [self.downLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topLabel.mas_bottom);
        make.left.right.height.mas_equalTo(self.topLabel);
        make.bottom.mas_equalTo(-6);
    }];
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(48);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-15);
    }];
}

- (void)setModelArray:(NSArray *)modelArray {
    _modelArray = modelArray;
    
    if (_modelArray.count == 0) {
        return;
    }
    
    DiscoveryHeadLineNews *model = [_modelArray safeObjectAtIndex:0];
    DiscoveryHeadLineNews *downModel = [_modelArray safeObjectAtIndex:1];
    
    CGFloat maxWidht;
    CGFloat width = 0;//千寻和别的项目不同
    if (projectType() == ProjectType_LookingLove || projectType() == ProjectType_Planet) {
        width = 40;
    }
    
    if (model.img.length == 0 && downModel.img.length == 0) {
        
        maxWidht = KScreenWidth - 78 - width;
        self.rightImageView.image = [UIImage imageNamed:[[XCTheme defaultTheme] default_empty]];
        self.rightImageView.hidden = YES;
    } else {
        self.rightImageView.hidden = NO;
        maxWidht =KScreenWidth - 136 - width;
    }
    
    if (model != nil) {
        self.topLabel.attributedText = [BaseAttrbutedStringHandler newHeadLineWith:model withMaxWidht:maxWidht];
        if (model.img.length > 0) {
          [self.rightImageView qn_setImageImageWithUrl:model.img placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeHomePageItem];
        }
    }
    
    if (downModel != nil) {
        if (model.img.length == 0) {
            if (downModel.img.length > 0) {
                [self.rightImageView qn_setImageImageWithUrl:downModel.img placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeHomePageItem];
            }
        }
        self.downLable.attributedText = [BaseAttrbutedStringHandler newHeadLineWith:downModel withMaxWidht:maxWidht];
    }
}

- (YYLabel *)topLabel {
    if (_topLabel == nil) {
        _topLabel = [[YYLabel alloc] init];
        _topLabel.userInteractionEnabled = YES;
    }
    return _topLabel;
}

- (YYLabel *)downLable {
    if (_downLable == nil) {
        _downLable = [[YYLabel alloc] init];
        _downLable.userInteractionEnabled = YES;
    }
    return _downLable;
}

- (UIImageView *)rightImageView {
    if (_rightImageView == nil) {
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.userInteractionEnabled = YES;
        _rightImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _rightImageView;
}

@end
