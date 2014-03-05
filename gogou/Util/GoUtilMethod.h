//
//  GoUtilMethod.h
//  goshopping
//
//  Created by ss4346 on 13-11-14.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoUtilMethod : NSObject

+(int)existNetWork;
+(BOOL)isPhoneNum:(NSString *)str;
+(void)writePlist:(NSString *)telephone  password:(NSString *)password userType:(NSString *)userType image:(NSString *)image nickname:(NSString *)nickname;
+(NSString *)getUserType;
+(NSString *)getTelephone;
+(NSString *)getPassword;
+(NSString *)getImagePath;
+(NSString *)getNickName;
+(NSString *)getMarkets;

+(void)setTelephone:(NSString *)telephone;
+(void)setPassword:(NSString *)password;
+(void)setNickName:(NSString *)nickName;
+(void)setImage:(NSString *)image;
+(void)setMarkets:(NSString *)markets;


+(void)clearMessage;

+(BOOL)isLogin;
@end
