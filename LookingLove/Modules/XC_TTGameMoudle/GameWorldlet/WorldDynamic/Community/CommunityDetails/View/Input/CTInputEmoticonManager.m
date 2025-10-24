//
//  NTESEmoticonManager.h
//  CT
//
//  Created by amao on 7/2/14.
//  Copyright (c) 2014 Netease. All rights reserved.
//

#import "CTInputEmoticonManager.h"
#import "CTInputEmoticonDefine.h"
#import "NSString+NIMKit.h"
#import "NIMKit.h"

@implementation CTInputEmoticon
@end

@implementation CTInputEmoticonCatalog
@end

@implementation CTInputEmoticonLayout

- (id)initEmojiLayout:(CGFloat)width
{
    self = [super init];
    if (self)
    {
        _rows            = CTKit_EmojRows;
        _columes         = ((width - CTKit_EmojiLeftMargin - CTKit_EmojiRightMargin) / CTKit_EmojImageWidth);
        _itemCountInPage = _rows * _columes -1;
        _cellWidth       = (width - CTKit_EmojiLeftMargin - CTKit_EmojiRightMargin) / _columes;
        _cellHeight      = CTKit_EmojCellHeight;
        _imageWidth      = CTKit_EmojImageWidth;
        _imageHeight     = CTKit_EmojImageHeight;
        _emoji           = YES;
    }
    return self;
}

- (id)initCharletLayout:(CGFloat)width{
    self = [super init];
    if (self)
    {
        _rows            = CTKit_PicRows;
        _columes         = ((width - CTKit_EmojiLeftMargin - CTKit_EmojiRightMargin) / CTKit_PicImageWidth);
        _itemCountInPage = _rows * _columes;
        _cellWidth       = (width - CTKit_EmojiLeftMargin - CTKit_EmojiRightMargin) / _columes;
        _cellHeight      = CTKit_PicCellHeight;
        _imageWidth      = CTKit_PicImageWidth;
        _imageHeight     = CTKit_PicImageHeight;
        _emoji           = NO;
    }
    return self;
}

@end

@interface CTInputEmoticonManager ()
@property (nonatomic,strong)    NSArray *catalogs;
@end

@implementation CTInputEmoticonManager
+ (instancetype)sharedManager
{
    static CTInputEmoticonManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CTInputEmoticonManager alloc]init];
    });
    return instance;
}

- (id)init
{
    if (self = [super init])
    {
        [self parsePlist];
    }
    return self;
}

- (CTInputEmoticonCatalog *)emoticonCatalog:(NSString *)catalogID
{
    for (CTInputEmoticonCatalog *catalog in _catalogs)
    {
        if ([catalog.catalogID isEqualToString:catalogID])
        {
            return catalog;
        }
    }
    return nil;
}


- (CTInputEmoticon *)emoticonByTag:(NSString *)tag
{
    CTInputEmoticon *emoticon = nil;
    if ([tag length])
    {
        for (CTInputEmoticonCatalog *catalog in _catalogs)
        {
            emoticon = [catalog.tag2Emoticons objectForKey:tag];
            if (emoticon)
            {
                break;
            }
        }
    }
    return emoticon;
}


- (CTInputEmoticon *)emoticonByID:(NSString *)emoticonID
{
    CTInputEmoticon *emoticon = nil;
    if ([emoticonID length])
    {
        for (CTInputEmoticonCatalog *catalog in _catalogs)
        {
            emoticon = [catalog.id2Emoticons objectForKey:emoticonID];
            if (emoticon)
            {
                break;
            }
        }
    }
    return emoticon;
}

- (CTInputEmoticon *)emoticonByCatalogID:(NSString *)catalogID
                           emoticonID:(NSString *)emoticonID
{
    CTInputEmoticon *emoticon = nil;
    if ([emoticonID length] && [catalogID length])
    {
        for (CTInputEmoticonCatalog *catalog in _catalogs)
        {
            if ([catalog.catalogID isEqualToString:catalogID])
            {
                emoticon = [catalog.id2Emoticons objectForKey:emoticonID];
                break;
            }
        }
    }
    return emoticon;
}

- (void)parsePlist
{
    NSMutableArray *catalogs = [NSMutableArray array];
    
//    NSURL *url = [[NSBundle mainBundle] URLForResource:[[NIMKitsharedKit] emoticonBundleName] withExtension:nil];
//    NSBundle *bundle = [NSBundle bundleWithURL:url];
//     NSString *filepath = [bundle pathForResource:@"emoji" ofType:@"plist" inDirectory:CTKit_EmojiPath];
   
    
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"emoji" ofType:@"plist"];
    if (filepath) {
        NSArray *array = [NSArray arrayWithContentsOfFile:filepath];
        for (NSDictionary *dict in array)
        {
            NSDictionary *info = dict[@"info"];
            NSArray *emoticons = dict[@"data"];
            
            CTInputEmoticonCatalog *catalog = [self catalogByInfo:info
                                                     emoticons:emoticons];
            [catalogs addObject:catalog];
        }
    }
    _catalogs = catalogs;
}

- (CTInputEmoticonCatalog *)catalogByInfo:(NSDictionary *)info
                             emoticons:(NSArray *)emoticonsArray
{
    CTInputEmoticonCatalog *catalog = [[CTInputEmoticonCatalog alloc]init];
    catalog.catalogID   = info[@"id"];
    catalog.title       = info[@"title"];
    NSString *iconNamePrefix = CTKit_EmojiPath;
    NSString *icon      = info[@"normal"];
    catalog.icon = [iconNamePrefix stringByAppendingPathComponent:icon];
    NSString *iconPressed = info[@"pressed"];
    catalog.iconPressed = [iconNamePrefix stringByAppendingPathComponent:iconPressed];

    
    NSMutableDictionary *tag2Emoticons = [NSMutableDictionary dictionary];
    NSMutableDictionary *id2Emoticons = [NSMutableDictionary dictionary];
    NSMutableArray *emoticons = [NSMutableArray array];
    
    for (NSDictionary *emoticonDict in emoticonsArray) {
        CTInputEmoticon *emoticon  = [[CTInputEmoticon alloc] init];
        emoticon.emoticonID     = emoticonDict[@"id"];
        emoticon.tag            = emoticonDict[@"tag"];
        NSString *fileName      = emoticonDict[@"file"];
        NSString *imageNamePrefix = CTKit_EmojiPath;
        
        emoticon.filename = [imageNamePrefix stringByAppendingPathComponent:fileName];
        if (emoticon.emoticonID) {
            [emoticons addObject:emoticon];
            id2Emoticons[emoticon.emoticonID] = emoticon;
        }
        if (emoticon.tag) {
            tag2Emoticons[emoticon.tag] = emoticon;
        }
    }
    
    catalog.emoticons       = emoticons;
    catalog.id2Emoticons    = id2Emoticons;
    catalog.tag2Emoticons   = tag2Emoticons;
    return catalog;
}


@end
