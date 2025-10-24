//
//  LLVoicePartyRoomCell.m
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/7/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "LLVoicePartyRoomCell.h"

#import "XCTheme.h"
#import "LXSEQView.h"
#import "UIImageView+QiNiu.h"
#import "SVGAImageView.h"
#import "SVGAParserManager.h"

#import "HomeV5CategoryRoom.h"

#import <Masonry/Masonry.h>
#import <YYText/YYText.h>
#import "LXSEQView.h"


//圆角
static CGFloat const kCornerRadius = 12.f;

@interface LLVoicePartyRoomCell ()

@property (nonatomic, strong) UILabel *nameLabel;//推荐名称
@property (nonatomic, strong) UIImageView *tagImageView;//标签
@property (nonatomic, strong) UIImageView *coverImageView;//封面
@property (nonatomic, strong) UIImageView *lockImageView;//锁

@property (nonatomic, strong) SVGAParserManager *parserManager;
@property (nonatomic, strong) SVGAImageView *recommendSVGAImageView;//钻石推荐
@property (nonatomic, strong) UIImageView *recommendImageView;//钻石推荐

@property (nonatomic, strong) LXSEQView *voiceImageView;//音符
@property (nonatomic, strong) UILabel *onlineLabel;//显示在线人数
@property (nonatomic, strong) UIImageView *onlineMaskImageView;//在线人数背景蒙层
@property (nonatomic, strong) UIImageView *redbagIcon;//红包icon
@property (nonatomic, strong) SVGAImageView *redbagSVGAImageView;
@property (nonatomic, strong) SVGAParserManager *redbagParserManager;

@end

@implementation LLVoicePartyRoomCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self updateConstraint];
    }
    return self;
}

- (void)initView {
    [self.contentView addSubview:self.coverImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.lockImageView];
    [self.contentView addSubview:self.recommendSVGAImageView];
    [self.contentView addSubview:self.recommendImageView];
    [self.contentView addSubview:self.tagImageView];
    [self.contentView addSubview:self.redbagIcon];
    [self.redbagIcon addSubview:self.redbagSVGAImageView];
    

    [self.coverImageView addSubview:self.onlineMaskImageView];
    [self.onlineMaskImageView addSubview:self.voiceImageView];
    [self.onlineMaskImageView addSubview:self.onlineLabel];
    
}

- (void)updateConstraint {
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(self.coverImageView.mas_width);
    }];
    [self.lockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.coverImageView);
        make.center.mas_equalTo(self.coverImageView);
    }];
    
    [self.recommendSVGAImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.coverImageView);
    }];
    
    [self.recommendImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.coverImageView);
    }];
    
    [self.onlineMaskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.coverImageView);
        make.height.mas_equalTo(36);
    }];
    
    [self.voiceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(11);
        make.height.mas_equalTo(13);
        make.centerY.mas_equalTo(self.onlineLabel);
    }] ;
    
    [self.onlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.voiceImageView.mas_right).offset(6);
        make.bottom.right.mas_equalTo(self.onlineMaskImageView).inset(9);
    }];
    
    [self.tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.nameLabel);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(17);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.coverImageView.mas_bottom).offset(10);
        make.left.right.mas_equalTo(self.coverImageView).inset(0);
    }];
    
    [self.redbagIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverImageView.mas_left).offset(16);
        make.bottom.equalTo(self.coverImageView.mas_bottom).offset(-16);
    }];
    
    [self.redbagSVGAImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.redbagIcon);
    }];
    [self.redbagIcon layoutIfNeeded];
}

//钻石推荐角标设置
- (void)setupRecommendBadge:(NSString *)badge {
    
    if (badge == nil || badge.length == 0) {
        self.recommendImageView.hidden = YES;
        self.recommendSVGAImageView.hidden = YES;
        return;
    }
    
    self.recommendImageView.hidden = NO;
    self.recommendSVGAImageView.hidden = NO;
    
    [self.recommendImageView qn_setImageImageWithUrl:badge placeholderImage:nil type:ImageTypeHomePageItem];
    @weakify(self);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self.parserManager loadSvgaWithURL:[NSURL URLWithString:badge] completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
                @strongify(self);
                if (videoItem.images.count > 0) {
                    self.recommendSVGAImageView.loops = INT_MAX;
                    self.recommendSVGAImageView.clearsAfterStop = NO;
                    self.recommendSVGAImageView.videoItem = videoItem;
                    [self.recommendSVGAImageView startAnimation];
                    
                    self.recommendImageView.image = nil;
                    
                } else {
                    
                    self.recommendSVGAImageView.videoItem = nil;
                }
                
            } failureBlock:^(NSError * _Nullable error) {
                
            }];
        });
    });
}

- (void)loadRedbagSvgaAnimation:(NSString *)matchStr {
    
    NSString *matchString = [[NSBundle mainBundle] pathForResource:matchStr ofType:@"svga"];
    NSURL *matchUrl = [NSURL fileURLWithPath:matchString];
    
    @weakify(self);
    [self.parserManager loadSvgaWithURL:matchUrl completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
        @strongify(self)
        self.redbagSVGAImageView.loops = INT_MAX;
        self.redbagSVGAImageView.clearsAfterStop = NO;
        self.redbagSVGAImageView.videoItem = videoItem;
        [self.redbagSVGAImageView startAnimation];
    } failureBlock:^(NSError * _Nullable error) {
        
    }];
}

- (void)redBagAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    CGFloat duration = 2.f;
    CGFloat height = 7.f;
    CGFloat currentY = self.redbagIcon.transform.ty;
    animation.duration = duration;
    animation.values = @[@(currentY),@(currentY - height/4),@(currentY - height/4*2),@(currentY - height/4*3),@(currentY - height),@(currentY - height/ 4*3),@(currentY - height/4*2),@(currentY - height/4),@(currentY)];
    animation.keyTimes = @[ @(0), @(0.025), @(0.085), @(0.2), @(0.5), @(0.8), @(0.915), @(0.975), @(1) ];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.repeatCount = HUGE_VALF;
    animation.removedOnCompletion = NO;
    [self.redbagIcon.layer addAnimation:animation forKey:@"kViewShakerAnimationKey"];
}

#pragma mark - Getter Setter
- (void)setModel:(HomeV5CategoryRoom *)model {
    _model = model;
    
    self.nameLabel.hidden = model == nil;
    self.onlineLabel.hidden = model == nil;
    self.onlineMaskImageView.hidden = model == nil;
    self.voiceImageView.hidden = model == nil;
    self.lockImageView.hidden = model == nil || model.roomPwd.length == 0;
    
    self.onlineLabel.text = [NSString stringWithFormat:@"%ld", (long)model.onlineNum];

    if (model) {
        [self.coverImageView qn_setImageImageWithUrl:model.avatar placeholderImage:[XCTheme defaultTheme].default_avatar type:ImageTypeHomePageItem];

        if (!model.isRedPack) {
            self.redbagIcon.hidden = YES;
            [self.redbagSVGAImageView stopAnimation];
            [self.redbagIcon.layer removeAllAnimations];
        } else {
            [self loadRedbagSvgaAnimation:@"redbag_button"];
            self.redbagIcon.hidden = NO;
            [self redBagAnimation];
        }
        
    } else {
        [self.coverImageView qn_setImageImageWithUrl:model.avatar placeholderImage:@"home_room_placeholder_new" type:ImageTypeHomePageItem];
        self.redbagIcon.hidden = YES;
        [self.redbagSVGAImageView stopAnimation];
        [self.redbagIcon.layer removeAllAnimations];
    }
    
    [self setupRecommendBadge:model.badge];
    
    @weakify(self)
    [self.tagImageView qn_setImageImageWithUrl:model.tagPict placeholderImage:[XCTheme defaultTheme].placeholder_image_rectangle type:ImageTypeUserRoomTag success:^(UIImage *image) {
        
        @strongify(self)
        if (image && image.size.height > 0) {
            
            self.tagImageView.hidden = NO;
            
            CGFloat tagWidth = image.size.width / (image.size.height / 17);
            [self.tagImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(tagWidth);
            }];
            
            //6-interval
            NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
            paraStyle.firstLineHeadIndent = tagWidth + 6;
            
            //发现’这是楚门的小世界‘最后的’界‘字被切，不能换号
            //在后面加空格增加文本长度，解决八个字不能换号导致文字被切的 bug
            NSString *name = [model.title stringByAppendingString:@"    "];
            
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:name attributes:@{NSParagraphStyleAttributeName:paraStyle}];
            attStr.yy_lineSpacing = 6;
            attStr.yy_font = [UIFont systemFontOfSize:14];
            
            self.nameLabel.attributedText = attStr;
            
        } else {
            self.tagImageView.hidden = YES;
            self.nameLabel.text = model.title;
        }
    }];
    
    if (model) {
        [self.voiceImageView startAnimation];
    } else {
        [self.voiceImageView stopAnimation];
    }
}

- (UIImageView *)coverImageView {
    if (_coverImageView == nil) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.image = [UIImage imageNamed:@"home_room_placeholder_new"];
        _coverImageView.layer.masksToBounds = YES;
        _coverImageView.layer.cornerRadius = kCornerRadius;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _coverImageView;
}

- (SVGAParserManager *)parserManager {
    if (_parserManager == nil) {
        _parserManager = [[SVGAParserManager alloc] init];
    }
    return _parserManager;
}

- (SVGAImageView *)recommendSVGAImageView {
    if (_recommendSVGAImageView == nil) {
        _recommendSVGAImageView = [[SVGAImageView alloc] init];
        _recommendSVGAImageView.autoPlay = YES;
    }
    return _recommendSVGAImageView;
}

- (UIImageView *)recommendImageView {
    if (_recommendImageView == nil) {
        _recommendImageView = [[UIImageView alloc] init];
    }
    return _recommendImageView;
}

- (UIImageView *)lockImageView {
    if (_lockImageView == nil) {
        _lockImageView = [[UIImageView alloc] init];
        _lockImageView.image = [UIImage imageNamed:@"home_room_lock_big"];
        _lockImageView.layer.masksToBounds = YES;
        _lockImageView.layer.cornerRadius = 12;
    }
    return _lockImageView;
}

- (LXSEQView *)voiceImageView {
    if (_voiceImageView == nil) {
        _voiceImageView = [[LXSEQView alloc] init];
        _voiceImageView.pillarWidth = 2.6;
        _voiceImageView.pillarColor = UIColorFromRGB(0xFFFFFF);
    }
    return _voiceImageView;
}

- (UILabel *)onlineLabel {
    if (_onlineLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0xf5f5f5);
        label.font = [UIFont boldSystemFontOfSize:13];
        label.text = @"0";
        _onlineLabel = label;
    }
    return _onlineLabel;
}

- (UIImageView *)onlineMaskImageView {
    if (_onlineMaskImageView == nil) {
        _onlineMaskImageView = [[UIImageView alloc] init];
        _onlineMaskImageView.image = [UIImage imageNamed:@"game_home_list_mask_online_number"];
    }
    return _onlineMaskImageView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = XCThemeMainTextColor;
        label.font = [UIFont systemFontOfSize:14];
        label.numberOfLines = 2;
        
        _nameLabel = label;
    }
    return _nameLabel;
}

- (UIImageView *)tagImageView {
    if (!_tagImageView) {
        _tagImageView = [[UIImageView alloc] init];
    }
    return _tagImageView;
}

- (UIImageView *)redbagIcon {
    if (!_redbagIcon) {
        _redbagIcon = [UIImageView new];
        _redbagIcon.image = [UIImage imageNamed:@"redbag_icon"];
        _redbagIcon.hidden = YES;
    }
    return _redbagIcon;
}

- (SVGAParserManager *)redbagParserManager {
    if (_redbagParserManager == nil) {
        _redbagParserManager = [[SVGAParserManager alloc] init];
    }
    return _redbagParserManager;
}

- (SVGAImageView *)redbagSVGAImageView {
    if (_redbagSVGAImageView == nil) {
        _redbagSVGAImageView = [[SVGAImageView alloc] init];
        _redbagSVGAImageView.autoPlay = YES;
    }
    return _redbagSVGAImageView;
}

@end
