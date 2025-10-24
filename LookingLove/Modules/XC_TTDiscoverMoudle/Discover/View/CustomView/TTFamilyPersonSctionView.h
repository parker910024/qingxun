//
//  TTFamilyPersonSctionView.h
//  TuTu
//
//  Created by gzlx on 2018/11/2.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYLabel.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TTFamilyPersonSctionViewType){
    TTFamilyPersonSctionView_hidden,
    TTFamilyPersonSctionView_more,
    TTFamilyPersonSctionView_create,
};

@protocol TTFamilyPersonSctionViewDelegate <NSObject>

- (void)touchViewPushMoreOrCreateGroupAction:(TTFamilyPersonSctionViewType)type;

@end




@interface TTFamilyPersonSctionView : UIView
/** 副标题*/
@property (nonatomic, strong) YYLabel * subTitleLabel;
/** 标题*/
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, assign) TTFamilyPersonSctionViewType type;
@property (nonatomic, assign) id<TTFamilyPersonSctionViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
