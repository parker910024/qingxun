//
//  WMAdImageTool.m
//
//
//  Created by zn on 16/8/11.
//
//

#import "WMAdImageTool.h"
#import "WMAdvertiseView.h"
#import "AdCore.h"

@implementation WMAdImageTool

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

/**
 *  判断文件是否存在
 */
+ (BOOL)isFileExistWithFilePath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = FALSE;
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
}

/**
 *  初始化广告页面
 */
+ (void)getAdvertisingImage{
    
    if (GetCore(AdCore).splash.pict.length > 0) {
        NSString *imageUrl = GetCore(AdCore).splash.pict;
        // 获取图片名
        NSArray *stringArr = [imageUrl componentsSeparatedByString:@"/"];
        NSString *imageName = stringArr.lastObject;
        
        // 拼接沙盒路径
        NSString *filePath = [self getFilePathWithImageName:imageName];
        BOOL isExist = [self isFileExistWithFilePath:filePath];
        if (!isExist){// 如果该图片不存在，则删除老图片，下载新图片
            [self downloadAdImageWithUrl:imageUrl imageName:imageName];
        }
    }else {
        [self deleteOldImage];
    }
}

/**
 *  下载新图片
 */
+ (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSString *thumbnail = [NSString stringWithFormat:@"?imageMogr2/thumbnail/%fx%f",[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height];
//        [imageUrl stringByAppendingString:thumbnail];
//        imageMogr2/thumbnail/220x220
        
        NSString *encode = [imageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:encode]];
        UIImage *image = [UIImage imageWithData:data];
        
        NSString *filePath = [self getFilePathWithImageName:imageName]; // 保存文件的名称
        
        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {// 保存成功
            [self deleteOldImage];
            [kUserDefaults setValue:imageName forKey:adImageName];
            [kUserDefaults synchronize];
        }else{
            [self deleteOldImage];
        }
        
    });
}

/**
 *  删除旧图片
 */
+ (void)deleteOldImage
{
    NSString *imageName = [kUserDefaults valueForKey:adImageName];
    if (imageName) {
        NSString *filePath = [self getFilePathWithImageName:imageName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
    }
}

/**
 *  根据图片名拼接文件路径
 */
+ (NSString *)getFilePathWithImageName:(NSString *)imageName
{
    if (imageName) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
        
        return filePath;
    }
    
    return nil;
}


-(void)EventHappeningMutual{   
    UIImage *PresentsWinnerWantOlympicDayItEvent = [UIImage new];
    UIImageView *WorldHonorTryWhichAthletes = [UIImageView new];
    NSString *ByMostShow = @"CompetitorsPunishedToSoTheIf";
    UIButton *OtherSoSpiritsToJuneHardCommitteeHighestAsOf = [UIButton new];
    NSString *OfMatterHeroesrdAnd = @"WorldBetweenTheWorldOfTheGamesOfYearsHeldHardGamesAnd";
    UIImage *ProveNamedOlympianNowadaysAllAndOneGreatWhoOf = [UIImage new];
}
 
@end
