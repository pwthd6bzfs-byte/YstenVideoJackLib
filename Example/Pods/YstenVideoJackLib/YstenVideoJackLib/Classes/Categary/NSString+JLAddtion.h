//
//  NSString+GMAddtion.h
//  GoMaster
//
//  Created by percent on 2024/1/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (JLAddtion)

    ///SHA-1加密
- (NSString *)jl_EncryptSHA1;

    ///SHA-256加密
- (NSString *)jl_EncryptSHA256;

    ///MD5加密
- (NSString *)jl_EncryptMD5;


@end

NS_ASSUME_NONNULL_END
