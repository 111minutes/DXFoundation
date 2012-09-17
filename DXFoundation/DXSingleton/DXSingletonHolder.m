//
//  DXSingletonHolder.m//  DXFoundation
//
//  Created by Sergey Zenchenko on 8/3/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "DXSingletonHolder.h"

@interface DXSingletonHolder ()

@property (nonatomic, strong) NSDictionary *singltonesClassPairs;
@property (nonatomic, assign) dispatch_queue_t singltoneQueue;
@end

@implementation DXSingletonHolder

+ (instancetype)shared
{
    static DXSingletonHolder *sharedHolder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHolder = [DXSingletonHolder new];
    });
    return sharedHolder;
}

- (void)dealloc
{
    dispatch_release(self.singltoneQueue);
}

- (id)init
{
    self = [super init];
    if (self) {
        self.singltonesClassPairs = [NSMutableDictionary new];
        self.singltoneQueue = dispatch_queue_create("com.111min.foundation.singltone_queue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (id)getInstanceOfClass:(Class)requiredClass
{
    __block id instance;
    
    dispatch_sync(self.singltoneQueue, ^{
        instance = [self.singltonesClassPairs valueForKey:NSStringFromClass(requiredClass)];
    });
    
    if (!instance) {
        dispatch_barrier_sync(self.singltoneQueue, ^{
            instance = [requiredClass new];
            [self.singltonesClassPairs setValue:instance forKey:NSStringFromClass(requiredClass)];
        });
    }
    
    return instance;
}

- (void)destroyInstanceOfClass:(Class)requiredClass
{
    dispatch_barrier_async(self.singltoneQueue, ^{
        [self.singltonesClassPairs setValue:nil forKey:NSStringFromClass(requiredClass)];
    });
}

- (void)destroyAll
{
    dispatch_barrier_async(self.singltoneQueue, ^{
        self.singltonesClassPairs = [NSMutableDictionary new];
    });
}

@end