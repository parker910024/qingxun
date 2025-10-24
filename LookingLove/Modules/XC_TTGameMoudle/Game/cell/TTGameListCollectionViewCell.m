//
//  TTGameListCollectionViewCell.m
//  TuTu
//
//  Created by new on 2019/1/21.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGameListCollectionViewCell.h"
#import "UIColor+UIColor_Hex.h" // 颜色设置
#import "CPGameListModel.h"

#import "NSArray+Safe.h"
#import <Masonry/Masonry.h> // 约束
#import "XCMacros.h" // 约束的宏定义
#import "UIImageView+QiNiu.h"  // 加载图片
#import "XCTheme.h" // 颜色设置的宏定义
#import <YYText.h>

@interface TTGameListCollectionViewCell()
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *tagImageView;
@property (nonatomic, strong) UIButton *moreGameButton;
@end

@implementation TTGameListCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.backImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.tagImageView];
        [self.contentView addSubview:self.moreGameButton];
        [self initConstrations];
    }
    return self;
}
- (void)initConstrations{
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-12);
        make.height.mas_equalTo(15);
        make.centerX.mas_equalTo(self.backImageView);
    }];
    
    [self.tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(6.5);
        make.size.mas_equalTo(CGSizeMake(32, 16));
    }];
    
    [self.moreGameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
}

- (void)configCompleteGameData:(NSArray *)array WithIndexPath:(NSInteger )row{
    if (row == 0) {
        self.backImageView.image = [UIImage imageNamed:@"game_findFriendGame"];
        
        self.titleLabel.hidden = YES;

        self.tagImageView.hidden = YES;
    }else{
    
        CPGameListModel *model = [array safeObjectAtIndex:row - 1];
        [self.backImageView qn_setImageImageWithUrl:model.gameIcon placeholderImage:@"game_home_itemBg" type:(ImageType)ImageTypeHomePageItem];
        self.titleLabel.hidden = NO;
        self.titleLabel.text = model.gameName;
        
        self.tagImageView.hidden = YES;
        
        if (model.tagIcon.length > 0) {
            _tagImageView.hidden = NO;
            [_tagImageView qn_setImageImageWithUrl:model.tagIcon placeholderImage:@"home_game_new" type:(ImageType)ImageTypeHomePageItem];
        }
    }
}

- (void)configData:(NSArray *)array WithIndexPath:(NSInteger )row{
    
    self.backImageView.hidden = NO;
    
    self.moreGameButton.hidden = YES;
    
    CPGameListModel *model = [array safeObjectAtIndex:row];
    [self.backImageView qn_setImageImageWithUrl:model.gameIcon placeholderImage:@"game_home_itemBg" type:(ImageType)ImageTypeHomePageItem];
    
    self.titleLabel.text = model.gameName;
    
    self.tagImageView.hidden = YES;
    
    if (array.count >= 7) {
        if (row == 6) {
            self.backImageView.hidden = YES;
            
            self.moreGameButton.hidden = NO;
            
            self.tagImageView.hidden = YES;
        }
    }
    if (model.tagIcon.length > 0) {
        _tagImageView.hidden = NO;
        [_tagImageView qn_setImageImageWithUrl:model.tagIcon placeholderImage:@"home_game_new" type:(ImageType)ImageTypeHomePageItem];
    }
}

- (void)configWelfDataModel:(CPGameHomeBannerModel *)model{
    
    [self.backImageView qn_setImageImageWithUrl:model.bannerPic placeholderImage:@"game_home_itemBg" type:(ImageType)ImageTypeHomePageItem];
    
    self.titleLabel.text = model.bannerName;
    
    self.tagImageView.hidden = YES;
}

- (void)moreGameBtnClickAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(moreGameBtnClickAction)]) {
        [self.delegate moreGameBtnClickAction];
    }
}

-(UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.layer.cornerRadius = 16;
        _backImageView.layer.masksToBounds = YES;
    }
    return _backImageView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

- (UIButton *)moreGameButton{
    if (!_moreGameButton) {
        _moreGameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreGameButton.backgroundColor = UIColorFromRGB(0xFEF5ED);
        [_moreGameButton setTitle:@"更多\n游戏" forState:UIControlStateNormal];
        [_moreGameButton setTitleColor:UIColorFromRGB(0xFFB606) forState:UIControlStateNormal];
        _moreGameButton.titleLabel.font = [UIFont systemFontOfSize:18];
        _moreGameButton.titleLabel.numberOfLines = 0;
        _moreGameButton.layer.cornerRadius = 16;
        _moreGameButton.layer.masksToBounds = YES;
        _moreGameButton.hidden = YES;
        [_moreGameButton addTarget:self action:@selector(moreGameBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreGameButton;
}

-(UIImageView *)tagImageView{
    if (!_tagImageView) {
        _tagImageView = [[UIImageView alloc] init];
        _tagImageView.hidden = YES;
    }
    return _tagImageView;
}

@end
