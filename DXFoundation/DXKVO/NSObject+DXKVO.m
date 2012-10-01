//
//  NSObject+DXSingleton+DXKVO.m
//  DXFoundation
//
//  Created by Sergey Zenchenko on 8/4/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+DXKVO.h"
#import "DXKVOHandler.h"

static char *assocKey = "DXKVOStorage";

@implementation NSObject (DXKVO)

- (void)addObserverForKeyPath:(NSString *)keyPath expectedValue:(id)value callback:(void(^)())callback
{
    DXKVOHandler *handler = [DXKVOHandler new];

    handler.expectedValue = value;
    handler.callback = callback;
    handler.keyPath = keyPath;
    handler.target = self;

    NSMutableArray *kvoHandlers = objc_getAssociatedObject(self, assocKey);
    
    if (!kvoHandlers) {
        kvoHandlers = [NSMutableArray new];
        objc_setAssociatedObject(self, &assocKey, kvoHandlers, OBJC_ASSOCIATION_RETAIN);
    }

    [kvoHandlers addObject:handler];

    [self addObserver:handler forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:nil];
}

@end
