//
//  XCChatterboxGameContentView.m
//  AFNetworking
//
//  Created by apple on 2019/5/29.
//

#import "XCChatterboxGameContentView.h"
#import <Masonry/Masonry.h> // 约束
#import "XCMacros.h" // 约束的宏定义
#import "UIImageView+QiNiu.h"  // 加载图片
#import "XCTheme.h" // 颜色设置的宏定义

#import "AuthCore.h"

#import "XCChatterboxAttachment.h"
#import "TTChatterboxGameModel.h"
#import "TTCPGamePrivateChatClient.h"
#import "ImMessageCore.h"

#define kScale(x) ((x) / 375.0 * KScreenWidth)

#define fontSize kScale(13)

@interface XCChatterboxGameContentView ()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIImageView *chatterImageView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

// 2  CP
@property (nonatomic, strong) UILabel *cpLeftLabel;
@property (nonatomic, strong) UILabel *cpLabel;

// 3  秘密
@property (nonatomic, strong) UILabel *secretLeftLabel;
@property (nonatomic, strong) UILabel *secretLabel;

// 4 要求
@property (nonatomic, strong) UILabel *requireLeftLabel;
@property (nonatomic, strong) UILabel *requireLabel;

// 5 吃什么
@property (nonatomic, strong) UILabel *eatLeftLabel;
@property (nonatomic, strong) UILabel *eatLabel;

// 6 笑话
@property (nonatomic, strong) UILabel *jokeLeftLabel;
@property (nonatomic, strong) UILabel *jokeLabel;

// 7 语音
@property (nonatomic, strong) UILabel *voiceLeftLabel;
@property (nonatomic, strong) UILabel *voiceLabel;

// 8 礼物
@property (nonatomic, strong) UILabel *giftLeftLabel;
@property (nonatomic, strong) UILabel *giftLabel;

// 9 一首歌
@property (nonatomic, strong) UILabel *musicLeftLabel;
@property (nonatomic, strong) UILabel *musicLabel;

// 10 一天
@property (nonatomic, strong) UILabel *dayLeftLabel;
@property (nonatomic, strong) UILabel *dayLabel;

// 11 故事
@property (nonatomic, strong) UILabel *storyLeftLabel;
@property (nonatomic, strong) UILabel *storyLabel;

// 12 选择上述一条
@property (nonatomic, strong) UILabel *changeLeftLabel;
@property (nonatomic, strong) UILabel *changeLabel;

@property (nonatomic, strong) UIButton *tossButton;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NIMMessage *boxMessage;

@end

@implementation XCChatterboxGameContentView

- (instancetype)initSessionMessageContentView {
    if (self = [super initSessionMessageContentView]) {
        
        [self initView];
        
        [self layoutSubviewsWithFrame];
    }
    return self;
}

- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];

    NIMCustomObject *object = (NIMCustomObject *)data.message.messageObject;
    
    XCChatterboxAttachment *customObject = (XCChatterboxAttachment*)object.attachment;
    
    TTChatterboxGameModel *customModel = [TTChatterboxGameModel modelDictionary:customObject.data];
    
    NSDate *dateNow = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    
    NSDate *dateOld = [NSDate dateWithTimeIntervalSince1970:customModel.startTime / 1000];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay;//只比较天数差异
    //比较的结果是NSDateComponents类对象
    NSDateComponents *delta = [calendar components:unit fromDate:dateOld toDate:dateNow options:0];

    if (customModel.listArray.count > 0) {
        for (int i = 0; i < customModel.listArray.count; i++) {
            UILabel *textLabel = [self.dataArray safeObjectAtIndex:i];
            textLabel.text = [customModel.listArray safeObjectAtIndex:i][@"content"];
        }
    }
    
    self.boxMessage = data.message;
    
    if (data.message.localExt) {
        
        TTChatterboxGameModel *model = [TTChatterboxGameModel modelDictionary:data.message.localExt];
        
        if (model.status == TTChatterboxGameType_send) {
            if (labs(delta.day) > 3) {
                [self.tossButton setTitle:@"已过期" forState:UIControlStateSelected];
            }
            self.tossButton.selected = YES;
            self.tossButton.userInteractionEnabled = NO;
        } else {
            if (labs(delta.day) > 3) {
                [self.tossButton setTitle:@"已过期" forState:UIControlStateSelected];
                self.tossButton.selected = YES;
                self.tossButton.userInteractionEnabled = NO;
            } else {
                self.tossButton.selected = NO;
                self.tossButton.userInteractionEnabled = YES;
            }
        }
    } else {
        if (labs(delta.day) > 3) {
            [self.tossButton setTitle:@"已过期" forState:UIControlStateSelected];
            self.tossButton.selected = YES;
            self.tossButton.userInteractionEnabled = NO;
        } else {
            self.tossButton.selected = NO;
            self.tossButton.userInteractionEnabled = YES;
        }
    }
}

- (void)initView {
    
    [self addSubview:self.topView];
    
    [self.topView addSubview:self.backView];
    
    [self.backView addSubview:self.chatterImageView];
    
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.subTitleLabel];
    
    [self.backView addSubview:self.cpLeftLabel];
    [self.backView addSubview:self.cpLabel];
    
    [self.backView addSubview:self.secretLeftLabel];
    [self.backView addSubview:self.secretLabel];
    
    [self.backView addSubview:self.requireLeftLabel];
    [self.backView addSubview:self.requireLabel];
    
    [self.backView addSubview:self.eatLeftLabel];
    [self.backView addSubview:self.eatLabel];
    
    [self.backView addSubview:self.jokeLeftLabel];
    [self.backView addSubview:self.jokeLabel];
    
    [self.backView addSubview:self.voiceLeftLabel];
    [self.backView addSubview:self.voiceLabel];
    
    [self.backView addSubview:self.giftLeftLabel];
    [self.backView addSubview:self.giftLabel];
    
    [self.backView addSubview:self.musicLeftLabel];
    [self.backView addSubview:self.musicLabel];
    
    [self.backView addSubview:self.dayLeftLabel];
    [self.backView addSubview:self.dayLabel];
    
    [self.backView addSubview:self.storyLeftLabel];
    [self.backView addSubview:self.storyLabel];
    
    [self.backView addSubview:self.changeLeftLabel];
    [self.backView addSubview:self.changeLabel];
    
    [self addSubview:self.tossButton];
    
    [self.dataArray addObject:self.cpLabel];
    [self.dataArray addObject:self.secretLabel];
    [self.dataArray addObject:self.requireLabel];
    [self.dataArray addObject:self.eatLabel];
    [self.dataArray addObject:self.jokeLabel];
    [self.dataArray addObject:self.voiceLabel];
    [self.dataArray addObject:self.giftLabel];
    [self.dataArray addObject:self.musicLabel];
    [self.dataArray addObject:self.dayLabel];
    [self.dataArray addObject:self.storyLabel];
    [self.dataArray addObject:self.changeLabel];
    
}

- (void)layoutSubviewsWithFrame {
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-kScale(26));
    }];
    
    [self.chatterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.top.mas_equalTo(kScale(15));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.chatterImageView.mas_right).offset(7);
        make.top.mas_equalTo(kScale(19));
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.chatterImageView.mas_bottom).offset(2);
    }];
    
    [self.cpLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.subTitleLabel.mas_bottom).offset(kScale(24));
        make.size.mas_equalTo(CGSizeMake(kScale(17), kScale(18)));
    }];
    
    [self.cpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.cpLeftLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(self.cpLeftLabel);
    }];
    
    [self.secretLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.cpLeftLabel.mas_bottom).offset(kScale(17));
        make.size.mas_equalTo(CGSizeMake(kScale(17), kScale(18)));
    }];
    
    [self.secretLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.secretLeftLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(self.secretLeftLabel);
    }];
    
    [self.requireLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.secretLeftLabel.mas_bottom).offset(kScale(17));
        make.size.mas_equalTo(CGSizeMake(kScale(17), kScale(18)));
    }];
    
    [self.requireLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.requireLeftLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(self.requireLeftLabel);
    }];
    
    [self.eatLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.requireLeftLabel.mas_bottom).offset(kScale(17));
        make.size.mas_equalTo(CGSizeMake(kScale(17), kScale(18)));
    }];
    
    [self.eatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.eatLeftLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(self.eatLeftLabel);
    }];
    
    [self.jokeLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.eatLeftLabel.mas_bottom).offset(kScale(17));
        make.size.mas_equalTo(CGSizeMake(kScale(17), kScale(18)));
    }];
    
    [self.jokeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.jokeLeftLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(self.jokeLeftLabel);
    }];
    
    [self.voiceLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.jokeLeftLabel.mas_bottom).offset(kScale(17));
        make.size.mas_equalTo(CGSizeMake(kScale(17), kScale(18)));
    }];
    
    [self.voiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.voiceLeftLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(self.voiceLeftLabel);
    }];
    
    [self.giftLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.voiceLeftLabel.mas_bottom).offset(kScale(17));
        make.size.mas_equalTo(CGSizeMake(kScale(17), kScale(18)));
    }];
    
    [self.giftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.giftLeftLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(self.giftLeftLabel);
    }];
    
    [self.musicLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.giftLeftLabel.mas_bottom).offset(kScale(17));
        make.size.mas_equalTo(CGSizeMake(kScale(17), kScale(18)));
    }];
    
    [self.musicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.musicLeftLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(self.musicLeftLabel);
    }];
    
    [self.dayLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.musicLeftLabel.mas_bottom).offset(kScale(17));
        make.size.mas_equalTo(CGSizeMake(kScale(17), kScale(18)));
    }];
    
    [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dayLeftLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(self.dayLeftLabel);
    }];
    
    [self.storyLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.dayLeftLabel.mas_bottom).offset(kScale(17));
        make.size.mas_equalTo(CGSizeMake(kScale(17), kScale(18)));
    }];
    
    [self.storyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.storyLeftLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(self.storyLeftLabel);
    }];
    
    [self.changeLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.storyLeftLabel.mas_bottom).offset(kScale(17));
        make.size.mas_equalTo(CGSizeMake(kScale(17), kScale(18)));
    }];
    
    [self.changeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.changeLeftLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(self.changeLeftLabel);
    }];
    
    [self.tossButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kScale(123), kScale(53)));
        make.centerX.mas_equalTo(self);
    }];
}

- (void)tossBtnAction:(UIButton *)sender {
    
    [[BaiduMobStat defaultStat] logEvent:@"message-chatterbox-points" eventLabel:@"消息-发起话匣子-抛点数"];
#ifdef DEBUG
    NSLog(@"message-chatterbox-points");
#else
#endif
    
    sender.userInteractionEnabled = NO;
    sender.selected = YES;
    
    NIMCustomObject *object = (NIMCustomObject *)self.boxMessage.messageObject;
    
    XCChatterboxAttachment *customObject = (XCChatterboxAttachment*)object.attachment;
    
    TTChatterboxGameModel *model = [TTChatterboxGameModel modelDictionary:customObject.data];
    
    TTChatterboxGameModel *customModel = [[TTChatterboxGameModel alloc] init];
    
    customModel.status = TTChatterboxGameType_send;
    customModel.startTime = model.startTime;
    self.boxMessage.localExt = [customModel model2dictionary];

    [GetCore(ImMessageCore) updateMessage:self.boxMessage
                                  session:self.boxMessage.session];
    
    NotifyCoreClient(TTCPGamePrivateChatClient, @selector(chatterboxGamePointCount:), chatterboxGamePointCount:self.boxMessage);
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    }
    return _topView;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = UIColorFromRGB(0xffffff);
        _backView.layer.cornerRadius = 12;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}

- (UIImageView *)chatterImageView {
    if (!_chatterImageView) {
        _chatterImageView = [[UIImageView alloc] init];
        _chatterImageView.image = [UIImage imageNamed:@"chat_say_game"];
    }
    return _chatterImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"话匣子游戏";
        _titleLabel.font = [UIFont boldSystemFontOfSize:kScale(17)];
        _titleLabel.textColor = XCTheme.getTTMainColor;
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.text = @"双方骰子点数相加，并共同完成下列事情";
        _subTitleLabel.font = [UIFont systemFontOfSize:kScale(12)];
        _subTitleLabel.textColor = XCTheme.getTTDeepGrayTextColor;
    }
    return _subTitleLabel;
}

- (UILabel *)cpLeftLabel {
    if (!_cpLeftLabel) {
        _cpLeftLabel = [[UILabel alloc] init];
        _cpLeftLabel.backgroundColor = XCTheme.getTTMainColor;
        _cpLeftLabel.font = [UIFont systemFontOfSize:11];
        _cpLeftLabel.text = @"2";
        _cpLeftLabel.textColor = UIColorFromRGB(0xffffff);
        _cpLeftLabel.textAlignment = NSTextAlignmentCenter;
        _cpLeftLabel.layer.cornerRadius = 5;
        _cpLeftLabel.layer.masksToBounds = YES;
    }
    return _cpLeftLabel;
}

- (UILabel *)cpLabel {
    if (!_cpLabel) {
        _cpLabel = [[UILabel alloc] init];
        _cpLabel.font = [UIFont systemFontOfSize:fontSize];
        _cpLabel.textColor = XCTheme.getTTSubTextColor;
    }
    return _cpLabel;
}

- (UILabel *)secretLeftLabel {
    if (!_secretLeftLabel) {
        _secretLeftLabel = [[UILabel alloc] init];
        _secretLeftLabel.backgroundColor = XCTheme.getTTMainColor;
        _secretLeftLabel.font = [UIFont systemFontOfSize:11];
        _secretLeftLabel.text = @"3";
        _secretLeftLabel.textColor = UIColorFromRGB(0xffffff);
        _secretLeftLabel.textAlignment = NSTextAlignmentCenter;
        _secretLeftLabel.layer.cornerRadius = 5;
        _secretLeftLabel.layer.masksToBounds = YES;
    }
    return _secretLeftLabel;
}

- (UILabel *)secretLabel {
    if (!_secretLabel) {
        _secretLabel = [[UILabel alloc] init];
        _secretLabel.font = [UIFont systemFontOfSize:fontSize];
        _secretLabel.textColor = XCTheme.getTTSubTextColor;
    }
    return _secretLabel;
}

- (UILabel *)requireLeftLabel {
    if (!_requireLeftLabel) {
        _requireLeftLabel = [[UILabel alloc] init];
        _requireLeftLabel.backgroundColor = XCTheme.getTTMainColor;
        _requireLeftLabel.font = [UIFont systemFontOfSize:11];
        _requireLeftLabel.text = @"4";
        _requireLeftLabel.textColor = UIColorFromRGB(0xffffff);
        _requireLeftLabel.textAlignment = NSTextAlignmentCenter;
        _requireLeftLabel.layer.cornerRadius = 5;
        _requireLeftLabel.layer.masksToBounds = YES;
    }
    return _requireLeftLabel;
}

- (UILabel *)requireLabel {
    if (!_requireLabel) {
        _requireLabel = [[UILabel alloc] init];
        _requireLabel.font = [UIFont systemFontOfSize:fontSize];
        _requireLabel.textColor = XCTheme.getTTSubTextColor;
    }
    return _requireLabel;
}

- (UILabel *)eatLeftLabel {
    if (!_eatLeftLabel) {
        _eatLeftLabel = [[UILabel alloc] init];
        _eatLeftLabel.backgroundColor = XCTheme.getTTMainColor;
        _eatLeftLabel.font = [UIFont systemFontOfSize:11];
        _eatLeftLabel.text = @"5";
        _eatLeftLabel.textColor = UIColorFromRGB(0xffffff);
        _eatLeftLabel.textAlignment = NSTextAlignmentCenter;
        _eatLeftLabel.layer.cornerRadius = 5;
        _eatLeftLabel.layer.masksToBounds = YES;
    }
    return _eatLeftLabel;
}

- (UILabel *)eatLabel {
    if (!_eatLabel) {
        _eatLabel = [[UILabel alloc] init];
        _eatLabel.font = [UIFont systemFontOfSize:fontSize];
        _eatLabel.textColor = XCTheme.getTTSubTextColor;
    }
    return _eatLabel;
}

- (UILabel *)jokeLeftLabel {
    if (!_jokeLeftLabel) {
        _jokeLeftLabel = [[UILabel alloc] init];
        _jokeLeftLabel.backgroundColor = XCTheme.getTTMainColor;
        _jokeLeftLabel.font = [UIFont systemFontOfSize:11];
        _jokeLeftLabel.text = @"6";
        _jokeLeftLabel.textColor = UIColorFromRGB(0xffffff);
        _jokeLeftLabel.textAlignment = NSTextAlignmentCenter;
        _jokeLeftLabel.layer.cornerRadius = 5;
        _jokeLeftLabel.layer.masksToBounds = YES;
    }
    return _jokeLeftLabel;
}

- (UILabel *)jokeLabel {
    if (!_jokeLabel) {
        _jokeLabel = [[UILabel alloc] init];
        _jokeLabel.font = [UIFont systemFontOfSize:fontSize];
        _jokeLabel.textColor = XCTheme.getTTSubTextColor;
    }
    return _jokeLabel;
}

- (UILabel *)voiceLeftLabel {
    if (!_voiceLeftLabel) {
        _voiceLeftLabel = [[UILabel alloc] init];
        _voiceLeftLabel.backgroundColor = XCTheme.getTTMainColor;
        _voiceLeftLabel.font = [UIFont systemFontOfSize:11];
        _voiceLeftLabel.text = @"7";
        _voiceLeftLabel.textColor = UIColorFromRGB(0xffffff);
        _voiceLeftLabel.textAlignment = NSTextAlignmentCenter;
        _voiceLeftLabel.layer.cornerRadius = 5;
        _voiceLeftLabel.layer.masksToBounds = YES;
    }
    return _voiceLeftLabel;
}

- (UILabel *)voiceLabel {
    if (!_voiceLabel) {
        _voiceLabel = [[UILabel alloc] init];
        _voiceLabel.font = [UIFont systemFontOfSize:fontSize];
        _voiceLabel.textColor = XCTheme.getTTSubTextColor;
    }
    return _voiceLabel;
}

- (UILabel *)giftLeftLabel {
    if (!_giftLeftLabel) {
        _giftLeftLabel = [[UILabel alloc] init];
        _giftLeftLabel.backgroundColor = XCTheme.getTTMainColor;
        _giftLeftLabel.font = [UIFont systemFontOfSize:11];
        _giftLeftLabel.text = @"8";
        _giftLeftLabel.textColor = UIColorFromRGB(0xffffff);
        _giftLeftLabel.textAlignment = NSTextAlignmentCenter;
        _giftLeftLabel.layer.cornerRadius = 5;
        _giftLeftLabel.layer.masksToBounds = YES;
    }
    return _giftLeftLabel;
}

- (UILabel *)giftLabel {
    if (!_giftLabel) {
        _giftLabel = [[UILabel alloc] init];
        _giftLabel.font = [UIFont systemFontOfSize:fontSize];
        _giftLabel.textColor = XCTheme.getTTSubTextColor;
    }
    return _giftLabel;
}

- (UILabel *)musicLeftLabel {
    if (!_musicLeftLabel) {
        _musicLeftLabel = [[UILabel alloc] init];
        _musicLeftLabel.backgroundColor = XCTheme.getTTMainColor;
        _musicLeftLabel.font = [UIFont systemFontOfSize:11];
        _musicLeftLabel.text = @"9";
        _musicLeftLabel.textColor = UIColorFromRGB(0xffffff);
        _musicLeftLabel.textAlignment = NSTextAlignmentCenter;
        _musicLeftLabel.layer.cornerRadius = 5;
        _musicLeftLabel.layer.masksToBounds = YES;
    }
    return _musicLeftLabel;
}

- (UILabel *)musicLabel {
    if (!_musicLabel) {
        _musicLabel = [[UILabel alloc] init];
        _musicLabel.font = [UIFont systemFontOfSize:fontSize];
        _musicLabel.textColor = XCTheme.getTTSubTextColor;
    }
    return _musicLabel;
}

- (UILabel *)dayLeftLabel {
    if (!_dayLeftLabel) {
        _dayLeftLabel = [[UILabel alloc] init];
        _dayLeftLabel.backgroundColor = XCTheme.getTTMainColor;
        _dayLeftLabel.font = [UIFont systemFontOfSize:11];
        _dayLeftLabel.text = @"10";
        _dayLeftLabel.textColor = UIColorFromRGB(0xffffff);
        _dayLeftLabel.textAlignment = NSTextAlignmentCenter;
        _dayLeftLabel.layer.cornerRadius = 5;
        _dayLeftLabel.layer.masksToBounds = YES;
    }
    return _dayLeftLabel;
}

- (UILabel *)dayLabel {
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc] init];
        _dayLabel.font = [UIFont systemFontOfSize:fontSize];
        _dayLabel.textColor = XCTheme.getTTSubTextColor;
    }
    return _dayLabel;
}

- (UILabel *)storyLeftLabel {
    if (!_storyLeftLabel) {
        _storyLeftLabel = [[UILabel alloc] init];
        _storyLeftLabel.backgroundColor = XCTheme.getTTMainColor;
        _storyLeftLabel.font = [UIFont systemFontOfSize:11];
        _storyLeftLabel.text = @"11";
        _storyLeftLabel.textColor = UIColorFromRGB(0xffffff);
        _storyLeftLabel.textAlignment = NSTextAlignmentCenter;
        _storyLeftLabel.layer.cornerRadius = 5;
        _storyLeftLabel.layer.masksToBounds = YES;
    }
    return _storyLeftLabel;
}

- (UILabel *)storyLabel {
    if (!_storyLabel) {
        _storyLabel = [[UILabel alloc] init];
        _storyLabel.font = [UIFont systemFontOfSize:fontSize];
        _storyLabel.textColor = XCTheme.getTTSubTextColor;
    }
    return _storyLabel;
}

- (UILabel *)changeLeftLabel {
    if (!_changeLeftLabel) {
        _changeLeftLabel = [[UILabel alloc] init];
        _changeLeftLabel.backgroundColor = XCTheme.getTTMainColor;
        _changeLeftLabel.font = [UIFont systemFontOfSize:11];
        _changeLeftLabel.text = @"12";
        _changeLeftLabel.textColor = UIColorFromRGB(0xffffff);
        _changeLeftLabel.textAlignment = NSTextAlignmentCenter;
        _changeLeftLabel.layer.cornerRadius = 5;
        _changeLeftLabel.layer.masksToBounds = YES;
    }
    return _changeLeftLabel;
}

- (UILabel *)changeLabel {
    if (!_changeLabel) {
        _changeLabel = [[UILabel alloc] init];
        _changeLabel.font = [UIFont systemFontOfSize:fontSize];
        _changeLabel.textColor = XCTheme.getTTSubTextColor;
    }
    return _changeLabel;
}

- (UIButton *)tossButton {
    if (!_tossButton) {
        _tossButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tossButton setBackgroundImage:[UIImage imageNamed:@"chat_button_say"] forState:UIControlStateNormal];
        [_tossButton setBackgroundImage:[UIImage imageNamed:@"chat_button_say_gray"] forState:UIControlStateSelected];
        [_tossButton setTitle:@"抛点数" forState:UIControlStateNormal];
        [_tossButton setTitle:@"已抛" forState:UIControlStateSelected];
        [_tossButton setTitleEdgeInsets:UIEdgeInsetsMake(-10, 0, 0, 0)];
        [_tossButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _tossButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_tossButton addTarget:self action:@selector(tossBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tossButton;
}


@end
