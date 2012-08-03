//
//  DXSingletoneHolder.m
//  DXFoundation
//
//  Created by Sergey Zenchenko on 8/3/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "DXSingletoneHolder.h"

@interface DXSingletoneHolder ()

@property (nonatomic, strong) NSDictionary *singltonesClassPairs;
@property (nonatomic, assign) dispatch_queue_t singltoneQueue;
@end

@implementation DXSingletoneHolder

+ (instancetype)shared
{
    static DXSingletoneHolder *sharedHolder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHolder = [DXSingletoneHolder new];
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
        self.singltoneQueue = dispatch_queue_create("com.111min.dxfoundation.singltone_queue", DISPATCH_QUEUE_CONCURRENT);
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

@end
