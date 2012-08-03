//
//  DXSingletone.h
//  DXFoundation
//
//  Created by Sergey Zenchenko on 8/3/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DXSingletone <NSObject>

@optional

+ (instancetype)shared;

@end
