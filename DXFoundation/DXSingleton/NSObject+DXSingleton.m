//
//  NSObject+DXSingleton+DXSingleton.m
//  DXFoundation
//
//  Created by Sergey Zenchenko on 8/3/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//
#import "DXSingleton.h"
#import "DXSingletonHolder.h"

@interface NSObject (DXSingleton)

@end

@implementation NSObject (DXSingleton)

+ (instancetype)shared
{
    if (![self conformsToProtocol:@protocol(DXSingleton)]) {
        [self doesNotRecognizeSelector:_cmd];
    }
    
    return [[DXSingletonHolder shared] getInstanceOfClass:[self class]];
}

+ (void)destroySharedInstance
{
    [[DXSingletonHolder shared] destroyInstanceOfClass:[self class]];
}

@end
