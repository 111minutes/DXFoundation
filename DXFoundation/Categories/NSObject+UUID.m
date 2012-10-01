//
//  NSObject+UUID.m
//  DXFoundation
//
//  Created by Max Mashkov on 10/1/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "NSObject+UUID.h"
#import "NSString+UUID.h"
#import <objc/runtime.h>

const char *kUUIDKey = "kUUIDKey";

@implementation NSObject (UUID)

- (NSString*)UUID
{
    NSString *uuidString = objc_getAssociatedObject(self, kUUIDKey);
    
    if (!uuidString || [uuidString length] == 0) {
        uuidString = [NSString UUID];
        objc_setAssociatedObject(self, kUUIDKey, uuidString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return uuidString;
}

@end
