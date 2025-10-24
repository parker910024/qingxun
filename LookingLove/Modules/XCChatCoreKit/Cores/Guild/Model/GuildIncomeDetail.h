//
//  GuildIncomeDetail.h
//  
//
//  Created by lvjunhang on 2019/1/17.
//  收入明细

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

//4     giftId    礼物id    是    [string]    查看
//5     giftName    礼物名    是    [string]    查看
//6     goldPrice    礼物单价    是    [string]    查看
//7     picUrl    礼物图    是    [string]    查看
//8     giftNum    礼物数量    是    [string]    查看
//9     totalGoldNum    礼物总价    是    [string]

@interface GuildIncomeDetail : BaseObject
@property (nonatomic, copy) NSString *giftId;
@property (nonatomic, copy) NSString *giftName;
@property (nonatomic, copy) NSString *goldPrice;
@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, copy) NSString *giftNum;
@property (nonatomic, copy) NSString *totalGoldNum;
@end

NS_ASSUME_NONNULL_END
