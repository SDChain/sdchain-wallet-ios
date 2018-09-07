//
//  BaseModel.h
//  BaseProject6.15
//
//  Created by 钱伟成 on 2017/6/16.
//  Copyright © 2017年 Zeepson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface BaseModel : NSObject

//接收数据使用
- (id)initWithDictionary:(NSDictionary*)jsonDic;

//归档专用
- (id)initWithCoder:(NSCoder *)aDecoder;
- (void)encodeWithCoder:(NSCoder *)aCoder;

@end
