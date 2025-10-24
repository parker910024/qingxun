//
//  CTDynamicModel.m
//  UKiss
//
//  Created by apple on 2018/12/4.
//  Copyright © 2018 yizhuan. All rights reserved.
//

#import "CTDynamicModel.h"
#import "UIImage+_1x1Color.h"
#import "XCMacros.h"
#import "XCTheme.h"

@interface CTDynamicModel ()

@property (nonatomic, strong) UILabel *cacheLab;

@end

@implementation CTDynamicModel

- (instancetype)copyWithZone:(NSZone *)zone{
    CTDynamicModel * model = [[CTDynamicModel allocWithZone:zone] init];
    unsigned int count;
    Ivar *ivar = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i++) {
        Ivar iv = ivar[i];
        const char *name = ivar_getName(iv);
        NSString *strName = [NSString stringWithUTF8String:name];
        //利用KVC取值
        if ([strName isEqualToString:@"_cacheLab"]) {
            model.cacheLab = self.cacheLab;
            continue;
        }
        id value = [[self valueForKey:strName] copy];//如果还套了模型也要copy呢
        [model setValue:value forKey:strName];
    }
    free(ivar);
    return model;
}


+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"ID" : @"id"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"commentVoList" : [CTCommentReplyModel class],
             @"dynamicResList" : [LLDynamicImageModel class]
             };
}


- (CGFloat)getContentTextNoEmptyText:(NSString *)text {
    if (!text.length) return 0 ;
    NSMutableArray * textArr = [text componentsSeparatedByString:@"\n"].mutableCopy;
    NSInteger emptyLine = 0;
    NSMutableArray *tempArr = textArr.mutableCopy;
    for (NSString *str in textArr) {
        if (!str.length) {
            [tempArr removeObject:str];
            emptyLine++;
        }
    }
    NSString *lineText = [tempArr componentsJoinedByString:@"\n"];
    self.cacheLab.text = lineText;
    CGFloat contentMaxHeight = [self.cacheLab sizeThatFits:CGSizeMake(KScreenWidth - 40, CGFLOAT_MAX)].height;
    contentMaxHeight += (emptyLine * (self.cacheLab.font.lineHeight + 1));
    return contentMaxHeight;
}


- (NSString *)city {
    return _city.length > 0 ? _city : @"火星";//默认火星
}

+ (UIImage *)modelWithPictureImageBg{
    NSArray<UIColor *> * arr = @[UIColorFromRGB(0xF9EABA),UIColorFromRGB(0xC4DAE8),UIColorFromRGB(0x70B3B3),UIColorFromRGB(0xA6DAE0),UIColorFromRGB(0xF3D4AB),UIColorFromRGB(0xEDEDED)];
    NSInteger index = arc4random_uniform(1000)%arr.count;
    UIImage * img = [UIImage instantiate1x1ImageWithColor:arr[index]];
    return img;
}

- (void)setImageUrl:(NSArray<NSString *> *)imageUrl {
    _imageUrl = imageUrl;
    if (_imageUrl.count == 1) {
        self.oneImageHeight = 297;
    }
}

- (UILabel *)cacheLab {
    if (!_cacheLab) {
        _cacheLab = [[UILabel alloc]init];
        _cacheLab.font = [UIFont systemFontOfSize:15];
        _cacheLab.numberOfLines = 0;
    }
    return _cacheLab;
}
@end
