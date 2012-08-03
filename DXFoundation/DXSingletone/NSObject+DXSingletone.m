//
//  NSObject+DXSingletone.m
//  DXFoundation
//
//  Created by Sergey Zenchenko on 8/3/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//
#import "DXSingletone.h"
#import "DXSingletoneHolder.h"

@interface NSObject (DXSingletone)

@end


@implementation NSObject (DXSingletone)

+ (instancetype)shared
{
    if (![self conformsToProtocol:@protocol(DXSingletone)]) {
        @throw [NSException exceptionWithName:@"DXSingletone error" reason:@"Class should conforms to DXSingletone protocol" userInfo:nil];
    }
    
    return [[DXSingletoneHolder shared] getInstanceOfClass:[self class]];
}

@end
