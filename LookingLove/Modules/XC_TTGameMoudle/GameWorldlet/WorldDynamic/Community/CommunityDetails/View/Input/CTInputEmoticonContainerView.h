//
//  CTInputEmoticonContainerView.h
//  CTKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import "NIMPageView.h"
#import "NIMSessionConfig.h"

@class CTInputEmoticonCatalog;
@class CTInputEmoticonTabView;

@protocol CTInputEmoticonProtocol <NSObject>

- (void)didPressSend:(id)sender;

- (void)selectedEmoticon:(NSString*)emoticonID catalog:(NSString*)emotCatalogID description:(NSString *)description;

@end


@interface CTInputEmoticonContainerView : UIView<NIMPageViewDataSource,NIMPageViewDelegate>

@property (nonatomic, strong)  NIMPageView *emoticonPageView;
@property (nonatomic, strong)  UIPageControl  *emotPageController;
@property (nonatomic, strong)  NSArray                    *totalCatalogData;
@property (nonatomic, strong)  CTInputEmoticonCatalog    *currentCatalogData;
@property (nonatomic, readonly)NSArray            *allEmoticons;
@property (nonatomic, strong)  CTInputEmoticonTabView   *tabView;
@property (nonatomic, weak)    id<CTInputEmoticonProtocol>  delegate;
@property (nonatomic, weak)    id<NIMSessionConfig> config;

@end

