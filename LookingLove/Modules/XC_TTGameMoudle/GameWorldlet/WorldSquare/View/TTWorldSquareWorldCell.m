//
//  TTWorldSquareWorldCell.m
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/6/28.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTWorldSquareWorldCell.h"

#import "XCTheme.h"
#import "UIImageView+QiNiu.h"

#import "LittleWorldSquare.h"

#import <Masonry/Masonry.h>
#import <YYText/YYText.h>

@interface TTWorldSquareWorldCell ()

@property (nonatomic, strong) UILabel *nameLabel;//名称
@property (nonatomic, strong) UIImageView *classifyImageView;//分类
@property (nonatomic, strong) UIImageView *coverImageView;//封面

@property (nonatomic, strong) UIImageView *onlineImageView;//在线人数 icon
@property (nonatomic, strong) UILabel *onlineLabel;//在线人数
@property (nonatomic, strong) UIImageView *onlineMaskImageView;//在线人数蒙层

@property (nonatomic, strong) YYLabel *tagLabel;//标签图片富文本，新、官、热、派对中

@end

@implementation TTWorldSquareWorldCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self updateConstraint];
    }
    return self;
}

- (void)initView {
    [self.contentView addSubview:self.coverImageView];
    
    [self.coverImageView addSubview:self.onlineMaskImageView];
    [self.coverImageView addSubview:self.onlineImageView];
    [self.coverImageView addSubview:self.onlineLabel];
    
    [self.contentView addSubview:self.classifyImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.tagLabel];
}

- (void)updateConstraint {
    
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.right.mas_equalTo(self.contentView).inset(5);
        make.height.mas_equalTo(self.coverImageView.mas_width);
    }];
    
    [self.onlineMaskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    
    [self.onlineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.onlineLabel.mas_left).offset(-4);
        make.bottom.mas_equalTo(-8);
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(10);
    }] ;
    
    [self.onlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.onlineImageView);
    }];
    
    [self.classifyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.coverImageView);
        make.top.mas_equalTo(self.coverImageView.mas_bottom).offset(8);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(17);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.coverImageView.mas_bottom).offset(8);
        make.left.right.mas_equalTo(self.coverImageView);
    }];
    
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.right.mas_lessThanOrEqualTo(0);
    }];
}

/**
 设置在线状态是否显示
 */
- (void)setOnlineViewShowStatus:(BOOL)isShow {
    self.onlineLabel.hidden = !isShow;
    self.onlineMaskImageView.hidden = !isShow;
    self.onlineImageView.hidden = !isShow;
}

/**
 派对中>官方>热>新，最多展示3个标签(后台控制返回三个)

 @param flag 标签枚举值
 */
- (void)setupTagContent:(LittleWorldListItemTag)flag {
    
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    
    //party
    if (flag & LittleWorldListItemTagOnParty) {
        
        NSString *img = @"worldsquare_tag_on_party";
        [text appendAttributedString:[self imageAttachWithImage:img]];
    }
    
    //official
    if (flag & LittleWorldListItemTagOfficial) {
        
        if (text.length > 0) {
            [text yy_appendString:@" "];
        }
        
        NSString *img = @"worldsquare_tag_official";
        [text appendAttributedString:[self imageAttachWithImage:img]];
    }
    
    //hot
    if (flag & LittleWorldListItemTagHot) {
        
        if (text.length > 0) {
            [text yy_appendString:@" "];
        }
        
        NSString *img = @"worldsquare_tag_hot";
        [text appendAttributedString:[self imageAttachWithImage:img]];
    }
    
    //new
    if (flag & LittleWorldListItemTagNew) {
        
        if (text.length > 0) {
            [text yy_appendString:@" "];
        }
        
        NSString *img = @"worldsquare_tag_new";
        [text appendAttributedString:[self imageAttachWithImage:img]];
    }

    self.tagLabel.attributedText = text;
}

- (NSMutableAttributedString *)imageAttachWithImage:(NSString *)imageName {
    
    UIFont *font = [UIFont systemFontOfSize:16];
    UIImage *image = [UIImage imageNamed:imageName];

    if (image == nil) {
        return nil;
    }
    
    NSMutableAttributedString *imageText = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
    
    return imageText;
}

#pragma mark - Getter Setter
- (void)setModel:(LittleWorldListItem *)model {
    
    if (self.isFindWorldEntrance) {
        return;
    }
    
    _model = model;
    
    [self setOnlineViewShowStatus:model != nil];
    [self setupTagContent:model.tag];
    
//    self.nameLabel.text = model.name;
//    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.onlineLabel.text = [NSString stringWithFormat:@"%ld", (long)model.memberNum];
    
    if (model) {
        [self.coverImageView qn_setImageImageWithUrl:model.icon placeholderImage:[XCTheme defaultTheme].default_avatar type:ImageTypeHomePageItem];
    } else {
        //虚位以待
        [self.coverImageView qn_setImageImageWithUrl:@"" placeholderImage:@"home_room_placeholder_new" type:ImageTypeHomePageItem];
    }
    
    @weakify(self)
    [self.classifyImageView qn_setImageImageWithUrl:model.typePict placeholderImage:[XCTheme defaultTheme].placeholder_image_rectangle type:ImageTypeUserRoomTag success:^(UIImage *image) {
        
        @strongify(self)
        if (image && image.size.height > 0) {
            
            self.classifyImageView.hidden = NO;
            
            CGFloat tagWidth = image.size.width / (image.size.height / 17);
            [self.classifyImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(tagWidth);
            }];
            
            NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
            paraStyle.firstLineHeadIndent = tagWidth + 4;
            paraStyle.lineSpacing = 4;
            
            //发现’楚门的小世界‘最后的’界‘字被切，不能换号
            //在后面加空格增加文本长度，解决六个字不能换号导致文字被切的 bug
            NSString *name = [model.name stringByAppendingString:@"    "];
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:name attributes:@{NSParagraphStyleAttributeName:paraStyle}];
            
            self.nameLabel.attributedText = attStr;
            
        } else {
            self.classifyImageView.hidden = YES;
            self.nameLabel.text = model.name;
        }
    }];
}

- (void)setFindWorldEntrance:(BOOL)findWorldEntrance {
    _findWorldEntrance = findWorldEntrance;
    
    if (findWorldEntrance) {
        
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.firstLineHeadIndent = 0;
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"" attributes:@{NSParagraphStyleAttributeName:paraStyle}];
        
        self.nameLabel.attributedText = attStr;
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.text = @"发现新世界";
        self.coverImageView.image = [UIImage imageNamed:@"worldsquare_find_new_world"];
        self.tagLabel.attributedText = nil;
        self.classifyImageView.image = nil;
        
        [self setOnlineViewShowStatus:NO];
    }
}

- (UIImageView *)coverImageView {
    if (_coverImageView == nil) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.image = [UIImage imageNamed:@"home_room_placeholder_new"];
        _coverImageView.layer.masksToBounds = YES;
        _coverImageView.layer.cornerRadius = 12;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _coverImageView;
}

- (UIImageView *)onlineImageView {
    if (_onlineImageView == nil) {
        _onlineImageView = [[UIImageView alloc] init];
        _onlineImageView.image = [UIImage imageNamed:@"worldsquare_online_number"];
    }
    return _onlineImageView;
}

- (UILabel *)onlineLabel {
    if (_onlineLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorRGBAlpha(0xf5f5f5, 0.8);
        label.font = [UIFont boldSystemFontOfSize:12];
        label.text = @"0";
        
        _onlineLabel = label;
    }
    return _onlineLabel;
}

- (UIImageView *)onlineMaskImageView {
    if (_onlineMaskImageView == nil) {
        _onlineMaskImageView = [[UIImageView alloc] init];
        _onlineMaskImageView.image = [UIImage imageNamed:@"worldsquare_online_mask"];
    }
    return _onlineMaskImageView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [XCTheme getTTMainTextColor];
        label.font = [UIFont systemFontOfSize:14];
        label.numberOfLines = 2;
        
        _nameLabel = label;
    }
    return _nameLabel;
}

- (UIImageView *)classifyImageView {
    if (!_classifyImageView) {
        _classifyImageView = [[UIImageView alloc] init];
    }
    return _classifyImageView;
}

- (YYLabel *)tagLabel {
    if (_tagLabel == nil) {
        _tagLabel = [[YYLabel alloc] init];
    }
    return _tagLabel;
}

@end
