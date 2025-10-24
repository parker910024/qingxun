//
//  TTWorldletMainTableViewCell.m
//  XC_TTGameMoudle
//
//  Created by apple on 2019/7/1.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTWorldletMainTableViewCell.h"
#import <Masonry/Masonry.h> // 约束
#import "XCMacros.h" // 约束的宏定义
#import "UIImageView+QiNiu.h"  // 加载图片
#import "XCTheme.h" // 颜色设置的宏定义
#import <YYText/YYLabel.h>
#import <YYText/YYText.h>
#import "TTWorldletMainViewController+AttributedString.h"

@interface TTWorldletMainTableViewCell ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *avatorImageView;
@property (nonatomic, strong) YYLabel *titleLabel;
@property (nonatomic, strong) UIImageView *tagImageView;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIButton *noticeBtn;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation TTWorldletMainTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initView];
        
        [self initConstraint];
        
    }
    return self;
}

- (void)initView {
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.avatorImageView];
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.tagImageView];
    [self.backView addSubview:self.subTitleLabel];
    [self.backView addSubview:self.noticeBtn];
    [self.backView addSubview:self.contentLabel];
}

- (void)initConstraint {
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-(32 + 26 + 55 + kSafeAreaBottomHeight));
    }];
    
    [self.avatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatorImageView.mas_right).offset(11);
        make.top.mas_equalTo(24);
    }];
    
    [self.tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(6);
        make.centerY.mas_equalTo(self.titleLabel);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatorImageView.mas_right).offset(11);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(9);
    }];
    
    [self.noticeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(self.avatorImageView.mas_bottom).offset(16);
        make.size.mas_equalTo(CGSizeMake(35, 17));
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.right.mas_equalTo(-19);
        make.top.mas_equalTo(self.avatorImageView.mas_bottom).offset(16);
    }];
}

- (void)setModel:(LittleWorldListItem *)model {
    
    LittleWorldListItemMember *member = [model.members firstObject];
    
    [_avatorImageView qn_setImageImageWithUrl:member.avatar placeholderImage:[XCTheme defaultTheme].placeholder_image_cycle type:(ImageType)ImageTypeUserIcon];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    
    NSMutableAttributedString *firstAtt = [self createNickLabel:member.nick fontSize:15];
    
    NSMutableAttributedString *spaceAtt = [[NSMutableAttributedString alloc] initWithString:@" "];
    
    NSMutableAttributedString *secondAtt = [self createGenderAttr:member];
    
    [str appendAttributedString:firstAtt];
    [str appendAttributedString:spaceAtt];
    [str appendAttributedString:secondAtt];
    
    _titleLabel.attributedText = str;
    
    _tagImageView.image = [UIImage imageNamed:@"worldletCreator"];
    
    NSDate *updateDate = [NSDate dateWithTimeIntervalSince1970:[model.noticeUpdateTime doubleValue] / 1000.0];
    
    NSDate *nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;//只比较秒数差异
    //比较的结果是NSDateComponents类对象
    NSDateComponents *delta = [calendar components:unit fromDate:updateDate toDate:nowDate options:0];
    
    if (delta.year > 0) {
        _subTitleLabel.text = [NSString stringWithFormat:@"%ld年前",delta.year];
    } else if (delta.month > 0) {
        _subTitleLabel.text = [NSString stringWithFormat:@"%ld月前",delta.month];
    } else if (delta.day > 0) {
        _subTitleLabel.text = [NSString stringWithFormat:@"%ld天前",delta.day];
    } else if (delta.hour > 0) {
        _subTitleLabel.text = [NSString stringWithFormat:@"%ld小时前",delta.hour];
    } else if (delta.minute > 0) {
        _subTitleLabel.text = [NSString stringWithFormat:@"%ld分钟前",delta.minute];
    } else {
        _subTitleLabel.text = [NSString stringWithFormat:@"%ld秒前",delta.second];
    }
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.firstLineHeadIndent = 35;
    [style setLineSpacing:6];
    
    NSMutableAttributedString *muAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",model.notice] attributes:@{NSParagraphStyleAttributeName:style}];
    _contentLabel.attributedText = muAtt;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = UIColor.whiteColor;
        _backView.layer.cornerRadius = 12;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}

- (UIImageView *)avatorImageView {
    if (!_avatorImageView) {
        _avatorImageView = [[UIImageView alloc] init];
        _avatorImageView.layer.cornerRadius = 23;
        _avatorImageView.layer.masksToBounds = YES;
        _avatorImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesAction)];
        [_avatorImageView addGestureRecognizer:tap];
    }
    return _avatorImageView;
}

- (YYLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[YYLabel alloc] init];
        _titleLabel.numberOfLines = 1;
        _titleLabel.textColor = XCTheme.getTTSubTextColor;
        _titleLabel.preferredMaxLayoutWidth = 300;
    }
    return _titleLabel;
}

- (UIImageView *)tagImageView {
    if (!_tagImageView) {
        _tagImageView = [[UIImageView alloc] init];
    }
    return _tagImageView;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textColor = XCTheme.getTTDeepGrayTextColor;
        _subTitleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _subTitleLabel;
}

- (UIButton *)noticeBtn {
    if (!_noticeBtn) {
        _noticeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_noticeBtn setTitle:@"公告" forState:UIControlStateNormal];
        [_noticeBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _noticeBtn.backgroundColor = UIColorRGBAlpha(0x000000, 0.15);
        _noticeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _noticeBtn.layer.cornerRadius = 5;
        _noticeBtn.layer.masksToBounds = YES;
    }
    return _noticeBtn;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = XCTheme.getTTMainTextColor;
        _contentLabel.font = [UIFont systemFontOfSize:15];
    }
    return _contentLabel;
}

- (void)tapGesAction {
    if (self.avatorClick) {
        self.avatorClick();
    }
}

- (NSMutableAttributedString *)createNickLabel:(NSString *)userNick fontSize:(CGFloat)fontSize{
    
    UILabel *nickLabel = [[UILabel alloc]init];
    //text
    NSString *nick = userNick;
    
    nickLabel.text = nick;
    
    nickLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:fontSize];
    
    nickLabel.textColor = XCTheme.getTTMainTextColor;
    
    //width
    CGFloat nickWidth = [self sizeWithText:nick font:[UIFont systemFontOfSize:fontSize] maxSize:CGSizeMake(KScreenWidth , KScreenHeight)].width;
    CGFloat maxWidth = 135;
    if (nickWidth > maxWidth) {
        nickLabel.bounds = CGRectMake(0, 0, maxWidth, 18);
    }else {
        nickLabel.bounds = CGRectMake(0, 0, nickWidth + 3, 18);
    }
    
    NSMutableAttributedString * nickString = [NSMutableAttributedString yy_attachmentStringWithContent:nickLabel contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(nickLabel.frame.size.width, nickLabel.frame.size.height) alignToFont:[UIFont systemFontOfSize:fontSize] alignment:YYTextVerticalAlignmentCenter];
    return nickString;
}

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

//create gender
- (NSMutableAttributedString *)createGenderAttr:(LittleWorldListItemMember *)member {
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.bounds = CGRectMake(0, 0, 14, 14);;
    imageView.contentMode = UIViewContentModeScaleToFill;
    NSString *imageName = @"";
    if (member.gender == 1) {
        imageName = [[XCTheme defaultTheme] common_sex_male];
    }else{
        imageName = [[XCTheme defaultTheme] common_sex_female];
    }
    imageView.image = [UIImage imageNamed:imageName];
    NSMutableAttributedString * imageString = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(imageView.frame.size.width, imageView.frame.size.height) alignToFont:[UIFont systemFontOfSize:16.0] alignment:YYTextVerticalAlignmentCenter];
    return imageString;
}

@end
