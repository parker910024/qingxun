//
//  TTPublicGameView.m
//  TTPlay
//
//  Created by new on 2019/2/22.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTPublicGameView.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "UIImageView+QiNiu.h"
#import "PublicGameCache.h"
#import "TTGameCPPrivateChatModel.h"
#import "TTCPGamePrivateChatCore.h"
#import "XCCPGamePrivateAttachment.h"
#import "AuthCore.h"
#import "UserCore.h"
#import "ImMessageCore.h"
#import "ImPublicChatroomCore.h"
#import "TTCPGamePrivateChatClient.h"
#import "XCCPGamePrivateSysNotiAttachment.h"
#import "TTCPGameStaticCore.h"
#import "TTCPGameOverAndSelectClient.h"
#import "XCHUDTool.h"
#import "TTPopup.h"

@interface TTPublicGameView ()

@property (nonatomic, strong) UIButton *titleButton; // 游戏标题

@property (nonatomic, strong) UIImageView *backImageView; // 游戏背景

@property (nonatomic, strong) UIView *upToView;  // 图片上的半透明View

@property (nonatomic, strong) UILabel *timerLabel; // 显示倒计时的Label

@property (nonatomic, strong) UILabel *waitLabel; // 等待对方接受 自己方显示的等待

@property (nonatomic, strong) UIButton *enterButton;  // 接受  对方去点

@property (nonatomic, strong) UIView *montmorilloniteView; // 游戏失效或者结束时候的蒙层

@property (nonatomic, strong) dispatch_source_t mainTimer; // 倒计时

@property (nonatomic, strong) UIButton *watchButton;

@property (nonatomic, strong) NIMMessage *globalMessage;
@end

@implementation TTPublicGameView


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        [self initConstrations];
        AddCoreClient(TTCPGameOverAndSelectClient, self);
    }
    return self;
}


- (void)initView{
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    [self addSubview:self.backImageView];
    [self.backImageView addSubview:self.upToView];
    [self addSubview:self.titleButton];
    [self addSubview:self.timerLabel];
    [self addSubview:self.waitLabel];
    [self addSubview:self.enterButton];
    [self addSubview:self.watchButton];
    [self addSubview:self.montmorilloniteView];
    
    self.enterButton.userInteractionEnabled = YES;
    self.watchButton.userInteractionEnabled = YES;
}

- (void)setMessage:(NIMMessage *)message{
    __weak typeof(self) weakSelf = self;
    self.globalMessage = message;
    if (message.messageType == NIMMessageTypeCustom) {
        NIMMessage *locationMessage = [[PublicGameCache sharePublicGameCache] selectGameInfo:message.messageId];
        if (locationMessage.localExt) {
            TTGameCPPrivateChatModel *model = [TTGameCPPrivateChatModel modelDictionary:locationMessage.localExt];
            if (model.status == TTGameStatusTypeInvalid) {
                [self enterGamePageDestructionTimer];
                self.timerLabel.hidden = YES;
                self.waitLabel.hidden = NO;
                self.enterButton.hidden = YES;
                self.waitLabel.text = @"约战已失效";
                self.montmorilloniteView.hidden = NO;
            }else if (model.status == TTGameStatusTypeTimeing){
                if ([locationMessage.from isEqualToString:GetCore(AuthCore).getUid]) {
                    self.timerLabel.hidden = NO;
                    self.waitLabel.hidden = NO;
                    self.enterButton.hidden = YES;
                    self.waitLabel.text = @"等待对方接受邀请...";
                    self.montmorilloniteView.hidden = YES;
                    
                    [self createTimer:model WithMessage:message];
                }else{
                    self.timerLabel.hidden = NO;
                    self.waitLabel.hidden = YES;
                    self.enterButton.hidden = NO;
                    self.montmorilloniteView.hidden = YES;
                    [self createTimer:model WithMessage:message];
                }
            }else if (model.status == TTGameStatusTypeAccept){
                if (model.acceptUid == GetCore(AuthCore).getUid.userIDValue || model.startUid == GetCore(AuthCore).getUid.userIDValue) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (weakSelf.mainTimer) {
                            dispatch_source_cancel(self.mainTimer);
                            weakSelf.mainTimer = nil;
                        }
                        weakSelf.timerLabel.hidden = YES;
                        weakSelf.waitLabel.hidden = NO;
                        weakSelf.watchButton.hidden = YES;
                        weakSelf.enterButton.hidden = YES;
                        weakSelf.waitLabel.text = @"约战已结束";
                        weakSelf.montmorilloniteView.hidden = NO;
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (weakSelf.mainTimer) {
                            dispatch_source_cancel(self.mainTimer);
                            weakSelf.mainTimer = nil;
                        }
                        weakSelf.timerLabel.hidden = YES;
                        weakSelf.waitLabel.hidden = YES;
                        weakSelf.enterButton.hidden = YES;
                        weakSelf.watchButton.hidden = NO;
                        weakSelf.montmorilloniteView.hidden = YES;
                    });
                }
            }
            [self.titleButton setTitle:[NSString stringWithFormat:@"  %@  ",model.gameInfo.gameName] forState:UIControlStateNormal];
            
            [self.backImageView qn_setImageImageWithUrl:model.gameInfo.gamePicture placeholderImage:@"game_home_itemBg" type:(ImageType)ImageTypeUserLibaryDetail];
        }else{
            
            NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
            
            XCCPGamePrivateAttachment *attachment = (XCCPGamePrivateAttachment *)obj.attachment;
            
            TTGameCPPrivateChatModel *model = [TTGameCPPrivateChatModel modelDictionary:attachment.data];
            
            if ([message.from isEqualToString:GetCore(AuthCore).getUid]) {
                self.waitLabel.hidden = NO;
                self.enterButton.hidden = YES;
                self.waitLabel.text = @"等待对方接受邀请...";
            }else{
                self.waitLabel.hidden = YES;
                self.enterButton.hidden = NO;
            }
            
            [self.titleButton setTitle:[NSString stringWithFormat:@"  %@  ",model.gameInfo.gameName] forState:UIControlStateNormal];
            
            [self.backImageView qn_setImageImageWithUrl:model.gameInfo.gamePicture placeholderImage:@"game_home_itemBg" type:(ImageType)ImageTypeUserLibaryDetail];
            
            
            NSDate *dateNow = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
            
            NSDate *dateOld = [NSDate dateWithTimeIntervalSince1970:model.startTime / 1000];
            
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSCalendarUnit unit = NSCalendarUnitSecond;//只比较天数差异
            //比较的结果是NSDateComponents类对象
            NSDateComponents *delta = [calendar components:unit fromDate:dateOld toDate:dateNow options:0];
            
            if (GetCore(TTCPGameStaticCore).gameTime - delta.second <= 0 || delta.second < 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (weakSelf.mainTimer) {
                        dispatch_source_cancel(self.mainTimer);
                        weakSelf.mainTimer = nil;
                    }
                    self.timerLabel.hidden = YES;
                    self.waitLabel.hidden = NO;
                    self.enterButton.hidden = YES;
                    self.waitLabel.text = @"约战已失效";
                    self.montmorilloniteView.hidden = NO;
                });
            }else{
                __weak typeof(self) weakSelf = self;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!weakSelf) {
                        NSLog(@"self没有了");
                        return;
                    }
                    if (weakSelf.mainTimer) {
                        dispatch_source_cancel(self.mainTimer);
                        weakSelf.mainTimer = nil;
                    }
                    if (!weakSelf.mainTimer) {
                        __block NSInteger time = GetCore(TTCPGameStaticCore).gameTime - delta.second;
                        
                        dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                        
                        weakSelf.mainTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, global);
                        
                        dispatch_source_set_timer(weakSelf.mainTimer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
                        
                        dispatch_source_set_event_handler(weakSelf.mainTimer, ^{
                            time--;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                weakSelf.timerLabel.text = [NSString stringWithFormat:@"%ld",time];
                            });
                            if (time <= 0) {
                                dispatch_source_cancel(weakSelf.mainTimer);
                                weakSelf.mainTimer = nil;
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    weakSelf.timerLabel.hidden = YES;
                                    weakSelf.waitLabel.hidden = NO;
                                    weakSelf.enterButton.hidden = YES;
                                    weakSelf.waitLabel.text = @"约战已失效";
                                    weakSelf.montmorilloniteView.hidden = NO;
                                });
                                NIMMessage *locationMessage = [[PublicGameCache sharePublicGameCache] selectGameInfo:message.messageId];
                                model.status = TTGameStatusTypeInvalid;
                                locationMessage.localExt = [model model2dictionary];
                                
                                [[PublicGameCache sharePublicGameCache] changeGameInfo:locationMessage];
                            }
                        });
                        dispatch_resume(weakSelf.mainTimer);
                    }
                });
            }
        }
    }
}

// 接受
- (void)acceptGameWithAction:(UIButton *)sender{
    if (sender == self.enterButton) {
        if (GetCore(ImPublicChatroomCore).publicMe.tempMuteDuration > 0) {
            [XCHUDTool showErrorWithMessage:@"你已经被禁言，不能参与游戏"];
            return;
        } else {
            [self acceptOrWatchGameWith:sender];
        }
    } else {
        [self acceptOrWatchGameWith:sender];
    }
}

- (void)watchGameAction:(UIButton *)sender{
    [self acceptGameWithAction:sender];
    
    //    NotifyCoreClient(TTCPGamePrivateChatClient, @selector(gameFailureAndRefreshTableView:), gameFailureAndRefreshTableView:self.globalMessage);
    
}

- (void)acceptOrWatchGameWith:(UIButton *)sender{
    
    sender.userInteractionEnabled = NO;
    
    __weak typeof(self) weakSelf = self;
    
    NIMCustomObject *obj = (NIMCustomObject *)self.globalMessage.messageObject;
    
    XCCPGamePrivateAttachment *attachment = (XCCPGamePrivateAttachment *)obj.attachment;
    
    TTGameCPPrivateChatModel *model;
    if (self.globalMessage.localExt) {
        model = [TTGameCPPrivateChatModel modelDictionary:self.globalMessage.localExt];
    }else{
        model = [TTGameCPPrivateChatModel modelDictionary:attachment.data];
    }
    
    @KWeakify(self);
    [[GetCore(TTCPGamePrivateChatCore) requestGameUrlFromPrivateChatUid:self.globalMessage.from.userIDValue Name:model.nick ReceiveUid:GetCore(AuthCore).getUid.userIDValue ReceiveName:[GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].nick GameId:model.gameInfo.gameId ChannelId:model.gameInfo.gameChannel MessageId:self.globalMessage.messageId] subscribeNext:^(id x) {
        @KStrongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            sender.userInteractionEnabled = YES;
            XCCPGamePrivateSysNotiAttachment *customAtt = [[XCCPGamePrivateSysNotiAttachment alloc] init];
            customAtt.first = Custom_Noti_Header_CPGAME_PublicChat_Respond;
            customAtt.second = Custom_Noti_Sub_CPGAME_PublicChat_Respond_Accept;
            model.gameUrl = x[@"gameUrl"];
            model.status = TTGameStatusTypeAccept;
            model.startUid = self.globalMessage.from.userIDValue;
            model.uuId = self.globalMessage.messageId;
            model.acceptUid = GetCore(AuthCore).getUid.userIDValue;
            customAtt.data = [model model2dictionary];
            
            NIMMessage *locationMessage = [[PublicGameCache sharePublicGameCache] selectGameInfo:self.globalMessage.messageId];
            locationMessage.localExt = [model model2dictionary];
            [[PublicGameCache sharePublicGameCache] changeGameInfo:locationMessage];
            
            [GetCore(ImMessageCore) sendCustomMessageAttachement:customAtt sessionId:[NSString stringWithFormat:@"%ld",GetCore(ImPublicChatroomCore).publicChatroomId] type:NIMSessionTypeChatroom];
            
            if (weakSelf.mainTimer) {
                dispatch_source_cancel(self.mainTimer);
                weakSelf.mainTimer = nil;
            }
            self.timerLabel.hidden = YES;
            self.waitLabel.hidden = NO;
            self.enterButton.hidden = YES;
            self.waitLabel.text = @"约战已结束";
            self.montmorilloniteView.hidden = NO;
            
            NotifyCoreClient(TTCPGamePrivateChatClient, @selector(acceptGameFromPublicChatGameUrl:FromUid:), acceptGameFromPublicChatGameUrl:x[@"receiveGameUrl"] FromUid:self.globalMessage);
        });
    } error:^(NSError *error) {
        @KStrongify(self);
        sender.userInteractionEnabled = YES;
        if (error.code == 20004) {
            
            NIMMessage *locationMessage = [[PublicGameCache sharePublicGameCache] selectGameInfo:self.globalMessage.messageId];
            if (!locationMessage) {
                locationMessage = self.globalMessage;
            }
            
            if (!locationMessage.localExt || [[locationMessage.localExt objectForKey:@"status"] integerValue] != 2) {
                model.status = TTGameStatusTypeAccept;
                model.uuId = self.globalMessage.messageId;
                model.startUid = self.globalMessage.from.userIDValue;
                locationMessage.localExt = [model model2dictionary];
                [[PublicGameCache sharePublicGameCache] changeGameInfo:locationMessage];
                
                NotifyCoreClient(TTCPGamePrivateChatClient, @selector(watchGameOverFromNormalRoom:), watchGameOverFromNormalRoom:self.globalMessage);
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [TTPopup alertWithMessage:@"游戏已经开始，是否进入观战" confirmHandler:^{
                    
                    NotifyCoreClient(TTCPGamePrivateChatClient, @selector(gameFailureAndRefreshTableView:), gameFailureAndRefreshTableView:self.globalMessage);

                } cancelHandler:^{
                    
                }];
            });
            
        }else if (error.code == 20003 || error.code == 20002) {
            model.status = TTGameStatusTypeAccept;
            model.uuId = self.globalMessage.messageId;
            model.startUid = self.globalMessage.from.userIDValue;
            model.acceptUid = GetCore(AuthCore).getUid.userIDValue;
            NIMMessage *locationMessage = [[PublicGameCache sharePublicGameCache] selectGameInfo:self.globalMessage.messageId];
            if (!locationMessage) {
                locationMessage = self.globalMessage;
            }
            locationMessage.localExt = [model model2dictionary];
            [[PublicGameCache sharePublicGameCache] changeGameInfo:locationMessage];
            
            NotifyCoreClient(TTCPGamePrivateChatClient, @selector(watchGameOverFromNormalRoom:), watchGameOverFromNormalRoom:self.globalMessage);
            
            [XCHUDTool showErrorWithMessage:error.domain];
        }
        
    }];
}

- (void)enterGamePageDestructionTimer{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.mainTimer) {
            dispatch_source_cancel(self.mainTimer);
            weakSelf.mainTimer = nil;
        }
    });
    
}

- (void)createTimer:(TTGameCPPrivateChatModel *)model WithMessage:(NIMMessage *)message{
    __weak typeof(self) weakSelf = self;
    if (self.mainTimer) {
        dispatch_source_cancel(self.mainTimer);
        self.mainTimer = nil;
    }
    if (!self.mainTimer) {
        
        NSDate *dateNow = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
        
        NSDate *dateOld = [NSDate dateWithTimeIntervalSince1970:model.startTime / 1000];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSCalendarUnit unit = NSCalendarUnitSecond;//只比较天数差异
        //比较的结果是NSDateComponents类对象
        NSDateComponents *delta = [calendar components:unit fromDate:dateOld toDate:dateNow options:0];
        
        __block NSInteger time = GetCore(TTCPGameStaticCore).gameTime - delta.second;
        
        dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        self.mainTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, global);
        
        dispatch_source_set_timer(self.mainTimer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        
        dispatch_source_set_event_handler(self.mainTimer, ^{
            time--;
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.timerLabel.text = [NSString stringWithFormat:@"%ld",time];
            });
            if (time <= 0) {
                dispatch_source_cancel(self.mainTimer);
                weakSelf.mainTimer = nil;
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.timerLabel.hidden = YES;
                    self.waitLabel.hidden = NO;
                    self.enterButton.hidden = YES;
                    self.waitLabel.text = @"约战已失效";
                    self.montmorilloniteView.hidden = NO;
                });
                NIMMessage *locationMessage = [[PublicGameCache sharePublicGameCache] selectGameInfo:message.messageId];
                model.status = TTGameStatusTypeInvalid;
                locationMessage.localExt = [model model2dictionary];
                
                [[PublicGameCache sharePublicGameCache] changeGameInfo:locationMessage];
            }
        });
        dispatch_resume(self.mainTimer);
    }
}

- (void)initConstrations{
    [self.montmorilloniteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(self);
    }];
    
    [self.titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(5);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.timerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleButton.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.centerX.mas_equalTo(self.titleButton);
    }];
    
    [self.enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(44);
    }];
    
    [self.watchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(44);
    }];
    
    [self.waitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(44);
    }];
    
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self).offset(0);
        make.bottom.mas_equalTo(self.waitLabel.mas_top);
    }];
    
    [self.upToView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(self.backImageView);
    }];
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

- (UILabel *)timerLabel{
    if (!_timerLabel) {
        _timerLabel = [[UILabel alloc] init];
        _timerLabel.textColor = UIColorFromRGB(0xffffff);
        _timerLabel.font = [UIFont systemFontOfSize:18];
        _timerLabel.textAlignment = NSTextAlignmentCenter;
        _timerLabel.layer.borderWidth = 2.5;
        _timerLabel.layer.borderColor = UIColorRGBAlpha(0xffffff, 0.8).CGColor;
        _timerLabel.layer.cornerRadius = 22;
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
        _enterButton.backgroundColor = UIColor.whiteColor;
        _enterButton.hidden = YES;
        [_enterButton addTarget:self action:@selector(acceptGameWithAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterButton;
}

- (UILabel *)waitLabel{
    if (!_waitLabel) {
        _waitLabel = [[UILabel alloc] init];
        _waitLabel.textColor = UIColorFromRGB(0x999999);
        _waitLabel.font = [UIFont systemFontOfSize:14];
        _waitLabel.textAlignment = NSTextAlignmentCenter;
        _waitLabel.backgroundColor = UIColor.whiteColor;
    }
    return _waitLabel;
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


- (UIButton *)watchButton{
    if (!_watchButton) {
        _watchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_watchButton setTitleColor:UIColorFromRGB(0xFFB606) forState:UIControlStateNormal];
        _watchButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [_watchButton setTitle:@"观战" forState:UIControlStateNormal];
        _watchButton.backgroundColor = UIColor.whiteColor;
        _watchButton.hidden = YES;
        [_watchButton addTarget:self action:@selector(watchGameAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _watchButton;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
