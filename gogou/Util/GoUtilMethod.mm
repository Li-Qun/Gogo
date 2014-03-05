//
//  GoUtilMethod.m
//  goshopping
//
//  Created by ss4346 on 13-11-14.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import "GoUtilMethod.h"
#import "Reachability.h"
#import "SVProgressHUD.h"

@implementation GoUtilMethod


/**
 *判断当前网络环境
 */
+ (void)setButtonTextImageCenterWithButton:(UIButton *)btn
{
    // the space between the image and text
    CGFloat spacing = 6.0;
    
    // get the size of the elements here for readability
    CGSize imageSize = btn.imageView.frame.size;
    CGSize titleSize = btn.titleLabel.frame.size;
    
    // lower the text and push it left to center it
    btn.titleEdgeInsets = UIEdgeInsetsMake( 0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    
    // the text width might have changed (in case it was shortened before due to
    // lack of space and isn't anymore now), so we get the frame size again
    titleSize = btn.titleLabel.frame.size;
    
    // raise the image and push it right to center it
    btn.imageEdgeInsets = UIEdgeInsetsMake( - (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
}


/**
 *判断当前网络环境
 */
+(int)existNetWork
{
//    Reachability *r = [Reachability reachabilityWithHostName:@"http://42.96.192.186/gogou/common/app_interface_test/index.html#product/category/retrieve_list"];
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    if([r currentReachabilityStatus] == NotReachable){
        //   NSLog(@"没有网络");
        [SVProgressHUD showErrorWithStatus:@"当前无网络"];
        return 0;
    }else if([r currentReachabilityStatus] == ReachableViaWWAN){
        //   NSLog(@"正在使用3G网络");
        return 1;
    }else if([r currentReachabilityStatus] == ReachableViaWiFi){
        //  NSLog(@"正在使用wifi网络");
        
        return 1;
    }
    
    return NO;
}

+(BOOL)isLogin
{
    if([[GoUtilMethod getTelephone] isEqualToString:@""] || [GoUtilMethod getTelephone] == nil){
        return NO;
    }else{
        return YES;
    }
}


/**
 *正则验证手机号码格式是否正确
 */
+(BOOL)isPhoneNum:(NSString *)str
{
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:str];
}


/**
 *寻找文件路径
 */
+(NSString *)dataFilePath
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask , YES);
    NSString *documentDirectory =[path objectAtIndex:0];
    return  [documentDirectory stringByAppendingPathComponent:@"customer.plist"];
}

/**
 *读取列表
 */
+(NSMutableDictionary *)readPlist
{
    NSString *filePath = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSMutableDictionary *tableDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        return tableDictionary;
    } else {
        NSMutableDictionary *pollHistory = [[NSMutableDictionary alloc] init];
        return pollHistory;
    }
}

/**
 *写入参数
 */
+(void)writeDataToPlist:(NSString *)key value:(NSString *)value;
{
    
    NSString *filePath= [self dataFilePath];
    
    NSMutableDictionary *history = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSMutableDictionary *tableDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        history = tableDictionary;
    } else {
        NSMutableDictionary *pollHistory = [[NSMutableDictionary alloc] init];
        history = pollHistory;
    }
    
    if (((![key isKindOfClass:[NSNull class]]) && ![key isEqualToString:@""] && key != nil)&&((![value isKindOfClass:[NSNull class]]) && ![value isEqualToString:@""] && value != nil)) {
        [history setValue:value forKey:key];
    }
    [history writeToFile:filePath atomically:YES];
    
}


/**
 *同时写入多个参数
 */
+(void)writePlist:(NSString *)telephone  password:(NSString *)password userType:(NSString *)userType image:(NSString *)image nickname:(NSString *)nickname
{
    NSMutableDictionary *history = [self readPlist];
    
    if (![telephone isKindOfClass:[NSNull class]] && telephone != nil){
        [history setValue:telephone    forKey:@"telephone"];
    }
    
    if (![password isKindOfClass:[NSNull class]] && password != nil){
        [history setValue:password       forKey:@"password"];
    }
    
    if (![userType isKindOfClass:[NSNull class]] && userType != nil){
        [history setValue:userType       forKey:@"usertype"];
    }
    
    if (![image isKindOfClass:[NSNull class]] && image != nil){
        [history setValue:image       forKey:@"image"];
    }
    
    if (![nickname isKindOfClass:[NSNull class]] && nickname != nil){
        [history setValue:nickname       forKey:@"nickname"];
    }
    
    [history writeToFile:[self dataFilePath] atomically:YES];
}


/**
 *得到用户类型
 */
+(NSString *)getUserType
{
    NSMutableDictionary *history = [self readPlist];
    return [history objectForKey:@"usertype"];
}

/**
 *得到电话号
 */
+(NSString *)getTelephone
{
    NSMutableDictionary *history = [self readPlist];
    return [history objectForKey:@"telephone"];
}

/**
 *设置电话号
 */
+(void)setTelephone:(NSString *)telephone
{
    NSMutableDictionary *history = [self readPlist];
    
    if (![telephone isKindOfClass:[NSNull class]] && telephone != nil){
        [history setValue:telephone    forKey:@"telephone"];
    }
    
    [history writeToFile:[self dataFilePath] atomically:YES];
}

/**
 *得到密码
 */
+(NSString *)getPassword
{
    NSMutableDictionary *history = [self readPlist];
    return [history objectForKey:@"password"];
}

/**
 *设置密码
 */
+(void)setPassword:(NSString *)password
{
    NSMutableDictionary *history = [self readPlist];
    
    if (![password isKindOfClass:[NSNull class]] && password != nil){
        [history setValue:password       forKey:@"password"];
    }
    
    [history writeToFile:[self dataFilePath] atomically:YES];
}

/**
 *得到图片路径
 */
+(NSString *)getImagePath
{
    NSMutableDictionary *history = [self readPlist];
    return [history objectForKey:@"image"];
}


/**
 *设置图片路径
 */
+(void)setImage:(NSString *)image
{
    NSMutableDictionary *history = [self readPlist];
    
    if (![image isKindOfClass:[NSNull class]] && image != nil){
        [history setValue:image       forKey:@"image"];
    }
    
    [history writeToFile:[self dataFilePath] atomically:YES];
}

/**
 *得到昵称
 */
+(NSString *)getNickName
{
    NSMutableDictionary *history = [self readPlist];
    return [history objectForKey:@"nickname"];
}

/**
 *设置昵称
 */
+(void)setNickName:(NSString *)nickName
{
    NSMutableDictionary *history = [self readPlist];
    
    if (![nickName isKindOfClass:[NSNull class]] && nickName != nil){
        [history setValue:nickName       forKey:@"nickname"];
    }
    
    [history writeToFile:[self dataFilePath] atomically:YES];
}

/**
 *得到地址信息
 */
+(NSString *)getMarkets
{
    NSMutableDictionary *history = [self readPlist];
    return [history objectForKey:@"markets"];
}

/**
 *设置地址信息
 */
+(void)setMarkets:(NSString *)markets
{
    NSMutableDictionary *history = [self readPlist];
    
    if (![markets isKindOfClass:[NSNull class]] && markets != nil){
        [history setValue:markets       forKey:@"markets"];
    }
    
    [history writeToFile:[self dataFilePath] atomically:YES];
}


+(void)clearMessage
{
    [self writePlist:@"" password:@"" userType:@"" image:@"" nickname:@""];
}


@end
