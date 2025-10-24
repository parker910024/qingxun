//
//  TTGroupManagerTableViewCell.m
//  TuTu
//
//  Created by gzlx on 2018/11/16.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTGroupManagerTableViewCell.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "UIImageView+QiNiu.h"

@interface TTGroupManagerTableViewCell()
/** 头像*/
@property (nonatomic, strong) UIImageView * avatarImageView;
/** 标题*/
@property (nonatomic, strong) UILabel * titleLabel;
/** 副标题*/
@property (nonatomic, strong) UILabel * subTitleLabel;
/** 验证*/
@property (nonatomic, strong) UISwitch * verswitch;
@property (nonatomic, strong) UIView * sepView;
/** 箭头*/
@property (nonatomic, strong) UIImageView * arrowImageView;
@end

@implementation TTGroupManagerTableViewCell

#pragma mark - life cycle
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
        [self initContrations];
    }
    return self;
}

#pragma mark - response
- (void)switchChangeWith:(UISwitch *)switchs{
    if (!switchs.hidden) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(ttGroupManagerCellSwtich:switchType:)]) {
            [self.delegate ttGroupManagerCellSwtich:switchs.on switchType:self.switchType];
        }
    }
}

#pragma mark - public method
/** 配置*/
- (void)configTTGroupManagerTableViewCellWith:(TTGroupManagerModel *)managerModel{
    if (managerModel) {
        self.avatarImageView.hidden = YES;
        //标题
        if (managerModel.title && managerModel.title.length > 0) {
            self.titleLabel.text = managerModel.title;
        }
         //头像
        if (managerModel.avatar && managerModel.avatar.length > 0) {
            self.avatarImageView.hidden = NO;
            [self.avatarImageView qn_setImageImageWithUrl:managerModel.avatar placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeUserIcon];
        }
        //副标题
        if (managerModel.subTitle && managerModel.subTitle.length > 0) {
            self.subTitleLabel.text = managerModel.subTitle;
        }
        //是不是验证
        if (managerModel.disPlayType == TTGroupManagerModelType_Verifica) {
            self.verswitch.on = managerModel.switchStatus;
        }
        
        [self setCellStyleWith:managerModel];
    }
}

- (void)setCellStyleWith:(TTGroupManagerModel *)model{
    self.avatarImageView.hidden = YES;
    if (model.disPlayType == TTGroupManagerModelType_Avatar) {
        self.subTitleLabel.hidden = YES;
        self.arrowImageView.hidden = NO;
        self.avatarImageView.hidden = NO;
        self.verswitch.hidden = YES;
    }else if (model.disPlayType  == TTGroupManagerModelType_Subtitle){
        self.subTitleLabel.hidden = NO;
        self.avatarImageView.hidden = YES;
        self.verswitch.hidden = YES;
        [self.subTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView).offset(-15);
        }];
    }else if (model.disPlayType == TTGroupManagerModelType_Verifica){
        self.subTitleLabel.hidden = YES;
        self.arrowImageView.hidden = YES;
        self.verswitch.hidden = NO;
    }else if (model.disPlayType == TTGroupManagerModelType_SubtitleArrow){
        self.subTitleLabel.hidden = NO;
        self.arrowImageView.hidden = NO;
        self.verswitch.hidden = YES;
        [self.subTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView).offset(-26);
        }];
    }else if (model.disPlayType == TTGroupManagerModelType_SubtitlHidden){
        self.subTitleLabel.hidden = YES;
        self.arrowImageView.hidden = YES;
        self.verswitch.hidden = YES;
    }
}

#pragma mark - private method
- (void)initView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subTitleLabel];
    [self.contentView addSubview:self.verswitch];
    [self.contentView addSubview:self.sepView];
    [self.contentView addSubview:self.arrowImageView];
}
- (void)initContrations{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(15);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).offset(-35);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(11);
    }];
    
    [self.verswitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(30);
    }];
    
    [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - setters and getters
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor  =  [XCTheme getTTMainTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textColor  = [XCTheme getTTDeepGrayTextColor];
        _subTitleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _subTitleLabel;
}

- (UIImageView *)arrowImageView{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image =[UIImage imageNamed:@"discover_family_arrow"];
    }
    return _arrowImageView;
}

- (UISwitch *)verswitch{
    if (!_verswitch) {
        _verswitch = [[UISwitch alloc] init];
        _verswitch.onTintColor = [XCTheme getTTMainColor];
        _verswitch.tintColor = [XCTheme getTTDeepGrayTextColor];
        _verswitch.backgroundColor= [XCTheme getTTDeepGrayTextColor];
        _verswitch.layer.masksToBounds = YES;
        _verswitch.layer.cornerRadius = 15;
        [_verswitch addTarget:self action:@selector(switchChangeWith:) forControlEvents:UIControlEventValueChanged];
    }
    return _verswitch;
}

- (UIView *)sepView{
    if (!_sepView) {
        _sepView = [[UIView alloc] init];
        _sepView.backgroundColor = [XCTheme getTTSimpleGrayColor];
    }
    return _sepView;
}

- (UIImageView *)avatarImageView{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.cornerRadius = 5;
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
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
