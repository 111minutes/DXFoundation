//
//  NSObject+DXSingleton+DXKVO.h
//  DXFoundation
//
//  Created by Sergey Zenchenko on 8/4/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DXKVO)

- (void)addObserverForKeyPath:(NSString *)keyPath expectedValue:(id)value callback:(void(^)())callback;

- (void)removeObserverForKeyPath:(NSString *)aKeyPath;

@end
