//
//  NSString+MD5.m
//  ZhenPin
//
//  Created by 董伟1 on 15/11/19.
//  Copyright © 2015年 zhenpin. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5)

- (NSString  *)md5String
{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, self.length, digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}

@end
