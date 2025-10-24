//
//  TTWorldletHeaderView.h
//  AFNetworking
//
//  Created by apple on 2019/6/28.
//

#import <UIKit/UIKit.h>
#import "LittleWorldListModel.h"
#import "LittleWorldPartyRoom.h"

NS_ASSUME_NONNULL_BEGIN

@class TTWorldletHeaderView;

@protocol TTWorldletHeaderViewDelegate <NSObject>

- (void)numberBtnClickAction:(TTWorldletHeaderView *)view;

/// 选中语音派对房
- (void)headerView:(TTWorldletHeaderView *)view didSelectedPartyRoom:(LittleWorldPartyRoom *)room;

@end

@interface TTWorldletHeaderView : UIView

@property (nonatomic, strong) LittleWorldListItem *model;

@property (nonatomic, strong) NSArray <LittleWorldPartyRoom *> *partyRoomList;

@property (nonatomic, weak) id<TTWorldletHeaderViewDelegate> delegate;

- (void)scrollViewDidScroll:(CGFloat)contentOffsetY;

- (CGFloat)height;

@end

NS_ASSUME_NONNULL_END
