//
//  TTPersonGroupTableViewCell.m
//  TuTu
//
//  Created by gzlx on 2018/11/3.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTPersonGroupTableViewCell.h"
#import <Masonry/Masonry.h>
#import "UIButton+EnlargeTouchArea.h"
#import "XCTheme.h"
#import "UIImageView+QiNiu.h"

@interface TTPersonGroupTableViewCell()
/** 群头像*/
@property (nonatomic, strong) UIImageView * logoImageView;
/** 群名称*/
@property (nonatomic, strong) UILabel * nameLabel;
/** 群人数*/
@property (nonatomic, strong) UILabel * numberPersonLabel;
/**家入的button*/
@property (nonatomic, strong) UIButton * enterButton;
@property (nonatomic, strong) UIView * sepView;
@property (nonatomic, strong) XCFamilyModel * group;
@end

@implementation TTPersonGroupTableViewCell
#pragma mark - life cycle
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
        [self initContrations];
    }
    return self;
}
#pragma mark - reponse
- (void)enterFamilyGroupAction:(UIButton*)sender{
    if (self.group) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(enterFamilyGroupWithFamilyModel:)]) {
            [self.delegate enterFamilyGroupWithFamilyModel:self.group];
        }
    }
}

#pragma mark - public method
- (void)configTTPersonGroupTableViewCellWithfamilyModel:(XCFamilyModel *)family{
    if (family) {
       self.group = family;
        if (family.isExists) {
            self.enterButton.hidden = YES;
        }else{
            self.enterButton.hidden = NO;
        }
        [self.logoImageView qn_setImageImageWithUrl:family.icon placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeHomePageItem];
        self.nameLabel.text = family.name;
        self.numberPersonLabel.text = [NSString stringWithFormat:@"成员：%d", family.memberCount];
    }
}

#pragma mark - private method
- (void)initView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.logoImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.numberPersonLabel];
    [self.contentView addSubview:self.sepView];
    [self.contentView addSubview:self.enterButton];
}

- (void)initContrations{
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.left.mas_equalTo(self.contentView).offset(15);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.logoImageView.mas_right).offset(13);
        make.top.mas_equalTo(self.logoImageView.mas_top).offset(6);
        make.right.mas_equalTo(self.enterButton.mas_left).offset(-5);
    }];
    
    [self.numberPersonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(10);
    }];
    
    [self.enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(53);
        make.height.mas_equalTo(25);
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(15);
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - setters and getters
- (UIImageView *)logoImageView{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.layer.masksToBounds = YES;
        _logoImageView.layer.cornerRadius = 5;
    }
    return _logoImageView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor  = UIColorFromRGB(0x1a1a1a);
        _nameLabel.font = [UIFont systemFontOfSize:15];
    }
    return _nameLabel;
}

- (UILabel *)numberPersonLabel{
    if (!_numberPersonLabel) {
        _numberPersonLabel = [[UILabel alloc] init];
        _numberPersonLabel.textColor  = [XCTheme getTTDeepGrayTextColor];
        _numberPersonLabel.font = [UIFont systemFontOfSize:12];
    }
    return _numberPersonLabel;
}

- (UIButton *)enterButton{
    if (!_enterButton) {
        _enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_enterButton setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        [_enterButton setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateSelected];
        [_enterButton setTitle:@"加入" forState:UIControlStateSelected];
        [_enterButton setTitle:@"加入" forState:UIControlStateNormal];
        _enterButton.titleLabel.font =[UIFont systemFontOfSize:13];
        [_enterButton setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
        _enterButton.layer.borderColor = [XCTheme getTTMainColor].CGColor;
        _enterButton.layer.borderWidth = 1;
        _enterButton.layer.masksToBounds = YES;
        _enterButton.layer.cornerRadius = 25/2;
        _enterButton.backgroundColor = [UIColor whiteColor];
        [_enterButton addTarget:self action:@selector(enterFamilyGroupAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterButton;
}

- (UIView *)sepView{
    if (!_sepView) {
        _sepView = [[UIView alloc] init];
        _sepView.backgroundColor = [XCTheme getTTSimpleGrayColor];
    }
    return _sepView;
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
