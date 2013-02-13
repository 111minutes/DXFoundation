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

@interface NSObject (DXKVO)

@property (nonatomic, strong) NSMutableArray *kvoHandlers;

@end

@implementation NSObject (DXKVO)

- (void)addObserverForKeyPath:(NSString *)keyPath expectedValue:(id)value callback:(void(^)())callback
{
    DXKVOHandler *handler = [DXKVOHandler new];

    handler.expectedValue = value;
    handler.callback = callback;
    handler.keyPath = keyPath;
    handler.target = self;

     self.kvoHandlers = objc_getAssociatedObject(self, assocKey);
    
    if (!self.kvoHandlers) {
        self.kvoHandlers = [NSMutableArray new];
        objc_setAssociatedObject(self, &assocKey, self.kvoHandlers, OBJC_ASSOCIATION_RETAIN);
    }

    [self.kvoHandlers addObject:handler];

    [self addObserver:handler forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserverForKeyPath:(NSString *)aKeyPath
{
    for (DXKVOHandler *handler in self.kvoHandlers) {
        if ([handler.keyPath isEqualToString:aKeyPath]) {
            [handler removeObserver];
            [self.kvoHandlers removeObject:handler];
            
            break;
        }
    }
}

@end
