//
//  RankData.m
//  BberryCore
//
//  Created by 卫明何 on 2018/4/20.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "RankData.h"

@implementation RankData

- (void)setGoldAmount:(NSString *)goldAmount {
    _goldAmount = [self changeAsset:goldAmount];
}


#pragma mark - 把大长串的数字做单位处理

- (NSString *)changeAsset:(NSString *)amountStr

{
    
    if (amountStr && ![amountStr isEqualToString:@""])
        
    {
        
        double num = [amountStr doubleValue];
        
        if (num<10000)
            
        {
            
            return amountStr;
            
        }
        
        else
            
        {
            
            NSString *str = [NSString stringWithFormat:@"%.1f",num/10000.0];
            
            NSRange range = [str rangeOfString:@"."];
            
            str = [str substringToIndex:range.location+2];
            
            if ([str hasSuffix:@".0"])
                
            {
                
                return [NSString stringWithFormat:@"%@万",[str substringToIndex:str.length-2]];
                
            }
            
            else
                
                return [NSString stringWithFormat:@"%@万",str];
            
        }
        
    }
    
    else
        
        return @"0";
    
}

@end
