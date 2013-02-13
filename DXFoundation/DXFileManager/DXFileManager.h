//
//  DXFileManager.h
//  DXFoundation
//
//  Created by Max Mashkov on 10/16/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "DXSingleton.h"

@interface DXFileManager : NSFileManager <DXSingleton>

+ (DXFileManager*)defaultManager;

#pragma mark - Helpers

- (NSString *)pathToDocumentsDirectory;
- (NSString *)pathToCacheDirectory;
- (long long)freeMemorySpace;


#pragma mark - iCloud sync

- (BOOL)skipSync:(BOOL)skip forItemAtUrl:(NSURL *)URL error:(NSError**)error;


#pragma mark - File MD5

- (NSString *)MD5ForFileAtPath:(NSString *)path;
- (NSString *)MD5ForFileAtURL:(NSURL *)URL;

@end
