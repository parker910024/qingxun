//
//  CTUnreadModel.m
//  LTChat
//
//  Created by apple on 2019/8/5.
//  Copyright © 2019 wujie. All rights reserved.
//

#import "LTUnreadModel.h"

@implementation LTUnreadModel
- (long)allCount{
    return _likeCount+_commentCount ? : 0;
}
@end
