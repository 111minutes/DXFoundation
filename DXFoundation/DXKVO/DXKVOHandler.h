//
//  DXKVOHandler.h
//  DXFoundation
//
//  Created by Sergey Zenchenko on 8/4/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DXKVOHandler : NSObject


@property(nonatomic, strong) id expectedValue;
@property(nonatomic, copy) void (^callback)();
@property(nonatomic, copy) NSString *keyPath;

@property(nonatomic, weak) NSObject *target;
@end
