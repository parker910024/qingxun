//
//  TTFunctionMenuView.m
//  TuTu
//
//  Created by KevinWang on 2018/11/3.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFunctionMenuView.h"
#import <Masonry.h>
#import "XCMacros.h"
#import "XCTheme.h"

//core
#import "ImRoomCoreV2.h"
#import "RoomCoreV2.h"
#import "UserCore.h"
#import "AuthCore.h"
#import "GuildCore.h"
#import "TTGameStaticTypeCore.h"
#import "TTCPGameStaticCore.h"
#import "VersionCore.h"

//view
#import "TTFunctionMenuMoreStypeCell.h"

@interface TTFunctionMenuView()
<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UIView *lineView;
//功能选项
@property (nonatomic, strong) NSMutableArray<TTFunctionMenuItem *> *funArray;
//顶部的操作
@property (nonatomic, strong) UIScrollView *sv_topOperation;
//聊天功能按钮
@property (nonatomic, strong) TTFunctionMenuButton *chatFunBtn;

@property (nonatomic, assign) BOOL isSuperAdmin;

@end

@implementation TTFunctionMenuView

#pragma mark - life cycle
- (instancetype)init {
    if (self = [super init]) {
        [self initSubViews];
        [self initConstraints];
        [self loadData];
    }
    return self;
}

#pragma mark - CollectionVewDelegate &&  DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.functionMenuTypetype == TTFunctionMenuType_More) {
        return self.funArray.count;
    } else {
        return 0;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TTFunctionMenuMoreStypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TTFunctionMenuMoreStypeCell" forIndexPath:indexPath];
    if (self.functionMenuTypetype == TTFunctionMenuType_More) {
        [cell configCell:self.funArray[indexPath.item]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.functionMenuTypetype == TTFunctionMenuType_More) {
        TTFunctionMenuItem *item = self.funArray[indexPath.item];
        if (self.delegate) {
            [self.delegate functionMenuView:self didSelectMenuItem:item.functionTag];
        }
    }
}

#pragma mark - Event
- (void)itemClick:(TTFunctionMenuButton *)button {
    if (_delegate) {
        [_delegate functionMenuView:self didSelectMenuButton:button];
    }
}

#pragma mark - puble method
- (void)layoutTheViews {
    
    CGFloat chatExpandWidth = self.currentUserOnMicStatus ? CGFLOAT_MIN : [self chatButtonExpandWidth];
    
    UserInfo *info = [GetCore(UserCore) getUserInfoInDB:[GetCore(AuthCore) getUid].userIDValue];
    BOOL superAdmin = info.platformRole == XCUserInfoPlatformRoleSuperAdmin;
    if (superAdmin) {
        chatExpandWidth = CGFLOAT_MIN;
    }
    
    for (int i = 0; i < self.items.count; i++) {
        
        TTFunctionMenuButton *item = self.items[i];
        if (item.type == TTFunctionMenuButtonType_More) {
            self.moreFunBtn = item;
        }
        
        if (item.type == TTFunctionMenuButtonType_Gift) {
            self.giftFunBtn = item;
        }
        
        if (item.type == TTFunctionMenuButtonType_Chat) {
            self.chatFunBtn = item;
            
            if (self.currentUserOnMicStatus) {
                [item setButtonNormalImage:@"room_GameChat_logo"
                              disableImage:@"room_GameChat_logo"
                             selectedImage:@"room_GameChat_logo"];
                [item setTitle:@"" forState:UIControlStateNormal];
            } else {
                [item setButtonNormalImage:@"room_GameChat_logo_expand"
                              disableImage:@"room_GameChat_logo_expand"
                             selectedImage:@"room_GameChat_logo_expand"];
                [item setTitle:@"说点什么..." forState:UIControlStateNormal];
                [item setTitleColor:[UIColor.whiteColor colorWithAlphaComponent:0.4] forState:UIControlStateNormal];
                item.titleLabel.font = [UIFont systemFontOfSize:14];
                item.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
            }
        }
        
        [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchDown];
        
        if (item.type == TTFunctionMenuButtonType_Gift) {
            item.frame = CGRectMake(self.frame.size.width - self.itemWidth - self.widthSpacing, 10, self.itemWidth, self.itemHeight);
            [self addSubview:item];
        } else {
            
            CGFloat x = self.widthSpacing;
            CGFloat width = item.type == TTFunctionMenuButtonType_Chat ? self.itemWidth+chatExpandWidth : self.itemWidth;
            
            if (item.type != TTFunctionMenuButtonType_Chat) {
                x = chatExpandWidth + self.widthSpacing + (self.itemWidth+ self.widthSpacing) * i;
            }
            
            item.frame = CGRectMake(x, 10, width, self.itemHeight);
            [self.sv_topOperation addSubview:item];
        }
    }
    
    self.sv_topOperation.frame = CGRectMake(0, 0, self.frame.size.width - self.itemWidth -2*self.widthSpacing, self.itemHeight+10);
    self.sv_topOperation.contentSize = CGSizeMake((self.items.count-1)*(self.itemWidth+self.widthSpacing)+chatExpandWidth, 0);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bgView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(14, 14)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bgView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.bgView.layer.mask = maskLayer;
}

#pragma mark - private method

- (void)initSubViews {
    [self addSubview:self.bgView];
    [self addSubview:self.sv_topOperation];
    [self addSubview:self.collectionView];
    
    [self addSubview:self.lineView];
    self.lineView.hidden = YES;
}

- (void)initConstraints {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(kSafeAreaBottomHeight);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self).offset(53);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)loadData {
    
    [self.funArray removeAllObjects];
    
    NIMChatroomMember *myMember = GetCore(ImRoomCoreV2).myMember;
    BOOL isCreator = myMember.type == NIMChatroomMemberTypeCreator;
    BOOL isManager = myMember.type == NIMChatroomMemberTypeManager;
    BOOL isManagerNotSuperAdmin = isManager&&!self.isSuperAdmin;
    BOOL isManagerAndDelegateSuperAdmin = isManager&&self.delegateSuperAdmin;
    BOOL isSuperAdminNotDelete = self.isSuperAdmin&&!self.delegateSuperAdmin;
    
    if (GetCore(TTGameStaticTypeCore).openRoomStatus == OpenRoomType_CP) {
        
        if (isCreator) {
            [self.funArray addObject:[TTFunctionMenuItem itemWithFunctionTag:TTFunctionMenuItemTag_Room_Limit title:@"进房限制" imageName:@"room_toolbar_more_limit"]];
        }
        
        
        if (GetCore(RoomCoreV2).hasAnimationEffect) {
            [self.funArray addObject:[TTFunctionMenuItem itemWithFunctionTag:TTFunctionMenuItemTag_GiftEffect_Close title:@"关闭我的特效" imageName:@"room_toolbar_more_gifteffect_close"]];
            
        } else {
            [self.funArray addObject:[TTFunctionMenuItem itemWithFunctionTag:TTFunctionMenuItemTag_GiftEffect_Open title:@"开启我的特效" imageName:@"room_toolbar_more_gifteffect_open"]];
        }
        
        if (isCreator||isManagerNotSuperAdmin||isManagerAndDelegateSuperAdmin||isManagerAndDelegateSuperAdmin) {
            [self.funArray addObject:[TTFunctionMenuItem itemWithFunctionTag:TTFunctionMenuItemTag_Room_Setting title:@"房间设置" imageName:@"room_toolbar_more_setting"]];
        }
        
        if (!self.isSuperAdmin||self.delegateSuperAdmin) {
            //模厅管理
            NSString *roomOwnerUID = @(GetCore(ImRoomCoreV2).roomOwnerInfo.uid).stringValue;
            if ([GetCore(GuildCore).hallInfo.ownerUid isEqualToString:roomOwnerUID]) {
                
                [self.funArray addObject:[TTFunctionMenuItem itemWithFunctionTag:TTFunctionMenuItemTag_Room_GuildManager title:@"厅管理" imageName:@"room_toolbar_more_guild_manager"]];
            }
            
        } else {
            
            [self.funArray addObject:[TTFunctionMenuItem itemWithFunctionTag:TTFunctionMenuItemTag_Room_OfficalManager title:@"官方管理" imageName:@"room_settings_officalManager"]];
        }
        
        if (!GetCore(RoomCoreV2).hideRedPacket && !GetCore(VersionCore).loadingData) {
            if (isCreator || isManager) {
                if (GetCore(RoomCoreV2).getCurrentRoomInfo.closeRedPacket) {
                    [self.funArray addObject:[TTFunctionMenuItem itemWithFunctionTag:TTFunctionMenuItemTag_Redbag_Open title:@"开启房间红包" imageName:@"redbag_switch_on"]];
                } else {
                    [self.funArray addObject:[TTFunctionMenuItem itemWithFunctionTag:TTFunctionMenuItemTag_Redbag_Close title:@"关闭房间红包" imageName:@"redbag_switch_off"]];
                }
            }
        }
        return;
    }
    
    if (!self.isSuperAdmin||self.delegateSuperAdmin) {
        // 只有游戏开关是打开的模式下，才添加游戏按钮
        if (GetCore(TTCPGameStaticCore).roomGameSwitch) {
            [self.funArray addObject:[TTFunctionMenuItem itemWithFunctionTag:TTFunctionMenuItemTag_Room_Game title:@"游戏" imageName:@"normalRomGame_logo"]];
        }
        
    }
    
    if (GetCore(RoomCoreV2).hasAnimationEffect) {
        [self.funArray addObject:[TTFunctionMenuItem itemWithFunctionTag:TTFunctionMenuItemTag_GiftEffect_Close title:@"关闭我的特效" imageName:@"room_toolbar_more_gifteffect_close"]];
    } else {
        [self.funArray addObject:[TTFunctionMenuItem itemWithFunctionTag:TTFunctionMenuItemTag_GiftEffect_Open title:@"开启我的特效" imageName:@"room_toolbar_more_gifteffect_open"]];
    }

    if (isCreator ||isManager||isSuperAdminNotDelete) {
        if (GetCore(ImRoomCoreV2).currentRoomInfo.isCloseScreen) {
            [self.funArray addObject:[TTFunctionMenuItem itemWithFunctionTag:TTFunctionMenuItemTag_RoomMessage_Open title:@"开启公屏" imageName:@"room_toolbar_more_message_open"]];
        } else {
            [self.funArray addObject:[TTFunctionMenuItem itemWithFunctionTag:TTFunctionMenuItemTag_RoomMessage_Close title:@"关闭公屏" imageName:@"room_toolbar_more_message_close"]];
        }
    }
    
    if (isCreator || isManagerNotSuperAdmin||isManagerAndDelegateSuperAdmin) {
        //礼物值
        if ([GetCore(ImRoomCoreV2) canOpenGiftValue]) {
            if (GetCore(ImRoomCoreV2).currentRoomInfo.showGiftValue) {
                [self.funArray addObject:[TTFunctionMenuItem itemWithFunctionTag:TTFunctionMenuItemTag_GiftValue_Open title:GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_Love ? @"关闭心动值" : @"关闭礼物值" imageName:@"room_toolbar_more_gift_value_open"]];
            } else {
                [self.funArray addObject:[TTFunctionMenuItem itemWithFunctionTag:TTFunctionMenuItemTag_GiftValue_Close title:GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_Love ? @"开启心动值" : @"开启礼物值" imageName:@"room_toolbar_more_gift_value_close"]];
            }
        }
    }
    
    if (isCreator|| isManagerNotSuperAdmin||isManagerAndDelegateSuperAdmin||isManagerAndDelegateSuperAdmin) {
        [self.funArray addObject:[TTFunctionMenuItem itemWithFunctionTag:TTFunctionMenuItemTag_Room_Setting title:@"房间设置" imageName:@"room_toolbar_more_setting"]];
    }
    
    if (!self.isSuperAdmin||self.delegateSuperAdmin) {
        //模厅管理
        NSString *roomOwnerUID = @(GetCore(ImRoomCoreV2).roomOwnerInfo.uid).stringValue;
        if ([GetCore(GuildCore).hallInfo.ownerUid isEqualToString:roomOwnerUID]) {
            
            [self.funArray addObject:[TTFunctionMenuItem itemWithFunctionTag:TTFunctionMenuItemTag_Room_GuildManager title:@"厅管理" imageName:@"room_toolbar_more_guild_manager"]];
        }
    } else {
       
        [self.funArray addObject:[TTFunctionMenuItem itemWithFunctionTag:TTFunctionMenuItemTag_Room_OfficalManager title:@"官方管理" imageName:@"room_settings_officalManager"]];
    }
    
    if (!GetCore(RoomCoreV2).hideRedPacket && !GetCore(VersionCore).loadingData) {
        if (isCreator || isManager) {
            if (GetCore(RoomCoreV2).getCurrentRoomInfo.closeRedPacket) {
                [self.funArray addObject:[TTFunctionMenuItem itemWithFunctionTag:TTFunctionMenuItemTag_Redbag_Open title:@"开启房间红包" imageName:@"redbag_switch_on"]];
            } else {
                [self.funArray addObject:[TTFunctionMenuItem itemWithFunctionTag:TTFunctionMenuItemTag_Redbag_Close title:@"关闭房间红包" imageName:@"redbag_switch_off"]];
            }
        }
    }
}


/**
 聊天按钮拓展时额外长度
 */
- (CGFloat)chatButtonExpandWidth {
    return 90.0f;
}

#pragma mark - Setter && Getter
- (void)setFunctionMenuTypetype:(TTFunctionMenuType)functionMenuTypetype {
    _functionMenuTypetype = functionMenuTypetype;
    
    //更新更多功能的icon
    [self loadData];
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.left.right.bottom.mas_equalTo(self);
    }];
    
    self.collectionView.hidden = functionMenuTypetype == TTFunctionMenuType_Normal;
    self.sv_topOperation.hidden = functionMenuTypetype == TTFunctionMenuType_More;
    self.giftFunBtn.hidden = functionMenuTypetype == TTFunctionMenuType_More;
    
    [self.collectionView reloadData];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColorRGBAlpha(0x000000, 0.9);
    }
    return _bgView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorRGBAlpha(0xFFFFFF, 0.1);
    }
    return _lineView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat cellWidth = (KScreenWidth - 15 * 2) / 5;
        layout.itemSize = CGSizeMake(cellWidth, 80);
        layout.minimumLineSpacing = CGFLOAT_MIN;
        layout.minimumInteritemSpacing = CGFLOAT_MIN;
        layout.sectionInset = UIEdgeInsetsMake(20, 15, 20, 15);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[TTFunctionMenuMoreStypeCell class] forCellWithReuseIdentifier:@"TTFunctionMenuMoreStypeCell"];
    }
    return _collectionView;
}

- (UIScrollView *)sv_topOperation {
    if (!_sv_topOperation) {
        _sv_topOperation = [[UIScrollView alloc] init];
    }
    return _sv_topOperation;
}

- (NSMutableArray<TTFunctionMenuItem *> *)funArray {
    if(!_funArray){
        _funArray = [NSMutableArray array];
    }
    return _funArray;
}

- (BOOL)delegateSuperAdmin {
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"deleteSuperAdmin"]) {
        _delegateSuperAdmin = [[NSUserDefaults standardUserDefaults] boolForKey:@"deleteSuperAdmin"];
    }
    return _delegateSuperAdmin;
}

- (BOOL)isSuperAdmin {
    
    return [GetCore(UserCore)getUserInfoInDB:GetCore(ImRoomCoreV2).myMember.userId.userIDValue].platformRole == XCUserInfoPlatformRoleSuperAdmin;
}

@end
