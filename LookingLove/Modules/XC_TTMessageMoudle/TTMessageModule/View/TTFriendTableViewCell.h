//
//  TTFriendTableViewCell.h
//  TuTu
//
//  Created by gzlx on 2018/10/31.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import "Attention.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TTFriendTableViewCellType){
    TTFriendTableViewCell_Find,
    TTFriendTableViewCell_Focus,
    TTFriendTableViewCell_Hidden,
    TTFriendTableViewCell_IsSelected,//是不是选择的时候使用的
    TTFriendTableViewCell_Present,//赠送装扮
     TTFriendTableViewCell_RoomChat,//房间内消息
};

@class TTSendPresentUserInfo;

@protocol TTFriendTableViewCellDelegate <NSObject>

@optional

/** 选择的时候把那个人的userinfor 传出去*/
- (void)choseUserWithInfor:(UserInfo *)infor;

/** 选择用户赠送礼物*/
- (void)sendPresentDidSelect:(TTSendPresentUserInfo *)user;

/** 关注 找到TA*/
- (void)focusOrFindFriendWith:(UserInfo *)infor cellType:(TTFriendTableViewCellType)cellType sender:(UIButton *)sender;

/** 找到他*/
- (void)findFriendWith:(Attention *)attention;

@end

@interface TTFriendTableViewCell : UITableViewCell
/** 通过用户信息 给cell赋值*/
- (void)configTTFriendTableViewCell:(UserInfo *)infor;
/** 关注和粉丝给cell赋值*/
- (void)configTTFriendTableViewCellWithAttention:(Attention *)attention;
@property (nonatomic, assign) TTFriendTableViewCellType cellType;

@property (nonatomic, assign) id<TTFriendTableViewCellDelegate> delegate;
/** 是不是给粉丝赋值*/
@property (nonatomic, assign) BOOL isFans;
@property (nonatomic, strong) NSMutableDictionary * selectDic;

@end

NS_ASSUME_NONNULL_END
