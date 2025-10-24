//
//  AccountBindInfo.h
//  AFNetworking
//
//  Created by apple on 2018/11/26.
//

#import "BaseObject.h"

@interface AccountBindInfo : BaseObject
/// 本身手机号，如果未绑定为空字符
@property (nonatomic, copy) NSString *isPh;
/// facebook true为已绑定 false为未d绑定
@property (nonatomic, assign) NSInteger fb;
/// google
@property (nonatomic, assign) NSInteger gg;
/// instagram
@property (nonatomic, assign) NSInteger ins;
/// twitter
@property (nonatomic, assign) NSInteger twi;

@end

