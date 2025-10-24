//
//  TTSquareTableViewCell.m
//  TuTu
//
//  Created by gzlx on 2018/11/1.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTSquareTableViewCell.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "UIImageView+QiNiu.h"
#import "NSString+Utils.h"

@interface TTSquareTableViewCell ()
/** 前三名之后的*/
@property (nonatomic, strong) UILabel * rankLabel;
/** 家族排名*/
@property (nonatomic, strong) UIButton * rankButton;
/** 家族的y头像*/
@property (nonatomic, strong) UIImageView * logoImageView;
/** 家族名字*/
@property (nonatomic, strong) UILabel * familyNameLabel;
/** 家族id*/
@property (nonatomic, strong) UILabel * familyIdLabel;
/** 距离上一名*/
@property (nonatomic, strong) UILabel * subtileLabel;
/** 魅力值*/
@property (nonatomic, strong) UILabel * charmLabel;
/** 查看更多*/
@property (nonatomic, strong) UIButton * moreButton;
/** 分割线*/
@property (nonatomic, strong) UIView * sepView;
/** 箭头*/
@property (nonatomic, strong) UIButton * arrowButton;
@end


@implementation TTSquareTableViewCell

#pragma mark - life cycle
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
        [self initContrations];
    }
    return self;
}

#pragma mark - response
- (void)moreButtonAction:(UIButton*)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(squareCellMoreButtonAction:)]) {
        [self.delegate squareCellMoreButtonAction:sender];
    }
}

#pragma mark - public method
- (void)configTTSquareTableViewCellWith:(XCFamilyModel *)familyModel{
    [self.logoImageView qn_setImageImageWithUrl:familyModel.icon placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeHomePageItem];
    if (familyModel.name) {
        self.familyNameLabel.text = familyModel.name;
    }else{
        self.familyNameLabel.text = @"";
    }
    NSString * familyStr = [NSString stringWithFormat:@"家族ID：%@", familyModel.id];
    self.familyIdLabel.text = familyStr;
    NSString * charmNumber =[NSString changeAsset: [NSString stringWithFormat:@"%.2f", familyModel.gapNumber]];
    NSInteger row = self.indexPath.row;
    if (row>= 0) {
        if (row == 0) {
            self.rankLabel.hidden = YES;
            self.rankButton.hidden = NO;
            [self.rankButton setImage:[UIImage imageNamed:@"family_rank_first"] forState:UIControlStateNormal];
        }else if (row == 1){
            self.rankLabel.hidden = YES;
            self.rankButton.hidden = NO;
            [self.rankButton setImage:[UIImage imageNamed:@"family_rank_second"] forState:UIControlStateNormal];
        }else if (row ==2){
            self.rankLabel.hidden = YES;
            self.rankButton.hidden = NO;
            [self.rankButton setImage:[UIImage imageNamed:@"family_rank_third"] forState:UIControlStateNormal];
        }else{
            self.rankLabel.hidden = NO;
            self.rankButton.hidden = YES;
            self.rankLabel.text = [NSString stringWithFormat:@"%ld", row +1];
        }
    }
    if (self.isFamilyList) {
        self.moreButton.hidden = YES;
    }else{
        if (self.totalFamily > 6) {
            if (self.indexPath.row == 5) {
                self.moreButton.hidden = NO;
            }else{
                self.moreButton.hidden = YES;;
            }
        }else{
            self.moreButton.hidden = YES;
        }
    }
    
    [self updateaTTFamilygapNumber:charmNumber];
}




- (void)updateaTTFamilygapNumber:(NSString *)charmNumber{
    if (self.indexPath.row == 0) {
        self.subtileLabel.hidden = YES;
        self.charmLabel.font = [UIFont systemFontOfSize:15];
        self.charmLabel.text = @"No.1";
        [self.charmLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.right.mas_equalTo(self.arrowButton.mas_left).offset(-5);
        }];
    }else{
        self.subtileLabel.hidden = NO;
        self.charmLabel.font = [UIFont systemFontOfSize:14];
        self.charmLabel.text = charmNumber;
        [self.charmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.subtileLabel.mas_bottom).offset(2);
            make.right.mas_equalTo(self.arrowButton.mas_left).offset(-5);
        }];
    }
}

#pragma mark - private method
- (void)initView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.rankButton];
    [self.contentView addSubview:self.rankLabel];
    [self.contentView addSubview:self.logoImageView];
    [self.contentView addSubview:self.familyNameLabel];
    [self.contentView addSubview:self.familyIdLabel];
    [self.contentView addSubview:self.subtileLabel];
    [self.contentView addSubview:self.charmLabel];
    [self.contentView addSubview:self.moreButton];
    [self.contentView addSubview:self.arrowButton];
    [self.contentView addSubview:self.sepView];
}

- (void)initContrations{
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(@(50));
        make.top.mas_equalTo(self.contentView.mas_top).offset(11);
        make.left.mas_equalTo(self.rankButton.mas_right).offset(15);
    }];
    
    [self.rankButton  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
        make.left.mas_equalTo(self.contentView).offset(15);
        make.centerY.mas_equalTo(self.logoImageView.mas_centerY);
    }];
    
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.rankButton);
    }];
    
    [self.familyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.logoImageView.mas_right).offset(10);
        make.right.mas_equalTo(self).offset(-90);
        make.top.mas_equalTo(self.logoImageView.mas_top).offset(7);
    }];
    
    [self.familyIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.familyNameLabel.mas_left);
        make.right.mas_equalTo(self).offset(-55);
        make.top.mas_equalTo(self.familyNameLabel.mas_bottom).offset(8);
    }];
    
    
    [self.subtileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(23);
        make.right.mas_equalTo(self.contentView).offset(-25);
    }];
    
    
    [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.mas_equalTo(self.contentView).offset(15);
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.bottom.mas_equalTo(self.contentView);
    }];
    
    [self.arrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(11);
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.centerY.mas_equalTo(self.logoImageView);
    }];
    
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(15);
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.height.mas_equalTo(@(35));
        make.bottom.mas_equalTo(self.contentView).offset(-14);
    }];
}

#pragma mark - setters and getters
- (UIImageView *)logoImageView{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.layer.masksToBounds= YES;
        _logoImageView.layer.cornerRadius = 5;
    }
    return _logoImageView;
}

- (UIButton *)rankButton{
    if (_rankButton == nil) {
        _rankButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _rankButton;
}

- (UILabel *)rankLabel{
    if (!_rankLabel) {
        _rankLabel = [[UILabel alloc] init];
        _rankLabel.textColor = UIColorFromRGB(0x1a1a1a);
        _rankLabel.font = [UIFont systemFontOfSize:13];
        _rankLabel.textAlignment = NSTextAlignmentCenter;
        _rankLabel.layer.masksToBounds = YES;
        _rankLabel.backgroundColor = UIColorFromRGB(0xe6e6e6);
        _rankLabel.layer.cornerRadius = 10;
    }
    return _rankLabel;
}

- (UILabel *)familyNameLabel{
    if (!_familyNameLabel) {
        _familyNameLabel = [[UILabel alloc] init];
        _familyNameLabel.textColor = [XCTheme getTTMainTextColor];
        _familyNameLabel.font = [UIFont systemFontOfSize:12];
        _familyNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _familyNameLabel;
}

- (UILabel *)familyIdLabel{
    if (!_familyIdLabel) {
        _familyIdLabel = [[UILabel alloc] init];
        _familyIdLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _familyIdLabel.font = [UIFont systemFontOfSize:12];
        _familyIdLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _familyIdLabel;
}

- (UILabel *)subtileLabel{
    if (!_subtileLabel) {
        _subtileLabel = [[UILabel alloc] init];
        _subtileLabel.textColor = UIColorFromRGB(0x999999);
        _subtileLabel.font = [UIFont systemFontOfSize:12];
        _subtileLabel.textAlignment = NSTextAlignmentRight;
        _subtileLabel.text = @"距离上一名";
    }
    return _subtileLabel;
}

- (UIView *)sepView{
    if (!_sepView) {
        _sepView = [[UIView alloc] init];
        _sepView.backgroundColor = [XCTheme getTTSimpleGrayColor];
    }
    return _sepView;
}

- (UIButton *)arrowButton{
    if (!_arrowButton) {
        _arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_arrowButton setImage:[UIImage imageNamed:@"discover_family_arrow"] forState:UIControlStateNormal];
    }
    return _arrowButton;
}

- (UILabel *)charmLabel{
    if (!_charmLabel) {
        _charmLabel = [[UILabel alloc] init];
        _charmLabel.textColor  =  [XCTheme getTTMainColor];
        _charmLabel.font = [UIFont systemFontOfSize:15];
        _charmLabel.textAlignment = NSTextAlignmentRight;
    }
    return _charmLabel;
}


- (UIButton *)moreButton{
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setTitle:@"查看更多" forState:UIControlStateNormal];
        [_moreButton setTitleColor:[XCTheme getTTSubTextColor] forState:UIControlStateNormal];
        _moreButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _moreButton.backgroundColor = UIColorFromRGB(0xeeeeee);
        _moreButton.hidden = YES;
        _moreButton.layer.masksToBounds = YES;
        _moreButton.layer.cornerRadius = 35 /2;
        [_moreButton addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
