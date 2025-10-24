//
//  DiscoverListModel.h
//  AFNetworking
//
//  Created by gzlx on 2018/8/29.
//

#import "BaseObject.h"
#import "P2PInteractiveAttachment.h"

@interface DiscoverListModel : BaseObject
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * subheading;
@property (nonatomic, copy) NSString * icon;
@property (nonatomic, assign) P2PInteractive_SkipType routerType;
@property (nonatomic, copy) NSString * routerValue;
@end
