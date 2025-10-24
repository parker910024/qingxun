//
//  RefreshFactory.m
//  XChat
//
//  Created by KevinWang on 2017/11/28.
//  Copyright © 2017年 XC. All rights reserved.
//

#import "RefreshFactory.h"

@implementation RefreshFactory

+ (MJRefreshHeader *)headerRefreshWithTarget:(id)target refreshingAction:(SEL)action
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:action];
    header.stateLabel.font = [UIFont systemFontOfSize:10.0];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:10.0];
    header.arrowView.image = [UIImage imageNamed:@"refreshImage"];
    
    return header;
}

+ (MJRefreshFooter *)footerRefreshWithTarget:(id)target refreshingAction:(SEL)action
{
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:target refreshingAction:action];
//   MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:target refreshingAction:action];
    footer.stateLabel.font = [UIFont systemFontOfSize:10.0];
    return footer;
}

+ (MJRefreshHeader *)headerRefreshWithTarget:(id)target refreshingAction:(SEL)action color:(UIColor *)color {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:action];
    
    if (color) {
        header.stateLabel.textColor = color;
        header.lastUpdatedTimeLabel.textColor = color;
    }
    
    header.stateLabel.font = [UIFont systemFontOfSize:10.0];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:10.0];
    header.arrowView.image = [UIImage imageNamed:@"refreshImage"];
    
    return header;

}

+ (MJRefreshFooter *)footerRefreshWithTarget:(id)target refreshingAction:(SEL)action color:(UIColor *)color {
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:target refreshingAction:action];
    //   MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:target refreshingAction:action];
    if (color) {
        footer.stateLabel.textColor = color;
    }
    footer.stateLabel.font = [UIFont systemFontOfSize:10.0];
    return footer;

}


@end
