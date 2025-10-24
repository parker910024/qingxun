//
//  HttpRequestHelper+Auction.m
//  BberryCore
//
//  Created by chenran on 2017/5/27.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "HttpRequestHelper+Auction.h"
#import "AuthCore.h"
#import "AuctionInfo.h"
#import "AuctionUserInfo.h"
#import "AuctionList.h"

@implementation HttpRequestHelper (Auction)

+(void)startAuction:(UserID)uid auctUid:(UserID)auctUid auctMoney:(NSInteger)auctMoney servDura:(NSInteger)servDura minRaiseMoney:(NSInteger)minRaiseMoney auctDesc:(NSString *)auctDesc success:(void (^)(AuctionInfo *))success failure:(void (^)(NSNumber *, NSString *))failure
{
    NSString *method = @"auction/start";
    NSString *ticket = [GetCore(AuthCore) getTicket];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(uid) forKey:@"uid"];
    [params setObject:@(auctUid) forKey:@"auctUid"];
    [params setObject:@(auctMoney) forKey:@"auctMoney"];
    [params setObject:@(servDura) forKey:@"servDura"];
    [params setObject:@(minRaiseMoney) forKey:@"minRaiseMoney"];
    [params setObject:auctDesc forKey:@"auctDesc"];
    [params setObject:ticket forKey:@"ticket"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
//        AuctionInfo *auctionInfo = [AuctionInfo yy_modelWithDictionary:data];
        AuctionInfo *auctionInfo = [AuctionInfo modelDictionary:data];
        success(auctionInfo);

    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+(void) upAuction:(UserID)uid auctId:(NSString *)auctId roomUid:(UserID)roomUid type:(NSInteger)type money:(NSInteger)money success:(void (^)(AuctionInfo *))success failure:(void (^)(NSNumber *, NSString *))failure
{
    NSString *method = @"auctrival/up";
    NSString *ticket = [GetCore(AuthCore) getTicket];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(uid) forKey:@"uid"];
    [params setObject:auctId forKey:@"auctId"];
    [params setObject:@(roomUid) forKey:@"roomUid"];
    [params setObject:@(type) forKey:@"type"];
    [params setObject:@(money) forKey:@"money"];
    [params setObject:ticket forKey:@"ticket"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
//        AuctionInfo *auctionInfo = [AuctionInfo yy_modelWithDictionary:data];
        AuctionInfo *auctionInfo = [AuctionInfo modelDictionary:data];
        if (auctionInfo != nil) {
            success(auctionInfo);
        } else {
            failure(@(10), @"ticket为空");
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)finishAuction:(UserID)uid auctId:(NSString *)auctId success:(void (^)(AuctionInfo *))success failure:(void (^)(NSNumber *, NSString *))failure
{
    NSString *method = @"auction/finish";
    NSString *ticket = [GetCore(AuthCore) getTicket];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(uid) forKey:@"uid"];
    [params setObject:auctId forKey:@"auctId"];
    [params setObject:ticket forKey:@"ticket"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
//        AuctionInfo *auctionInfo = [AuctionInfo yy_modelWithDictionary:data];
        AuctionInfo *auctionInfo = [AuctionInfo modelDictionary:data];
        if (auctionInfo != nil) {
            success(auctionInfo);
        } else {
            failure(@(10), @"ticket为空");
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)getAuction:(UserID)uid success:(void (^)(AuctionInfo *))success failure:(void (^)(NSNumber *, NSString *))failure
{
    NSString *method = @"auction/get";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(uid) forKey:@"uid"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
//        AuctionInfo *auctionInfo = [AuctionInfo yy_modelWithDictionary:data];
        AuctionInfo *auctionInfo = [AuctionInfo modelDictionary:data];
        if (auctionInfo != nil) {
            if (auctionInfo.uid > 0) {
                success(auctionInfo);
            } else {
                success(nil);
            }
        } else {
            failure(@(10), @"ticket为空");
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

+ (void)fetchAuctionTotalListWith:(NSString *)roomUid success:(void (^)(NSArray *))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"sumlist/query";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:roomUid forKey:@"roomUid"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
//        NSArray *list = [NSArray yy_modelArrayWithClass:[AuctionList class] json:data];
        NSArray *list = [AuctionList modelsWithArray:data];
        success(list);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
 
}

+ (void)fetchAuctionWeeklyListWith:(NSString *)roomUid success:(void (^)(NSArray *))success failure:(void (^)(NSNumber *, NSString *))failure {
    NSString *method = @"weeklist/query";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:roomUid forKey:@"roomUid"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
//        NSArray *list = [NSArray yy_modelArrayWithClass:[AuctionList class] json:data];
        NSArray *list = [AuctionList modelsWithArray:data];
        success(list);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode, message);
    }];
}

@end
