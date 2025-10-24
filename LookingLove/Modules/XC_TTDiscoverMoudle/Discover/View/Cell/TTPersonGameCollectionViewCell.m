//
//  TTPersonGameCollectionViewCell.m
//  TuTu
//
//  Created by gzlx on 2018/11/3.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTPersonGameCollectionViewCell.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "UIImageView+QiNiu.h"

@interface TTPersonGameCollectionViewCell ()
//标题
@property (nonatomic, strong) UILabel * titleLabel;
/** 头像*/
@property (nonatomic, strong) UIImageView * iconImageView;
/**族长的标签 */
@property (nonatomic, strong) UIImageView * patriaImageView;

@end

@implementation TTPersonGameCollectionViewCell
#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame{
    if (self= [super initWithFrame:frame]) {
        [self initView];
        [self initContrations];
    }
    return self;
}

#pragma mark - public  method
- (void)configpPersonGanmeCellWithFamilyModel:(XCFamilyModel *)game{
    if (game) {
        [self.iconImageView qn_setImageImageWithUrl:game.icon placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeHomePageItem];
        self.titleLabel.text = game.name;
        self.iconImageView.layer.cornerRadius = 5;
        self.patriaImageView.hidden = YES;
        [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(70);
            make.top.mas_equalTo(self.contentView);
            make.centerX.mas_equalTo(self.contentView);
        }];
    
       
    }
   
}

- (void)configpPersonMemberCellWithFamilyModel:(XCFamilyModel *)member{
    if (member) {
        [self.iconImageView qn_setImageImageWithUrl:member.icon placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeHomePageItem];
        self.titleLabel.text = member.name;
        if ([member.position integerValue] == FamilyMemberPositionOwen) {
            self.patriaImageView.hidden = NO;
        }else{
            self.patriaImageView.hidden = YES;
        }
        _iconImageView.layer.cornerRadius = 25;
        [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(50);
            make.top.left.mas_equalTo(self.contentView);
        }];
    }
}

#pragma mak - private method
- (void)initView{
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.patriaImageView];
    [self.contentView addSubview:self.titleLabel];
}

- (void)initContrations{
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(70);
        make.top.mas_equalTo(self.contentView);
        make.centerX.mas_equalTo(self.contentView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(7);
    }];
    
    [self.patriaImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.mas_equalTo(self.iconImageView);
        make.width.mas_equalTo(36);
        make.height.mas_equalTo(15);
    }];
}

#pragma mark - setters and getters
- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.layer.masksToBounds = YES;
    }
    return _iconImageView;
}

- (UIImageView *)patriaImageView{
    if (!_patriaImageView) {
        _patriaImageView = [[UIImageView alloc] init];
        _patriaImageView.image = [UIImage imageNamed:@"family_person_patria"];
    }
    return _patriaImageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor  =  [XCTheme getTTSubTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
