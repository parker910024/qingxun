//
//  HomeTag.h
//  BberryCore
//
//  Created by Mac on 2017/11/21.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "BaseObject.h"
/*room/tag/top   home tag
 room/tag/all   room all tag
 "id":8,
 "name":"聊天",
 "pict":"https://img.erbanyy.com/tag%E8%81%8A%E5%A4%A9.png",
 "seq":3,
 "type":1,
 "status":true,
 "istop":true,
 "createTime":1511155717000
 */
@interface HomeTag : BaseObject
@property (nonatomic, assign) int id;  //quary use
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pict;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) int seq;
@property (nonatomic, assign) int type;
@property (nonatomic, assign) int status;
@property (nonatomic, assign) BOOL istop;
@end
