//
//  LTCommentListViewCell.m
//  UKiss
//
//  Created by apple on 2018/12/6.
//  Copyright © 2018 yizhuan. All rights reserved.
//

#import "LTCommentListViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


#import "XCCPRoomAttributed.h"
#import <YYText/YYText.h>
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+NTES.h"
#import "UIView+XCToast.h"

@interface LTCommentListViewCell()

/**昵称 性别*/
@property(nonatomic,strong)YYLabel      * nickSexAgeLabel;

/**头像*/
@property (nonatomic, strong) UIImageView * avartImageView;

/**play*/
@property (nonatomic, strong) UIImageView * playImageView;

/**时间*/
@property (nonatomic, strong) UILabel * timeLabel;

/**消息内容*/
@property (nonatomic, strong) UILabel * contentLabel;

/**动态p图片*/
@property (nonatomic, strong) UIImageView * pictureImageView;

/**
 动态内容
 */
//@property (nonatomic, strong) UILabel * dynamicContentLabel;
@end
@implementation LTCommentListViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

+ (CGFloat)cellHeight:(HeartCommentInfo*)info{
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
    CGSize maxSize = CGSizeMake(KScreenWidth-170, CGFLOAT_MAX);
    CGFloat hh =  [info.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.height;
    hh += (90 - 20);
    return MAX(90, hh);
}

- (void)setInfo:(HeartCommentInfo *)info{
    _info = info;
    [self.avartImageView sd_setImageWithURL:[NSURL URLWithString:info.commentAvatar] placeholderImage:[UIImage imageNamed:default_bg]];
//    self.nickSexAgeLabel.attributedText = [XCCPRoomAttributed creatCommunityUserName:info.commentNick withSex:info.gender withAge:info.age];
    self.nickSexAgeLabel.text = info.commentNick;
    self.nickSexAgeLabel.textAlignment = NSTextAlignmentLeft;
//    self.nickSexAgeLabel.text = info.commentNick;
//    if (self.type == HeadMessageType_Comment) {
        self.contentLabel.text = info.content;
        self.contentLabel.hidden = NO;
    self.playImageView.hidden = !(info.dynamicType == DynamicTypeVideo);
//    }else{
//        self.contentLabel.text = @"占位";
//        self.playImageView.hidden = NO;
//        self.contentLabel.hidden = YES;
//    }
    self.timeLabel.text = info.publishTime;
    if (info.dynamicType == DynamicTypeText) {
        self.pictureImageView.image = [UIImage imageNamed:@"dynamic_comment_text"];
    }else if(info.dynamicType == DynamicTypePicture || info.dynamicType == DynamicTypeVideo){
        NSURL * url = [NSURL URLWithString:info.imageUrl.firstObject];
        [self.pictureImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:default_bg]];
    }else if(info.dynamicType == DynamicTypeVoice){
        self.pictureImageView.image = [UIImage imageNamed:@"dynamic_comment_voice"];
    }
}

- (void)onTapDynamic{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onTapDynamic:)]) {
        [self.delegate onTapDynamic:self];
    }
}

- (void)onTapAvart{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onTapAvart:)]) {
        [self.delegate onTapAvart:self];
    }
}

- (void)initView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.nickSexAgeLabel];

    [self.contentView addSubview:self.avartImageView];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.timeLabel];
//    [self.contentView addSubview:self.dynamicContentLabel];
    [self.contentView addSubview:self.pictureImageView];
    [self.contentView addSubview:self.playImageView];
}


- (void)initConstrations
{
    [self.avartImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.left.mas_equalTo(self.contentView).offset(20);
        make.centerY.mas_equalTo(self.contentView);
    }];
    [self.nickSexAgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.avartImageView.mas_top);
        make.left.mas_equalTo(self.avartImageView.mas_right).offset(11);
        make.width.mas_lessThanOrEqualTo(KScreenWidth - 240);
        make.height.mas_equalTo(20);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nickSexAgeLabel.mas_bottom).mas_offset(9);
        make.left.mas_equalTo(self.nickSexAgeLabel);
        make.right.mas_equalTo(self).offset(-100);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nickSexAgeLabel);
        make.left.mas_equalTo(self.nickSexAgeLabel.mas_right).mas_offset(6);
//        make.right.mas_equalTo(self).offset(-100);
        make.height.mas_equalTo(12);
    }];
    
    [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-20);
        make.centerY.mas_equalTo(self.avartImageView);
        make.height.width.mas_equalTo(50);
    }];
    
    
    [self.playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.pictureImageView);
    }];
    
    
//    [self.dynamicContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self).offset(-15);
//        make.top.mas_equalTo(self.avartImageView.mas_top);
//        make.width.mas_equalTo(60);
//        make.bottom.mas_equalTo(self).mas_offset(-15);
//    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (UIImageView *)avartImageView
{
    if (!_avartImageView) {
        _avartImageView = [[UIImageView alloc] init];
        _avartImageView.layer.masksToBounds = YES;
        _avartImageView.layer.cornerRadius = 25;
        _avartImageView.userInteractionEnabled = YES;
        _avartImageView.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapAvart)];
        [_avartImageView addGestureRecognizer:tap];
    }
    return _avartImageView;
}
- (YYLabel *)nickSexAgeLabel{
    if (!_nickSexAgeLabel) {
        _nickSexAgeLabel = [[YYLabel alloc] init];
//        _nickSexAgeLabel.textAlignment = NSTextAlignmentCenter;
        _nickSexAgeLabel.textColor = UIColorFromRGB(0x222222);
        _nickSexAgeLabel.font = [UIFont boldSystemFontOfSize:16];
//        _nickSexAgeLabel.userInteractionEnabled = YES;
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapAvart)];
//        [_nickSexAgeLabel addGestureRecognizer:tap];
        
    }
    return _nickSexAgeLabel;
}
- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel= [[UILabel alloc] init];
        _contentLabel.textColor = UIColorFromRGB(0x222222);
        _contentLabel.font = [UIFont systemFontOfSize:14];
    }
    return _contentLabel;
}
- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = UIColorRGBAlpha(0x222222, 0.3);
        
    }
    return _timeLabel;
}
//- (UILabel *)dynamicContentLabel
//{
//    if (!_dynamicContentLabel) {
//        _dynamicContentLabel = [[UILabel alloc] init];
//        _dynamicContentLabel.font = [UIFont systemFontOfSize:12];
//        _dynamicContentLabel.textColor = UIColorRGBAlpha(0x8986AA, 1);
//        _dynamicContentLabel.userInteractionEnabled = YES;
//        _dynamicContentLabel.numberOfLines = 0;
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapDynamic)];
//        [_dynamicContentLabel addGestureRecognizer:tap];
//
//    }
//    return _dynamicContentLabel;
//}

- (UIImageView *)pictureImageView{
    if (!_pictureImageView) {
        _pictureImageView = [[UIImageView alloc] init];
        _pictureImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapDynamic)];
        [_pictureImageView addGestureRecognizer:tap];
        _pictureImageView.layer.cornerRadius = 5;
        _pictureImageView.layer.masksToBounds = YES;
        _pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _pictureImageView;
}
- (UIImageView *)playImageView{
    if (!_playImageView) {
        _playImageView = [[UIImageView alloc] init];
        _playImageView.image = [UIImage imageNamed:@"dynamic_comment_video_play"];
    }
    return _playImageView;
}
@end
