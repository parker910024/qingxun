//
//  TTHomeV4Data.h
//  AFNetworking
//
//  Created by lvjunhang on 2019/2/15.
//  兔兔首页请求返回数据模型 v4接口

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

//首页模块类型(1为墙裂推荐,2为热门推荐,3是推荐页自定义模块,4是banner)
typedef NS_ENUM(NSUInteger, TTHomeV4DataType) {
    TTHomeV4DataTypeSuper = 1,//墙裂推荐
    TTHomeV4DataTypeHot = 2,//热门推荐
    TTHomeV4DataTypeCustom = 3,//推荐页自定义模块
    TTHomeV4DataTypeBanner = 4,//banner
};

@class TTHomeV4DetailData;

@interface TTHomeV4Data : BaseObject
@property (nonatomic, assign) TTHomeV4DataType type;
@property (nonatomic, assign) NSInteger maxNum;//首页模块展示大图数
@property (nonatomic, copy) NSString *title;//首页模块标题
@property (nonatomic, strong) NSArray<TTHomeV4DetailData *> *data;
@end

NS_ASSUME_NONNULL_END
