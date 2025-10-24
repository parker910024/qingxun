//
//  TTFamilyShareGroupTableViewCell.m
//  TuTu
//
//  Created by gzlx on 2018/11/19.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFamilyShareGroupTableViewCell.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "UIImageView+QiNiu.h"


@interface TTFamilyShareGroupTableViewCell ()
/** 群头像*/
@property (nonatomic, strong) UIImageView * avaratIamgeView;
/** 群名字*/
@property (nonatomic, strong) UILabel * groupNameLabel;
@property (nonatomic, strong) UIView * sepView;
@end

@implementation TTFamilyShareGroupTableViewCell

#pragma Mark- life cycle
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
        [self initContrations];
    }
    return self;
}
#pragma mark - public method
- (void)configShareGroupCellWith:(GroupModel *)group{
    if (group) {
        [self.avaratIamgeView qn_setImageImageWithUrl:group.icon placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeUserIcon];
        self.groupNameLabel.text = group.name.length > 0 ? group.name : @"";
    }
}
#pragma mark - private method
- (void)initView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.avaratIamgeView];
    [self.contentView addSubview:self.groupNameLabel];
    [self.contentView addSubview:self.sepView];
}

- (void)initContrations{
    [self.avaratIamgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(15);
    }];
    
    [self.groupNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avaratIamgeView.mas_right).offset(11);
        make.centerY.mas_equalTo(self.avaratIamgeView);
    }];
    
    [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(15);
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - setters and  getters
- (UILabel *)groupNameLabel{
    if (!_groupNameLabel) {
        _groupNameLabel = [[UILabel alloc] init];
        _groupNameLabel.textColor  = [XCTheme getTTMainTextColor];
        _groupNameLabel.font = [UIFont systemFontOfSize:15];
    }
    return _groupNameLabel;
}

- (UIImageView *)avaratIamgeView{
    if (!_avaratIamgeView) {
        _avaratIamgeView = [[UIImageView alloc] init];
        _avaratIamgeView.layer.masksToBounds = YES;
        _avaratIamgeView.layer.cornerRadius = 20;
    }
    return _avaratIamgeView;
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
