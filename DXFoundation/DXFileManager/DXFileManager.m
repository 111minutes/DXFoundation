//
//  DXFileManager.m
//  DXFoundation
//
//  Created by Max Mashkov on 10/16/12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "DXFileManager.h"
#import <sys/xattr.h>
#import <CommonCrypto/CommonDigest.h>

@implementation DXFileManager

+ (DXFileManager*)defaultManager
{
    return [self shared];
}


#pragma mark - Helpers

- (long long)freeMemorySpace
{
    NSDictionary *attributesDict = [self attributesOfFileSystemForPath:NSHomeDirectory()
                                                                 error:NULL];
    
    long long freeMemory = [[attributesDict objectForKey:NSFileSystemFreeSize] longLongValue];
    return freeMemory;
}

- (NSString *)pathToDocumentsDirectory
{
    static NSString *documentsDirectory = nil;
    static dispatch_once_t dispatch_token;
    dispatch_once(&dispatch_token, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDirectory = [paths objectAtIndex:0];
    });
    return documentsDirectory;
}


#pragma mark - iCloud sync

- (BOOL)skipSync:(BOOL)skip forItemAtUrl:(NSURL *)URL error:(NSError**)error
{
    assert([self fileExistsAtPath: [URL path]]);
    
    BOOL isExcludedFromBackupKeyAvailable = (&NSURLIsExcludedFromBackupKey != NULL);
    
    BOOL success = NO;
    
    if (isExcludedFromBackupKeyAvailable) {
        
        success = [URL setResourceValue:@(skip)
                                 forKey:NSURLIsExcludedFromBackupKey
                                  error:error];
    } else {
        
        const char* filePath = [[URL path] fileSystemRepresentation];
        
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = (int)skip;
        
        success = (BOOL)setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    }
    
    return success;
}


#pragma mark - File MD5

- (NSString *)MD5ForFileAtPath:(NSString *)path
{
    assert([self fileExistsAtPath:path]);
    
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    if (handle == nil) {
        return nil;
    }
    
    CC_MD5_CTX md5;
    
    CC_MD5_Init(&md5);
    
    BOOL done = NO;
    while (!done) {
        @autoreleasepool {
            NSData *fileData = [handle readDataOfLength:1024];
            CC_MD5_Update(&md5, [fileData bytes], [fileData length]);
            if ([fileData length] == 0) {
                done = YES;
            }
        }
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString *s = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0], digest[1],
                   digest[2], digest[3],
                   digest[4], digest[5],
                   digest[6], digest[7],
                   digest[8], digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    return s;
}


- (NSString *)MD5ForFileAtURL:(NSURL *)URL
{
    return [self MD5ForFileAtPath:[URL path]];
}

@end
