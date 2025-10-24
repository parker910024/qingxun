//
//  GameLuckyResult.h
//  BberryCore
//
//  Created by 何卫明 on 2018/4/1.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "BaseObject.h"
#import "GameLuckyResult.h"
#import "MonsterGameModel.h"

typedef enum : NSUInteger {
    GameProdType_Coin = 1, //金币
    GameProdType_GoodNum = 2, //靓号
    GameProdType_Car = 3, //座驾
    GameProdType_Real = 4 //实物
} GameProdType;



@interface LuckMan : BaseObject

@property (assign, nonatomic) UserID uid;
@property (strong, nonatomic) NSURL *avatar;
@property (copy, nonatomic) NSString *nick;
@property (copy, nonatomic) NSString *hurt;
@property (nonatomic,copy) NSString *erbanNo;
@end

@interface GameLuckReward : BaseObject
//
//"prodId":1,
//"prodType":1,//1金币，2靓号，3座驾，4实物
//"prodName":"特斯拉",
//"prodValue":1000//金币时是数量，座驾时是座驾价值，实物是价值
//"monsterId":1

@property (copy, nonatomic) NSString *prodId;
@property (copy, nonatomic) NSString *prodName;
@property (assign, nonatomic) GameProdType prodType;
@property (copy, nonatomic) NSString *prodValue;
@property (copy, nonatomic) NSString *monsterId;
@property (nonatomic,copy) NSString *prodImage;
@property (nonatomic,strong) NSString *expireDays;
@end

@interface GameLuckyResult : BaseObject
@property (strong, nonatomic) LuckMan *luckyDog;
@property (strong, nonatomic) NSArray<GameLuckReward *> *awards;
@property (strong, nonatomic) NSArray<LuckMan *> *ranking;
@property (nonatomic, strong) MonsterGameModel *monster;
@end
