//
//  GameLuckyResult.m
//  BberryCore
//
//  Created by 何卫明 on 2018/4/1.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "GameLuckyResult.h"

@implementation LuckMan

@end

@implementation GameLuckReward

@end

@implementation GameLuckyResult

//- (LuckMan *)luckyDog {
//    if (_luckyDog == nil) {
//        _luckyDog = [[LuckMan alloc]init];
//        _luckyDog.nick = @"45678u";
//        _luckyDog.erbanNo = @"1231241";
//        _luckyDog.hurt = @"123123";
//        _luckyDog.avatar = [NSURL URLWithString:@"https://img.erbanyy.com/logo_erban.png"];
//    }
//    return _luckyDog;
//}
//
//- (NSArray<GameLuckReward *> *)awards {
//    if (_awards == nil) {
//        NSMutableArray *arr = [NSMutableArray array];
//        for (int i = 0; i <= 5; i++) {
//            GameLuckReward *reward = [[GameLuckReward alloc]init];
//            reward.prodName = @"神牛";
//            reward.prodType = GameProdType_Car;
//            reward.prodImage = @"https://img.erbanyy.com/logo_erban.png";
//            reward.prodValue = 15;
//            [arr addObject:reward];
//        }
//
//        _awards= arr;
//    }
//    return _awards;
//}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"awards" : [GameLuckReward class],
             @"ranking" : [LuckMan class]};
}
@end
