//
//  TTRedbagConditionListView.h
//  AFNetworking
//
//  Created by ShenJun_Mac on 2020/5/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTRedbagConditionListView : UIView

@property (nonatomic, strong) NSArray *requireTypeList;

@property (nonatomic, copy) void (^conditionListSelectBlock)(NSDictionary *dict);//领取对应奖励

@end

NS_ASSUME_NONNULL_END
