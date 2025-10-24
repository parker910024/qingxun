//
//  LLPostDynamicSelectLittleWorldView.m
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2020/1/7.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "LLPostDynamicSelectLittleWorldView.h"

#import "LLPostDynamicLittleWorldTagView.h"
#import "LLPostDynamicLittleWorldAlertView.h"

#import "LittleWorldDynamicPostWorld.h"

#import "XCTheme.h"
#import "UIButton+EnlargeTouchArea.h"
#import "TTStatisticsService.h"

#import <Masonry/Masonry.h>

@interface LLPostDynamicSelectLittleWorldView ()

@property (nonatomic, strong) UILabel *selectTipsLabel;//选择要发布的小世界
@property (nonatomic, strong) UILabel *reselectTipsLabel;//重新选择
@property (nonatomic, strong) UIButton *selectButton;//选择小世界按钮
@property (nonatomic, strong) UIButton *reselectButton;//重新选择按钮
@property (nonatomic, strong) LLPostDynamicLittleWorldTagView *selectTagView;//已选择小世界
@property (nonatomic, strong) UIButton *deleteButton;//已选择小世界删除按钮
@property (nonatomic, strong) UIImageView *selectArrowImageView;//选择小世界箭头

@property (nonatomic, strong) UIView *sepatateLine;//分割线

@property (nonatomic, strong) UILabel *hotChatTipsLabel;//最近大家都在聊的
@property (nonatomic, strong) UILabel *moreLabel;//查看更多
@property (nonatomic, strong) UIImageView *moreArrowImageView;//查看更多箭头
@property (nonatomic, strong) UIButton *moreButton;//查看更多按钮

@property (nonatomic, strong) NSMutableArray<LLPostDynamicLittleWorldTagView *> *worldTagViewList;//世界列表
@end

@implementation LLPostDynamicSelectLittleWorldView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        [self setupConstraint];
        
        //初始化显示
        self.selectWorld = nil;
        [self updateHotChatViewsHidenStatus:YES];
    }
    return self;
}

#pragma mark - Actions
///选择小世界按钮
- (void)onClickSelectButton:(UIButton *)sender {
    !self.selectWorldHandler ?: self.selectWorldHandler();
    
    LLPostDynamicLittleWorldAlertView *alert = [[LLPostDynamicLittleWorldAlertView alloc] init];
    alert.selectWorldHandler = ^(LittleWorldDynamicPostWorld * _Nonnull model) {
        self.selectWorld = model;
    };
    [alert show];
}

///重新选择按钮
- (void)onClickReselectButton:(UIButton *)sender {
    LLPostDynamicLittleWorldAlertView *alert = [[LLPostDynamicLittleWorldAlertView alloc] init];
    @weakify(self)
    alert.selectWorldHandler = ^(LittleWorldDynamicPostWorld * _Nonnull model) {
        @strongify(self)
        self.selectWorld = model;
    };
    [alert show];
}

///已选择小世界删除按钮
- (void)onClickDeleteButton:(UIButton *)sender {
    self.selectWorld = nil;
    
    !self.selectWorldHandler ?: self.selectWorldHandler();
}

///查看更多按钮
- (void)onClickMoreButton:(UIButton *)sender {
    !self.selectWorldHandler ?: self.selectWorldHandler();
    
    LLPostDynamicLittleWorldAlertView *alert = [[LLPostDynamicLittleWorldAlertView alloc] init];
    alert.currentSelectType = DynamicPostWorldRequestTypeAll;
    alert.selectWorldHandler = ^(LittleWorldDynamicPostWorld * _Nonnull model) {
        self.selectWorld = model;
    };
    [alert show];
}

#pragma mark - Private
- (void)setupView {
    [self addSubview:self.selectTipsLabel];
    [self addSubview:self.reselectTipsLabel];
    [self addSubview:self.selectButton];
    [self addSubview:self.reselectButton];
    [self addSubview:self.selectTagView];
    [self addSubview:self.deleteButton];
    [self addSubview:self.selectArrowImageView];
    [self addSubview:self.sepatateLine];
    [self addSubview:self.hotChatTipsLabel];
    [self addSubview:self.moreLabel];
    [self addSubview:self.moreArrowImageView];
    [self addSubview:self.moreButton];
}

- (void)setupConstraint {
    [self.sepatateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(55);
        make.left.right.mas_equalTo(self).inset(15);
        make.height.mas_equalTo(1);
    }];
    
    [self.selectArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    
    [self.selectTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(self.selectArrowImageView);
    }];
    
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(self.selectTipsLabel);
        make.right.mas_equalTo(self.selectArrowImageView);
        make.bottom.mas_equalTo(self.sepatateLine);
    }];
    
    [self.reselectTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.selectArrowImageView.mas_left).offset(-8);
        make.centerY.mas_equalTo(self.selectArrowImageView);
    }];
    
    [self.reselectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.reselectTipsLabel);
        make.top.bottom.mas_equalTo(self.selectButton);
        make.right.mas_equalTo(self.selectArrowImageView);
    }];
    
    [self.selectTagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.mas_equalTo(self.selectTipsLabel);
    }];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.selectTagView.mas_right).offset(8);
        make.centerY.mas_equalTo(self.selectTagView);
    }];
    
    [self.moreArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.sepatateLine.mas_bottom).offset(20);
        make.right.mas_equalTo(-20);
    }];
    
    [self.hotChatTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.selectTipsLabel);
        make.centerY.mas_equalTo(self.moreArrowImageView);
    }];
    
    [self.moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.moreArrowImageView.mas_left).offset(-8);
        make.centerY.mas_equalTo(self.moreArrowImageView);
    }];
    
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.reselectTipsLabel);
        make.right.centerY.mas_equalTo(self.moreArrowImageView);
        make.height.mas_equalTo(44);
    }];
}

- (void)layoutWorldTags {
    
    //移除旧世界标签
    if (self.worldTagViewList.count > 0) {
        for (LLPostDynamicLittleWorldTagView *view in self.worldTagViewList) {
            [view removeFromSuperview];
        }
        [self.worldTagViewList removeAllObjects];
    }
    
    CGFloat const margin = 20;//边距
    CGFloat const horiInterval = 10;//水平间距
    CGFloat const vertInterval = 10;//垂直间距
    CGFloat const maxWidth = CGRectGetWidth(self.frame) - margin*2;//最大宽度
    CGFloat const height = 26;
    CGFloat x = margin;
    CGFloat y = 16;
    
    for (LittleWorldDynamicPostWorld *world in self.worldArray) {
        @weakify(self)
        LLPostDynamicLittleWorldTagView *tagView = [[LLPostDynamicLittleWorldTagView alloc] init];
        tagView.model = world;
        tagView.selectTagHandler = ^{
            @strongify(self)
            [self didSelectWorld:world];
            
            [TTStatisticsService trackEvent:@"square_recommend_world" eventDescribe:world.worldName];
        };
        [self addSubview:tagView];
        [self.worldTagViewList addObject:tagView];
        
        CGFloat tagWidth = [tagView width];
        if (tagWidth > maxWidth) {
            tagWidth = maxWidth;
        }
        
        if (x > margin) {
            
            if (x + horiInterval + tagWidth > maxWidth) {
                //换行
                x = margin;
                y = y + vertInterval + height;
                
            } else {
                x += vertInterval;
            }
        }
        
        [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.hotChatTipsLabel.mas_bottom).offset(y);
            make.left.mas_equalTo(x);
            make.width.mas_equalTo(tagWidth);
        }];
        
        x += tagWidth;
    }
}

/// 选中小世界
- (void)didSelectWorld:(LittleWorldDynamicPostWorld *)world {
    self.selectWorld = world;
    
    !self.selectWorldHandler ?: self.selectWorldHandler();
}

/// 更新热聊相关视图显示状态
/// @param hiden 是否隐藏
- (void)updateHotChatViewsHidenStatus:(BOOL)hiden {
    
    self.hotChatTipsLabel.hidden = hiden;
    self.moreButton.hidden = hiden;
    self.moreLabel.hidden = hiden;
    self.moreArrowImageView.hidden = hiden;
}

#pragma mark - Setter Getter
- (void)setWorldArray:(NSArray<LittleWorldDynamicPostWorld *> *)worldArray {
    _worldArray = worldArray;
    
    BOOL noData = worldArray == nil || worldArray.count == 0;
    [self updateHotChatViewsHidenStatus:noData];
    [self layoutWorldTags];
}

- (void)setSelectWorld:(LittleWorldDynamicPostWorld *)selectWorld {
    _selectWorld = selectWorld;
    
    self.selectTagView.model = selectWorld;
    
    BOOL select = selectWorld != nil;
    self.selectTipsLabel.hidden = select;
    self.selectButton.hidden = select;
    self.selectTagView.hidden = !select;
    self.deleteButton.hidden = !select;
    self.reselectTipsLabel.hidden = !select;
    self.reselectButton.hidden = !select;
}

- (UILabel *)selectTipsLabel {
    if (!_selectTipsLabel) {
        _selectTipsLabel = [[UILabel alloc] init];
        _selectTipsLabel.text = @"选择要发布的小世界";
        _selectTipsLabel.font = [UIFont systemFontOfSize:15];
        _selectTipsLabel.textColor = [XCTheme getTTMainTextColor];
    }
    return _selectTipsLabel;
}

- (UILabel *)reselectTipsLabel {
    if (!_reselectTipsLabel) {
        _reselectTipsLabel = [[UILabel alloc] init];
        _reselectTipsLabel.text = @"重新选择";
        _reselectTipsLabel.font = [UIFont systemFontOfSize:13];
        _reselectTipsLabel.textColor = [XCTheme getTTDeepGrayTextColor];
    }
    return _reselectTipsLabel;
}

- (UIButton *)selectButton {
    if (!_selectButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(onClickSelectButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _selectButton = button;
    }
    return _selectButton;
}

- (UIButton *)reselectButton {
    if (!_reselectButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(onClickReselectButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _reselectButton = button;
    }
    return _reselectButton;
}

- (LLPostDynamicLittleWorldTagView *)selectTagView {
    if (!_selectTagView) {
        _selectTagView = [[LLPostDynamicLittleWorldTagView alloc] init];
    }
    return _selectTagView;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"littleWorld_post_delete"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onClickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];

        [button enlargeTouchArea:UIEdgeInsetsMake(8, 8, 8, 8)];
        
        _deleteButton = button;
    }
    return _deleteButton;
}

- (UIImageView *)selectArrowImageView {
    if (!_selectArrowImageView) {
        _selectArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"littleWorld_post_more"]];
    }
    return _selectArrowImageView;
}

- (UIView *)sepatateLine {
    if (!_sepatateLine) {
        _sepatateLine = [[UIView alloc] init];
        _sepatateLine.backgroundColor = UIColorFromRGB(0xf4f4f4);
    }
    return _sepatateLine;
}

- (UILabel *)hotChatTipsLabel {
    if (!_hotChatTipsLabel) {
        _hotChatTipsLabel = [[UILabel alloc] init];
        _hotChatTipsLabel.text = @"最近大家都在聊的";
        _hotChatTipsLabel.font = [UIFont systemFontOfSize:15];
        _hotChatTipsLabel.textColor = [XCTheme getTTMainTextColor];
    }
    return _hotChatTipsLabel;
}

- (UILabel *)moreLabel {
    if (!_moreLabel) {
        _moreLabel = [[UILabel alloc] init];
        _moreLabel.text = @"查看更多";
        _moreLabel.font = [UIFont systemFontOfSize:13];
        _moreLabel.textColor = [XCTheme getTTDeepGrayTextColor];
    }
    return _moreLabel;
}

- (UIImageView *)moreArrowImageView {
    if (!_moreArrowImageView) {
        _moreArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"littleWorld_post_more"]];
    }
    return _moreArrowImageView;
}

- (UIButton *)moreButton {
    if (!_moreButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(onClickMoreButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _moreButton = button;
    }
    return _moreButton;
}

- (NSMutableArray<LLPostDynamicLittleWorldTagView *> *)worldTagViewList {
    if (!_worldTagViewList) {
        _worldTagViewList = [NSMutableArray array];
    }
    return _worldTagViewList;
}

@end
