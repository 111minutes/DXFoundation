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
#import <AssetsLibrary/AssetsLibrary.h>

@interface DXFileManager ()

@property (nonatomic, strong) NSMutableDictionary *direcotryPaths;

@end

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
    return [self pathToDir:NSDocumentDirectory];
}

- (NSString *)pathToCacheDirectory
{
    return [self pathToDir:NSCachesDirectory];
}

- (NSString *)pathToDir:(NSSearchPathDirectory)aPathDirectory
{
    if (!self.direcotryPaths) {
        self.direcotryPaths = [NSMutableDictionary new];
    }
    
    NSString *pathKey = @(aPathDirectory).stringValue;
    
    NSString *pathToDir = [self.direcotryPaths valueForKey:pathKey];
    
    if (!pathToDir) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(aPathDirectory, NSUserDomainMask, YES);
        pathToDir = [paths objectAtIndex:0];
        
        [self.direcotryPaths setObject:pathToDir forKey:pathKey];
    }

    return pathToDir;
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

+ (void)copyALAsset:(ALAsset *)asset
      toFileWithURL:(NSURL *)fileURL
      progressBlock:(void (^)(float progress))progressBlock
       successBlock:(void (^)(NSURL *fileURL, NSString *md5))successBlock

{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[fileURL path]]) {
        [[NSFileManager defaultManager] createFileAtPath:[fileURL path]
                                                contents:nil
                                              attributes:nil];
    }
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:[fileURL path]];
    
    ALAssetRepresentation *defaultRepresentation = [asset defaultRepresentation];
    
    NSInteger iteration = 0;
    
    size_t BufferSize = 2 * 1024 * 1024 * sizeof(uint8_t);
    
    NSUInteger offset = 0, bytesRead = 0;
    
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    
    do {
        @autoreleasepool {
            @try {
                
                uint8_t *buffer = calloc(BufferSize, sizeof(*buffer));
                
                NSError *error = nil;
                
                bytesRead = [defaultRepresentation getBytes:buffer
                                                 fromOffset:offset
                                                     length:BufferSize
                                                      error:&error];
                
                NSData *data = [NSData dataWithBytesNoCopy:buffer
                                                    length:bytesRead
                                              freeWhenDone:YES];
                
                CC_MD5_Update(&md5, [data bytes], [data length]);
                
                [fileHandle writeData:data];
                
                offset += bytesRead;
                
            } @catch (NSException *exception) {
                
                return;
            }
        }
        
        float progress = (float)((float)(iteration * BufferSize) /
                                 (float)(defaultRepresentation.size));
        
        if (progress >= 1.f) {
            progress = 1.f;
        }
        
        if (progressBlock) {
            progressBlock(progress);
        }
        
        iteration++;
        
    } while (bytesRead > 0);
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString *md5String = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                           digest[0], digest[1],
                           digest[2], digest[3],
                           digest[4], digest[5],
                           digest[6], digest[7],
                           digest[8], digest[9],
                           digest[10], digest[11],
                           digest[12], digest[13],
                           digest[14], digest[15]];
    
    if (successBlock) {
        successBlock(fileURL, md5String);
    }
}

@end
