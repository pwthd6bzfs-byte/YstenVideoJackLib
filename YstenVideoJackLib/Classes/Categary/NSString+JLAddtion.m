//
//  NSString+GMAddtion.m
//  GoMaster
//
//  Created by percent on 2024/1/26.
//

#import "NSString+JLAddtion.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (JLAddtion)

- (NSString *)jl_EncryptSHA1 {
    if (self.length<=0) return nil;
    
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [NSData dataWithBytes:cstr length:self.length];
    
    return [NSString jl_EncryptSHA1:keyData];
}
+ (NSString *)jl_EncryptSHA1:(NSData *)keyData {
    if (keyData.length<=0) return nil;
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(keyData.bytes, (unsigned int)keyData.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

- (NSString *)jl_EncryptSHA256 {
    if (self.length<=0) return nil;
    
    const char *s = [self cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
    
    return [NSString jl_EncryptSHA256:keyData];
}
+ (NSString *)jl_EncryptSHA256:(NSData *)keyData {
    if (keyData.length<=0) return nil;
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH] = {0};
    CC_SHA256(keyData.bytes, (CC_LONG)keyData.length, digest);
    NSData *out = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash = [out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    return hash;
}

- (NSString *)jl_EncryptMD5 {
    if (self.length<=0) return nil;
    
    const char *cStr = [self UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return  output;
}



@end
