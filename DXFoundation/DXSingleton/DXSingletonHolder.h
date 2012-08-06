//
//  DXSingletonHolder.h//  DXFoundation
//
//  Created by Sergey Zenchenko on 8/3/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DXSingleton.h"

@interface DXSingletonHolder : NSObject <DXSingleton>

- (id)getInstanceOfClass:(Class)requiredClass;
- (void)destroyInstanceOfClass:(Class)requiredClass;
- (void)destroyAll;

@end
