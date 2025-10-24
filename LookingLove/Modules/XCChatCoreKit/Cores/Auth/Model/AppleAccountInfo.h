//
//  AppleAccountInfo.h
//  XCChatCoreKit
//
//  Created by Lee on 2019/12/24.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

/**

authCode = "cc4f9dba9a94d4740a78ace76f28ee53f.0.nzrv.FoSVIHS-_j9lyPS7Vr0aig";
expired = "1577172468870.13";
rawData =     {
    authorizationCode = {length = 63, bytes = 0x63633466 39646261 39613934 64343734 ... 53375672 30616967 };
    authorizedScopes =         (
    );
    email = "rsqyhm6uy4@privaterelay.appleid.com";
    fullName =         {
        familyName = "\U674e";
        givenName = "\U5bcc\U9f99";
    };
    identityToken = {length = 794, bytes = 0x65794a72 61575169 4f694a42 53555250 ... 61495642 5f774f41 };
    realUserStatus = 1;
    user = "000915.f9e8e4aa631b45af9028e87fcfc0536b.0324";
};


token = "eyJraWQiOiJBSURPUEsxIiwiYWxnIjoiUlMyNTYifQ.eyJpc3MiOiJodHRwczovL2FwcGxlaWQuYXBwbGUuY29tIiwiYXVkIjoiY29tLmxhaWh1aS5sb29raW5nbG92ZSIsImV4cCI6MTU3NzE3MjQ2OCwiaWF0IjoxNTc3MTcxODY4LCJzdWIiOiIwMDA5MTUuZjllOGU0YWE2MzFiNDVhZjkwMjhlODdmY2ZjMDUzNmIuMDMyNCIsImNfaGFzaCI6ImExeUVEQ0EyZVlLZWJaZEI2ZGMxR2ciLCJlbWFpbCI6InJzcXlobTZ1eTRAcHJpdmF0ZXJlbGF5LmFwcGxlaWQuY29tIiwiZW1haWxfdmVyaWZpZWQiOiJ0cnVlIiwiaXNfcHJpdmF0ZV9lbWFpbCI6InRydWUiLCJhdXRoX3RpbWUiOjE1NzcxNzE4Njh9.QJtE2to3Qw9bXpwTKM19IGZZRkAZ1c1zDQMHGmOng8EG_flmUbcHjbWHt7Hpwmg_qHXE0h1Nc_qaFzj2y3XiwEiyH0YjL5bpzUOy7L5d4622z2vFGLYO1iCsLyEMESkpUhTgwbNhIfwbFqeW7VceqcuYz-6u7Qvi3Po0PQsX2isocFDVCGqm_9ASbxEh7dnktLo09jswYOEkVW-DkQequf4Qske91ZmbfTAOy60mj7yQ_9fhOLB-9b2lfCCI6mttUqhnx0PdQUoDm3arAk9t4Ix4zQeexLtXxKoy_2jP-QxLgGqrhKc36x0Xhz0Ph5jOWd1dBklg-lqydzaIVB_wOA";
type = 2;
uid = "000915.f9e8e4aa631b45af9028e87fcfc0536b.0324";
*/

@interface FullName : BaseObject
// 姓氏
@property (nonatomic, copy) NSString *familyName;
// 名字
@property (nonatomic, copy) NSString *givenName;

@end


@interface AppleAccountInfo : BaseObject

@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *authCode;
@property (nonatomic, copy) NSString *user;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *identityToken;
@property (nonatomic, strong) FullName *fullName;
@property (nonatomic, copy) NSString *appleFullName;

@end

NS_ASSUME_NONNULL_END
