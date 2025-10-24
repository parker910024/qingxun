//
//  TTGameSquareCollectionViewCell.m
//  AFNetworking
//
//  Created by User on 2019/5/7.
//

#import "TTGameSquareCollectionViewCell.h"
#import <Masonry/Masonry.h> // 约束
#import "XCMacros.h" // 约束的宏定义
#import "UIImageView+QiNiu.h"  // 加载图片
#import "XCTheme.h" // 颜色设置的宏定义

#import <YYText/YYText.h>
#import <YYText/YYLabel.h>

#import "TTHomeV4DetailData.h"
#import "LXSEQView.h"

@interface TTGameSquareCollectionViewCell ()

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIImageView *tagImageView;
@property (nonatomic, strong) YYLabel *titleLabel;

@property (nonatomic, strong) LXSEQView *voiceImageView;//音符
@property (nonatomic, strong) UILabel *onlineLabel;//显示在线人数
@property (nonatomic, strong) UIView *onlineBgView;//在线人数背景

//@property (nonatomic, strong) UIImageView *tallyImageView;//标签，e.g HOT

@end

@implementation TTGameSquareCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initView];
        
        [self initConstraint];
    }
    
    return self;
}

- (void)initView {
    [self.contentView addSubview:self.coverImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.tagImageView];
    [self.coverImageView addSubview:self.onlineBgView];
    [self.coverImageView addSubview:self.voiceImageView];
    [self.coverImageView addSubview:self.onlineLabel];
    
    //    [self.contentView addSubview:self.tallyImageView];
}

- (void)initConstraint {
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo((KScreenWidth - 17 * 3) / 2);
    }];
    
    [self.coverImageView layoutIfNeeded];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.coverImageView.bounds cornerRadius:16];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    layer.path = path.CGPath;
    
    self.coverImageView.layer.mask = layer;
    
    [self.tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.coverImageView.mas_bottom).offset(8);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(17);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.coverImageView.mas_bottom).offset(9);
        make.left.right.mas_equalTo(0);
    }];
    
    [self.onlineBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-6);
        make.bottom.mas_equalTo(-6);
        make.height.mas_equalTo(16);
    }];
    
    [self.voiceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.onlineBgView.mas_left).offset(6);
        make.centerY.mas_equalTo(self.onlineBgView);
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(8);
    }];
    
    [self.onlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.voiceImageView.mas_right).offset(4);
        make.right.mas_equalTo(self.onlineBgView.mas_right).offset(-6);
        make.centerY.mas_equalTo(self.voiceImageView);
    }];
    
    //    [self.tallyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.left.mas_equalTo(self.coverImageView).offset(6);
    //        make.width.mas_equalTo(34).priorityLow();
    //        make.width.mas_equalTo(67);
    //        make.height.mas_equalTo(15);
    //    }];
}

- (void)setModel:(TTHomeV4DetailData *)model {
    _model = model;
    [self.coverImageView qn_setImageImageWithUrl:model.avatar placeholderImage:[XCTheme defaultTheme].placeholder_image_cycle type:ImageTypeUserLibaryDetail];
    
    [self.tagImageView qn_setImageImageWithUrl:model.tagPict placeholderImage:[XCTheme defaultTheme].placeholder_image_rectangle type:ImageTypeHomePageItem success:^(UIImage *image) {
        if (image) {
            [self.tagImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(image.size.width / (image.size.height / 17));
            }];
        }
    }];
    

    [self.tagImageView layoutIfNeeded];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.firstLineHeadIndent = self.tagImageView.frame.size.width + 4;
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:model.title attributes:@{NSParagraphStyleAttributeName:paraStyle}];
    attStr.yy_lineSpacing = 4;
    attStr.yy_font = [UIFont systemFontOfSize:14];
    self.titleLabel.attributedText = attStr;
    
    self.onlineLabel.text = [NSString stringWithFormat:@"%ld人在线", (long)model.onlineNum];
    
    if (model) {
        [self.voiceImageView startAnimation];
    } else {
        [self.voiceImageView stopAnimation];
    }
    //    if (model.isRecom) {//皇帝推荐
    //        self.tallyImageView.image = [UIImage imageNamed:@"home_emperor"];
    //    } else if (model.badge.length > 0) {//下发图片
    //        [self.tallyImageView qn_setImageImageWithUrl:model.badge placeholderImage:nil type:ImageTypeHomePageItem];
    //    } else {
    //        [self.tallyImageView qn_setImageImageWithUrl:nil placeholderImage:nil type:ImageTypeHomePageItem];
    //        self.tallyImageView.image = nil;
    //    }
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
    }
    return _coverImageView;
}

- (YYLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[YYLabel alloc] init];
        _titleLabel.textColor = XCTheme.getTTMainTextColor;
        _titleLabel.numberOfLines = 0;
        _titleLabel.preferredMaxLayoutWidth = (KScreenWidth - 17 * 3) / 2;//设置最大宽度
    }
    return _titleLabel;
}

- (UIImageView *)tagImageView {
    if (!_tagImageView) {
        _tagImageView = [[UIImageView alloc] init];
    }
    return _tagImageView;
}

- (LXSEQView *)voiceImageView {
    if (_voiceImageView == nil) {
        _voiceImageView = [[LXSEQView alloc] init];
        _voiceImageView.pillarWidth = 2;
        _voiceImageView.pillarColor = UIColorFromRGB(0xFFFFFF);
    }
    return _voiceImageView;
}

- (UILabel *)onlineLabel {
    if (_onlineLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0xf5f5f5);
        label.font = [UIFont systemFontOfSize:10];
        label.text = @"0人在线";
        _onlineLabel = label;
    }
    return _onlineLabel;
}

- (UIView *)onlineBgView {
    if (_onlineBgView == nil) {
        _onlineBgView = [[UIView alloc] init];
        _onlineBgView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.6];
        _onlineBgView.layer.cornerRadius = 8;
        _onlineBgView.layer.masksToBounds = YES;
    }
    return _onlineBgView;
}

//- (UIImageView *)tallyImageView {
//    if (_tallyImageView == nil) {
//        _tallyImageView = [[UIImageView alloc] init];
//    }
//    return _tallyImageView;
//}


@end
