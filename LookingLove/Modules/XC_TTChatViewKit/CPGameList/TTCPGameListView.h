//
//  TTCPGameListView.h
//  TTPlay
//
//  Created by new on 2019/2/18.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPGameListModel.h"

typedef enum : NSUInteger {
    TTGameListPrivate = 1,
    TTGameListPublicAndNormalRoom = 2,
    TTGameListNormalRoom = 3,
} TTGameListType;

NS_ASSUME_NONNULL_BEGIN

@protocol TTCPGameListViewDelegate <NSObject>

-(void)clickItem:(CPGameListModel *)model;
-(void)clickRoomGameItem:(CPGameListModel *)model;//房间游戏
@end


@interface TTCPGameListView : UIView

-(instancetype)initWithFrame:(CGRect)frame WithListType:(TTGameListType )listType;

@property (nonatomic, weak) id<TTCPGameListViewDelegate> delegate;

- (void)destructionTimer;

- (void)showListViewAndRefreshData;

@end

NS_ASSUME_NONNULL_END
