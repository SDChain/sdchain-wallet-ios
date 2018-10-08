//
//  UIDevice+COD.h
//  CutOrder
//
//  Created by yhw on 14/12/4.
//  Copyright (c) 2014年 YuQian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (COD)

- (NSString *)cod_model;// device model
- (NSString *)cod_macAddress;// mac address
- (NSString *)cod_ipAddress;// ip address
- (NSString *)cod_uuid;// uuid

@end
