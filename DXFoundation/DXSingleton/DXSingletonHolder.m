//
//  DXSingletonHolder.m//  DXFoundation
//
//  Created by Sergey Zenchenko on 8/3/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "DXSingletonHolder.h"

@interface DXSingletonHolder ()

@property (nonatomic, strong) NSDictionary *singletonsClassPairs;
@property (nonatomic, assign) dispatch_queue_t singletonQueue;
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
    dispatch_release(self.singletonQueue);
}

- (id)init
{
    self = [super init];
    if (self) {
        self.singletonsClassPairs = [NSMutableDictionary new];
        self.singletonQueue = dispatch_queue_create("com.111min.foundation.singleton_queue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (id)getInstanceOfClass:(Class)requiredClass
{
    __block id instance;
    
    dispatch_sync(self.singletonQueue, ^{
        instance = [self.singletonsClassPairs valueForKey:NSStringFromClass(requiredClass)];
    });
    
    if (!instance) {
        instance = [requiredClass new];
        dispatch_barrier_sync(self.singletonQueue, ^{
            [self.singletonsClassPairs setValue:instance forKey:NSStringFromClass(requiredClass)];
        });
    }
    
    return instance;
}

- (void)destroyInstanceOfClass:(Class)requiredClass
{
    dispatch_barrier_async(self.singletonQueue, ^{
        [self.singletonsClassPairs setValue:nil forKey:NSStringFromClass(requiredClass)];
    });
}

- (void)destroyAll
{
    dispatch_barrier_async(self.singletonQueue, ^{
        self.singletonsClassPairs = [NSMutableDictionary new];
    });
}

@end
