//
//  TTGameApproveCollectionViewCell.m
//  TTPlay
//
//  Created by new on 2019/3/26.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGameApproveCollectionViewCell.h"
#import <Masonry/Masonry.h> // 约束
#import "XCMacros.h" // 约束的宏定义
#import "UIImageView+QiNiu.h"  // 加载图片
#import "XCTheme.h" // 颜色设置的宏定义

@interface TTGameApproveCollectionViewCell ()

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UILabel *cardUseLabel;

@end

@implementation TTGameApproveCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = UIColorRGBAlpha(0xffffff, 1);
        
        [self initView];
        
        [self initConstraint];
    }
    return self;
}

- (void)setListModel:(CertificationSkillListModel *)listModel{
    
    [self.backImageView qn_setImageImageWithUrl:listModel.skillPicture placeholderImage:[XCTheme defaultTheme].placeholder_image_square type:(ImageType)ImageTypeHomePageItem];
    
    if (listModel.hasUse == 1) {
        self.cardUseLabel.hidden = NO;
    }else{
        self.cardUseLabel.hidden = YES;
    }
}


- (void)initView{
    [self.contentView addSubview:self.backImageView];
    
    [self.contentView addSubview:self.cardUseLabel];
}

- (void)initConstraint{
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    [self.cardUseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(43, 18));
    }];
    
}

- (UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
    }
    return _backImageView;
}

- (UILabel *)cardUseLabel{
    if (!_cardUseLabel) {
        _cardUseLabel = [[UILabel alloc] init];
        _cardUseLabel.text = @"使用中";
        _cardUseLabel.textColor = UIColor.whiteColor;
        _cardUseLabel.backgroundColor = [XCTheme getTTMainColor];
        _cardUseLabel.font = [UIFont systemFontOfSize:10];
        _cardUseLabel.layer.cornerRadius = 7.5;
        _cardUseLabel.layer.masksToBounds = YES;
        _cardUseLabel.textAlignment = NSTextAlignmentCenter;
        _cardUseLabel.layer.borderWidth = 1.5;
        _cardUseLabel.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;
        _cardUseLabel.hidden = YES;
    }
    return _cardUseLabel;
}
@end
