//
//  XCCPGamePrivateChatView.m
//  TTPlay
//
//  Created by new on 2019/2/15.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "XCCPGamePrivateChatView.h"

#import "NSObject+YYModel.h"
#import "XCFamily.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "UIImageView+QiNiu.h"
#import "RoomInfo.h"
#import "GroupModel.h"
#import "XCCPGamePrivateAttachment.h"

#import "CoreManager.h"
#import "AuthCore.h"
#import "UserCore.h"
#import "TTGameCPPrivateChatModel.h"
#import "ImMessageCore.h"
#import "TTCPGamePrivateChatCore.h"
#import "TTCPGamePrivateChatClient.h"
#import "XCHUDTool.h"
#import "TTCPGameStaticCore.h"
#import "TTCPGameOverAndSelectClient.h"
#import "TTGameStaticTypeCore.h"

@interface XCCPGamePrivateChatView ()

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIButton *titleButton;

@property (nonatomic, strong) UIImageView *backImageView;

@property (nonatomic, strong) UIView *upToView;

@property (nonatomic, strong) UILabel *timerLabel;

@property (nonatomic, strong) UILabel *waitLabel; // 等待对方接受 自己方显示的等待

@property (nonatomic, strong) UIButton *enterButton;  // 接受  对方去点

@property (nonatomic, strong) UIView *montmorilloniteView; // 半透明蒙层

@property (nonatomic, strong) dispatch_source_t mainTimer11; // 倒计时 计时器

@property (nonatomic, assign) NSInteger timerTime;  // 发送方倒计时 60秒

@property (nonatomic, assign) NSInteger otherTimerTime;  // 接收方倒计时 60秒  可以和上面用一个，这里这么做是为了区别对待，便于区分

@property (nonatomic, strong) NIMMessage *globalMessage;
@end

@implementation XCCPGamePrivateChatView


- (instancetype)initSessionMessageContentView{
    if (self = [super initSessionMessageContentView]) {
        
        [self initView];
        [self layoutSubviewsWithFrame];
        
        AddCoreClient(TTCPGameOverAndSelectClient, self);
    }
    return self;
}



- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];
    
    NIMCustomObject *object = (NIMCustomObject *)data.message.messageObject;
    XCCPGamePrivateAttachment *customObject = (XCCPGamePrivateAttachment*)object.attachment;
    _montmorilloniteView.hidden = YES;
    
    if (!data.message.localExt) {
        TTGameCPPrivateChatModel *messageModel = [TTGameCPPrivateChatModel modelDictionary:customObject.data];
        if (messageModel.status == TTGameStatusTypeTimeing) {
            NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
            NSTimeInterval time = [date timeIntervalSince1970] * 1000;// * 1000 是精确到毫秒，不乘就是精确到秒
            NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
            
            NSDate *dateNow = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
            
            NSDate *dateOld = [NSDate dateWithTimeIntervalSince1970:messageModel.startTime / 1000];
            
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSCalendarUnit unit = NSCalendarUnitSecond;//只比较天数差异
            //比较的结果是NSDateComponents类对象
            NSDateComponents *delta = [calendar components:unit fromDate:dateOld toDate:dateNow options:0];
            if (labs(delta.second) < 1800) {
                messageModel.startTime = timeString.userIDValue;
                
                data.message.localExt = [messageModel model2dictionary];
            }
        }
    }
    self.globalMessage = data.message;
    
    if (data.message.localExt) {
        //        NSLog(@"消息状态改变了");
        TTGameCPPrivateChatModel *model = [TTGameCPPrivateChatModel modelDictionary:data.message.localExt];
        if (model.status == TTGameStatusTypeInvalid) {
            
            if (self.mainTimer11) {
                dispatch_source_cancel(self.mainTimer11);
                self.mainTimer11 = nil;
            }
            
            if ([data.message.from isEqualToString:GetCore(AuthCore).getUid]) {
                [GetCore(TTCPGamePrivateChatCore).myMessageDic removeObjectForKey:data.message.messageId];
            }else{
                [GetCore(TTCPGamePrivateChatCore).youMessageDic removeObjectForKey:data.message.messageId];
            }
            self.enterButton.hidden = YES;
            self.waitLabel.hidden = NO;
            self.timerLabel.hidden = YES;
            self.waitLabel.text = @"已失效";
            _montmorilloniteView.hidden = NO;
            [self.titleButton setTitle:[NSString stringWithFormat:@"  %@  ",model.gameInfo.gameName] forState:UIControlStateNormal];
            
            [self.backImageView qn_setImageImageWithUrl:model.gameInfo.gamePicture placeholderImage:@"game_home_itemBg" type:(ImageType)ImageTypeUserLibaryDetail];
            
        }else if (model.status == TTGameStatusTypeTimeing){
            if ([data.message.from isEqualToString:GetCore(AuthCore).getUid]) {
                self.enterButton.hidden = YES;
                self.waitLabel.hidden = NO;
                self.timerLabel.hidden = NO;
                _montmorilloniteView.hidden = YES;
                self.waitLabel.text = @"等待对方接受邀请";
                
                @weakify(self);
                if (self.mainTimer11) {
                    dispatch_source_cancel(self.mainTimer11);
                    self.mainTimer11 = nil;
                }
                if (!self.mainTimer11) {
                    [self createGCDTimerWithModel:model message:data.message];
                }
            }else{
                
                @weakify(self);
                if (self.mainTimer11) {
                    dispatch_source_cancel(self.mainTimer11);
                    self.mainTimer11 = nil;
                }
                if (!self.mainTimer11) {
                    [self createGCDTimerWithModel:model message:data.message];
                }
                self.enterButton.hidden = NO;
                self.waitLabel.hidden = YES;
                self.timerLabel.hidden = NO;
                _montmorilloniteView.hidden = YES;
            }
            [self.titleButton setTitle:[NSString stringWithFormat:@"  %@  ",model.gameInfo.gameName] forState:UIControlStateNormal];
            
            [self.backImageView qn_setImageImageWithUrl:model.gameInfo.gamePicture placeholderImage:@"game_home_itemBg" type:(ImageType)ImageTypeUserLibaryDetail];
        }else if (model.status == TTGameStatusTypeAccept){
            if (self.mainTimer11) {
                dispatch_source_cancel(self.mainTimer11);
                self.mainTimer11 = nil;
            }
            if ([data.message.from isEqualToString:GetCore(AuthCore).getUid]) {
                [GetCore(TTCPGamePrivateChatCore).myMessageDic removeObjectForKey:data.message.messageId];
            }else{
                [GetCore(TTCPGamePrivateChatCore).youMessageDic removeObjectForKey:data.message.messageId];
            }
            self.enterButton.hidden = YES;
            self.waitLabel.hidden = NO;
            self.timerLabel.hidden = YES;
            self.waitLabel.text = @"约战已结束";
            _montmorilloniteView.hidden = NO;
            [self.titleButton setTitle:[NSString stringWithFormat:@"  %@  ",model.gameInfo.gameName] forState:UIControlStateNormal];
            
            [self.backImageView qn_setImageImageWithUrl:model.gameInfo.gamePicture placeholderImage:@"game_home_itemBg" type:(ImageType)ImageTypeUserLibaryDetail];
        }
    }else{
        self.timerLabel.hidden = NO;
        
        __weak typeof(self) weakSelf = self;
        
        TTGameCPPrivateChatModel *model = [TTGameCPPrivateChatModel modelDictionary:customObject.data];
        
        [self.titleButton setTitle:[NSString stringWithFormat:@"  %@  ",model.gameInfo.gameName] forState:UIControlStateNormal];
        
        [self.backImageView qn_setImageImageWithUrl:model.gameInfo.gamePicture placeholderImage:@"game_home_itemBg" type:(ImageType)ImageTypeUserLibaryDetail];
        
        if ([data.message.from isEqualToString:GetCore(AuthCore).getUid]) {
            self.enterButton.hidden = YES;
            self.waitLabel.hidden = NO;
            self.waitLabel.text = @"等待对方接受邀请...";
            
            data.message.localExt = [model model2dictionary];
            
            NSDate *dateNow = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
            
            NSDate *dateOld = [NSDate dateWithTimeIntervalSince1970:model.startTime / 1000];
            
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSCalendarUnit unit = NSCalendarUnitSecond;//只比较天数差异
            //比较的结果是NSDateComponents类对象
            NSDateComponents *delta = [calendar components:unit fromDate:dateOld toDate:dateNow options:0];
            NSLog(@"相差多少秒%ld",delta.second);
            
            if (GetCore(TTCPGameStaticCore).gameTime - delta.second <= 0 || delta.second < 0) {
                if (self.mainTimer11) {
                    dispatch_source_cancel(self.mainTimer11);
                    self.mainTimer11 = nil;
                }
                TTGameCPPrivateChatModel *launchGameModel = [TTGameCPPrivateChatModel modelDictionary:data.message.localExt];
                launchGameModel.status = TTGameStatusTypeInvalid;
                launchGameModel.uuId = data.message.messageId;
                
                data.message.localExt = [launchGameModel model2dictionary];
                
                [GetCore(ImMessageCore) updateMessage:data.message
                                              session:data.message.session];
            }else{
                @weakify(self);
                if (self.mainTimer11) {
                    dispatch_source_cancel(self.mainTimer11);
                    self.mainTimer11 = nil;
                }
                if (!self.mainTimer11) {
                    self.timerTime = GetCore(TTCPGameStaticCore).gameTime - delta.second;
                    dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    
                    self.mainTimer11 = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, global);
                    
                    dispatch_source_set_timer(self.mainTimer11, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
                    
                    dispatch_source_set_event_handler(self.mainTimer11, ^{
                        @strongify(self);
                        //1. 每调用一次 时间-1s
                        self.timerTime--;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            weakSelf.timerLabel.text = [NSString stringWithFormat:@"%ld",self.timerTime];
                        });
                        if (self.timerTime <= 0) {
                            dispatch_source_cancel(self.mainTimer11);
                            self.mainTimer11 = nil;
                            TTGameCPPrivateChatModel *launchGameModel = [TTGameCPPrivateChatModel modelDictionary:data.message.localExt];
                            launchGameModel.status = TTGameStatusTypeInvalid;
                            launchGameModel.uuId = data.message.messageId;
                            
                            data.message.localExt = [launchGameModel model2dictionary];
                            
                            [GetCore(ImMessageCore) updateMessage:data.message
                                                          session:data.message.session];
                        }
                    });
                    dispatch_resume(self.mainTimer11);
                }
            }
        }else{
            self.enterButton.hidden = NO;
            self.waitLabel.hidden = YES;
            
            NSDate *dateNow = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
            
            NSDate *dateOld = [NSDate dateWithTimeIntervalSince1970:model.startTime / 1000];
            
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSCalendarUnit unit = NSCalendarUnitSecond;//只比较天数差异
            //比较的结果是NSDateComponents类对象
            NSDateComponents *delta = [calendar components:unit fromDate:dateOld toDate:dateNow options:0];
            NSLog(@"相差多少秒%ld",delta.second);
            
            if (GetCore(TTCPGameStaticCore).gameTime - delta.second <= 0 || delta.second < 0) {
                if (self.mainTimer11) {
                    dispatch_source_cancel(self.mainTimer11);
                    self.mainTimer11 = nil;
                }
                TTGameCPPrivateChatModel *launchGameModel = [TTGameCPPrivateChatModel modelDictionary:customObject.data];
                launchGameModel.status = TTGameStatusTypeInvalid;
                launchGameModel.uuId = data.message.messageId;
                
                data.message.localExt = [launchGameModel model2dictionary];
                
                [GetCore(ImMessageCore) updateMessage:data.message
                                              session:data.message.session];
            }else{
                
                data.message.localExt = [model model2dictionary];
                @weakify(self);
                if (self.mainTimer11) {
                    dispatch_source_cancel(self.mainTimer11);
                    self.mainTimer11 = nil;
                }
                if (!self.mainTimer11) {
                    @strongify(self);
                    
                    if (delta.second < 0) {
                        NSCalendar *calendar = [NSCalendar currentCalendar];
                        NSCalendarUnit unitFlags = NSCalendarUnitSecond;//只比较秒数差异
                        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:dateNow];
                        
                        self.otherTimerTime = GetCore(TTCPGameStaticCore).gameTime - dateComponent.second;
                    }else{
                        self.otherTimerTime = GetCore(TTCPGameStaticCore).gameTime - delta.second;
                    }
                    
                    dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    
                    self.mainTimer11 = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, global);
                    
                    dispatch_source_set_timer(self.mainTimer11, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
                    
                    dispatch_source_set_event_handler(self.mainTimer11, ^{
                        //1. 每调用一次 时间-1s
                        self.otherTimerTime--;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.timerLabel.text = [NSString stringWithFormat:@"%ld",self.otherTimerTime];
                        });
                        if (self.otherTimerTime <= 0) {
                            dispatch_source_cancel(self.mainTimer11);
                            self.mainTimer11 = nil;
                            TTGameCPPrivateChatModel *launchGameModel = [TTGameCPPrivateChatModel modelDictionary:data.message.localExt];
                            launchGameModel.status = TTGameStatusTypeInvalid;
                            launchGameModel.uuId = data.message.messageId;
                            
                            data.message.localExt = [launchGameModel model2dictionary];
                            
                            [GetCore(ImMessageCore) updateMessage:data.message
                                                          session:data.message.session];
                        }
                    });
                    dispatch_resume(self.mainTimer11);
                }
            }
            
        }
    }
    
    
}

- (void)acceptGameAction:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    NIMCustomObject *object = (NIMCustomObject *)self.globalMessage.messageObject;
    XCCPGamePrivateAttachment *customObject = (XCCPGamePrivateAttachment*)object.attachment;
    
    TTGameCPPrivateChatModel *model = [TTGameCPPrivateChatModel modelDictionary:customObject.data];
    
    @weakify(self);
    [[GetCore(TTCPGamePrivateChatCore) requestGameUrlFromPrivateChatUid:self.globalMessage.from.userIDValue Name:self.globalMessage.senderName ReceiveUid:GetCore(AuthCore).getUid.userIDValue ReceiveName:[GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].nick GameId:model.gameInfo.gameId ChannelId:model.gameInfo.gameChannel MessageId:self.globalMessage.messageId] subscribeNext:^(id x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            sender.userInteractionEnabled = YES;
            if (self.mainTimer11) {
                dispatch_source_cancel(self.mainTimer11);
                self.mainTimer11 = nil;
            }
            TTGameCPPrivateChatModel *customModel = [TTGameCPPrivateChatModel modelDictionary:customObject.data];
            customModel.status = TTGameStatusTypeAccept;
            customModel.uuId = self.globalMessage.messageId;
            self.globalMessage.localExt = [customModel model2dictionary];
            [GetCore(ImMessageCore) updateMessage:self.globalMessage
                                          session:self.globalMessage.session];
            
            model.gameUrl = x[@"gameUrl"];
            model.uuId = self.globalMessage.messageId;
            model.status = TTGameStatusTypeAccept;
            
            NotifyCoreClient(TTCPGamePrivateChatClient, @selector(acceptGameFromPrivateChat: GameUrl: FromUid:), acceptGameFromPrivateChat:[model model2dictionary] GameUrl:x[@"receiveGameUrl"] FromUid:self.globalMessage);
        });
    } error:^(NSError *error) {
//        @strongify(self);
        sender.userInteractionEnabled = YES;
        [XCHUDTool showErrorWithMessage:error.domain];
    }];
}

- (void)initView{
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    [self addSubview:self.backView];
    [self.backView addSubview:self.backImageView];
    [self.backImageView addSubview:self.upToView];
    [self.backView addSubview:self.titleButton];
    [self.backView addSubview:self.timerLabel];
    [self.backView addSubview:self.enterButton];
    [self.backView addSubview:self.waitLabel];
    [self.backView addSubview:self.montmorilloniteView];
    
    self.enterButton.userInteractionEnabled = YES;
}

- (void)layoutSubviewsWithFrame{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.right.mas_equalTo(self);
    }];
    
    [self.montmorilloniteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(self.backView);
    }];
    
    [self.titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backView).offset(5);
        make.centerX.mas_equalTo(self.backView);
    }];
    
    
    [self.timerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleButton.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.centerX.mas_equalTo(self.titleButton);
    }];
    
    [self.enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.backView);
        make.height.mas_equalTo(44);
    }];
    
    [self.waitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.backView);
        make.height.mas_equalTo(44);
    }];
    
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.backView).offset(0);
        make.bottom.mas_equalTo(self.waitLabel.mas_top);
    }];
    
    [self.upToView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(self.backImageView);
    }];
}

#pragma mark -- 创建定时器 ---
- (void)createGCDTimerWithModel:(TTGameCPPrivateChatModel *)model message:(NIMMessage *)message {
    NSDate *dateNow = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    
    NSDate *dateOld = [NSDate dateWithTimeIntervalSince1970:model.startTime / 1000];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitSecond;//只比较天数差异
    //比较的结果是NSDateComponents类对象
    NSDateComponents *delta = [calendar components:unit fromDate:dateOld toDate:dateNow options:0];
    
    self.timerTime = GetCore(TTCPGameStaticCore).gameTime - delta.second;
    dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    self.mainTimer11 = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, global);
    
    dispatch_source_set_timer(self.mainTimer11, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    
    @weakify(self);
    dispatch_source_set_event_handler(self.mainTimer11, ^{
        @strongify(self);
        //1. 每调用一次 时间-1s
        self.timerTime--;
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            self.timerLabel.text = [NSString stringWithFormat:@"%ld",self.timerTime];
        });
        if (self.timerTime <= 0) {
            dispatch_source_cancel(self.mainTimer11);
            self.mainTimer11 = nil;
            TTGameCPPrivateChatModel *launchGameModel = [TTGameCPPrivateChatModel modelDictionary:message.localExt];
            launchGameModel.status = TTGameStatusTypeInvalid;
            launchGameModel.uuId = message.messageId;
            
            message.localExt = [launchGameModel model2dictionary];
            
            [GetCore(ImMessageCore) updateMessage:message
                                          session:message.session];
        }
    });
    dispatch_resume(self.mainTimer11);
}

- (UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backImageView.clipsToBounds = YES;
    }
    return _backImageView;
}

- (UIView *)upToView{
    if (!_upToView) {
        _upToView = [[UIView alloc] init];
        _upToView.backgroundColor = UIColorRGBAlpha(0x000000, 0.15);
    }
    return _upToView;
}

- (UIButton *)titleButton
{
    if (_titleButton == nil) {
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_titleButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _titleButton.backgroundColor = UIColorRGBAlpha(0x000000, 0.5);
        _titleButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _titleButton.layer.cornerRadius = 15;
        _titleButton.userInteractionEnabled = NO;
        [_titleButton setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                      forAxis:UILayoutConstraintAxisHorizontal];
        [_titleButton setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        
        
    }
    return _titleButton;
}

-(UILabel *)timerLabel{
    if (!_timerLabel) {
        _timerLabel = [[UILabel alloc] init];
        _timerLabel.textColor = UIColorFromRGB(0xffffff);
        _timerLabel.font = [UIFont systemFontOfSize:18];
        _timerLabel.textAlignment = NSTextAlignmentCenter;
        _timerLabel.layer.borderWidth = 2.5;
        _timerLabel.layer.borderColor = UIColorRGBAlpha(0xffffff, 0.8).CGColor;
        _timerLabel.layer.cornerRadius = 22;
        //        _timerLabel.text = [NSString stringWithFormat:@"%d",GetCore(TTCPGameStaticCore).gameTime];
    }
    return _timerLabel;
}

- (UIButton *)enterButton
{
    if (_enterButton == nil) {
        _enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_enterButton setTitleColor:UIColorFromRGB(0xFFB606) forState:UIControlStateNormal];
        _enterButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [_enterButton setTitle:@"接受" forState:UIControlStateNormal];
        [_enterButton addTarget:self action:@selector(acceptGameAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterButton;
}

-(UILabel *)waitLabel{
    if (!_waitLabel) {
        _waitLabel = [[UILabel alloc] init];
        _waitLabel.textColor = UIColorFromRGB(0x999999);
        _waitLabel.font = [UIFont systemFontOfSize:14];
        _waitLabel.text = @"等待对方接受邀请...";
        _waitLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _waitLabel;
}

- (UIView *)backView
{
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.cornerRadius = 10;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}

- (UIView *)montmorilloniteView{
    if (_montmorilloniteView == nil) {
        _montmorilloniteView = [[UIView alloc] init];
        _montmorilloniteView.backgroundColor = UIColorRGBAlpha(0x000000, 0.15);
        _montmorilloniteView.layer.cornerRadius = 10;
        _montmorilloniteView.hidden = YES;
    }
    return _montmorilloniteView;
}



- (void)enterGamePageDestructionTimer{
    if (self.mainTimer11) {
        dispatch_source_cancel(self.mainTimer11);
        self.mainTimer11 = nil;
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
