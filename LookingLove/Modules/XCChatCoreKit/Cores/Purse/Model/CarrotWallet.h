//
//  CarrotWallet.h
//  AFNetworking
//
//  Created by lee on 2019/3/26.
//

#import "BaseObject.h"


/**
 状态：0冻结，1正常

 - useStatusLock: 冻结
 - useStatusNormal: 正常
 */
typedef NS_ENUM(NSUInteger, UseStatus) {
    UseStatusLock = 0,
    UseStatusNormal = 1,
};

NS_ASSUME_NONNULL_BEGIN

@interface CarrotWallet : BaseObject

/** 用户 uid */
@property (nonatomic, assign) UserID uid;
/** 数量     */
@property(nonatomic, copy) NSString *amount;
/** 类型,1:萝卜币     */
@property(nonatomic, assign) NSInteger currencyType;
/** 状态：0冻结，1正常     */
@property(nonatomic, assign) UseStatus useStatus;
@end

NS_ASSUME_NONNULL_END
