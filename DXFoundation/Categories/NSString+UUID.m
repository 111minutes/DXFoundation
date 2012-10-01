//
//  NSString+UUID.m
//  DXFoundation
//
//  Created by Max Mashkov on 10/1/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "NSString+UUID.h"

@implementation NSString (UUID)

+ (NSString *)UUID
{
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);

    NSString *uuidString = (__bridge_transfer NSString *) CFUUIDCreateString(kCFAllocatorDefault, uuid);

    CFRelease(uuid);
    
    return uuidString;
}

@end
