//
//  DXKVOHandler.m
//  DXFoundation
//
//  Created by Sergey Zenchenko on 8/4/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "DXKVOHandler.h"

@implementation DXKVOHandler

- (void)dealloc
{
    if (self.target) {
        [self removeObserver];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:self.keyPath]) {
        if (self.callback) {
            self.callback();
        }
    }
}

- (void)removeObserver
{
    [self.target removeObserver:self forKeyPath:self.keyPath];
    
    self.target = nil;
    self.keyPath = nil;
    self.callback = nil;
    self.expectedValue = nil;
}

@end
