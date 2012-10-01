//
//  DXSingleton.h//  DXFoundation
//
//  Created by Sergey Zenchenko on 8/3/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DXSingleton <NSObject>

@optional

+ (instancetype)shared;
+ (void)destroySharedInstance;

@end
