//
//  GoHttpURL.h
//  goshopping
//
//  Created by ss4346 on 13-11-12.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BASE_URL    @"http://115.28.0.20/index.php?route="
// @"http://42.96.192.186/gogou/common/index.php?route="

#define BASE_UPLOAD(path)    [NSString stringWithFormat:@"http://115.28.0.20/upload/%@",path]

//data/xx/.... 的地址，基地址为
#define BASE_IMAGE(path)     [NSString stringWithFormat:@"http://115.28.0.20/image/%@",path]

//【用户】注册
#define REGISTER    [NSString stringWithFormat:@"%@app/customer/customer/register",BASE_URL]

//【用户】登录
#define LOGIN      [NSString stringWithFormat:@"%@app/customer/customer/login",BASE_URL]

//用户】绑定第三方帐户
#define LOGIN_THIRD     [NSString stringWithFormat:@"%@app/customer/customer/binding_third_party_account",BASE_URL]

//【用户】修改
#define EDIT_USER       [NSString stringWithFormat:@"%@app/customer/customer/edit",BASE_URL]

//【用户】查询 - 详细
#define RETRIEVE_DETAIL     [NSString stringWithFormat:@"%@app/customer/customer/retrieve_detail",BASE_URL]

//【用户】留言
#define LEAVE_NOTE     [NSString stringWithFormat:@"%@app/customer/customer/contact",BASE_URL]

//【用户收藏】添加
#define USER_FAVOVITE_ADD    [NSString stringWithFormat:@"%@app/customer/favorite/add",BASE_URL]

//【用户收藏】删除
#define USER_FAVOVITE_DELETE   [NSString stringWithFormat:@"%@app/customer/favorite/delete",BASE_URL]

//【用户收藏】查询 - 列表 - 个人
#define USER_FOLLOW_RETRIEVE_LIST  [NSString stringWithFormat:@"%@app/customer/favorite/retrieve_list",BASE_URL]

//【用户关注】添加
#define USER_ADD_ATTENTION      [NSString stringWithFormat:@"%@app/customer/follow/add",BASE_URL]

//【用户关注】删除
#define USER_DEL_ATTENTION      [NSString stringWithFormat:@"%@app/customer/follow/delete",BASE_URL]

//【用户关注】查询 - 列表 - 个人
#define USER_ALL_ATTENTION     [NSString stringWithFormat:@"%@app/customer/follow/retrieve_list",BASE_URL]
//【商场】查询 - 列表
#define STRORE_RETRIEVE_LIST   [NSString stringWithFormat:@"%@app/market/market/retrieve_list",BASE_URL]
//【商家】查询 - 详细
#define MANUFACTURER_RETRIEVE_DETAIL     [NSString stringWithFormat:@"%@app/manufacturer/retrieve_detail",BASE_URL]
//【商家】查询 - 列表
#define SEARCH_MANUFACTURER    [NSString stringWithFormat:@"%@app/manufacturer/retrieve_list",BASE_URL]



//【商家】查询 - 详细 - 图片
#define MARKET_FLOORS_IMAGES     [NSString stringWithFormat:@"%@app/market/image/retrieve_list",BASE_URL]//

#define CATEGORY      [NSString stringWithFormat:@"%@app/product/category/retrieve_list",BASE_URL]

//【商品】查询 - 列表
#define PRODUCT_LIST    [NSString stringWithFormat:@"%@app/product/product/retrieve_list",BASE_URL]
//【商家】查询 - 详细
#define PRODUCT_DETAIL     [NSString stringWithFormat:@"%@app/manufacturer/retrieve_detail",BASE_URL]//!!!!!!
//【商品图片】查询 - 列表
#define IMAGE_RETRIEVE_LIST     [NSString stringWithFormat:@"%@app/product/image/retrieve_list",BASE_URL]
//【商品评论】添加//http://115.28.0.20/index.php?route=app/product/review/add
#define REVIEW_ADD     [NSString stringWithFormat:@"%@app/product/review/add",BASE_URL]

//【商品评论】查询 - 列表//http://115.28.0.20/index.php?route=app/product/review/retrieve_list
#define REVIEW_RETRIEVE_LIST   [NSString stringWithFormat:@"%@app/product/review/retrieve_list",BASE_URL]
//【优惠活动】查询 - 详细//http://115.28.0.20/index.php?route=app/promotion/retrieve_list
#define PROMOTION_RETRIEVE_LIST      [NSString stringWithFormat:@"%@app/promotion/retrieve_list",BASE_URL]
//【优惠活动】查询 - 详细//http://115.28.0.20/index.php?route=app/promotion/retrieve_detail
#define PROMOTION_RETRIEVE_DETAIL      [NSString stringWithFormat:@"%@app/promotion/retrieve_detail",BASE_URL]


//====================================================================================================================================
//链接参数
//====================================================================================================================================

#define TELEPHONE       @"telephone"
#define PASSWORD        @"password"
#define ACCOUNT_TYPE    @"account_type"
#define FOR_LOGIN       @"for_login"
#define OLD_PASSWORD    @"old_password"
#define NES_PASSWORD    @"new_password"
#define NICKNAME        @"nickname"
#define FILE            @"file"

#define NAME            @"name"
#define EMAIL           @"eamil"
#define QQ              @"qq"
#define ADDRESS         @"address"
#define MESSAGE         @"message"

#define FILTER_MARKET_ID        @"filter_market_id"
#define FILTER_MANUFACTURER_ID  @"filter_manufacturer_id"
#define FILTER_NAME             @"filter_name"
#define FILTER_CATEGORY_ID      @"filter_category_id"
#define FILTER_SPECIAL          @"filter_special"
#define FILTER_SPECIAL_PRO      @"filter_special_pro"
#define PAGE                    @"page"

#define FOR_IS_LOGIN            @"for_is_login"
#define MARKET_ID               @"market_id"
#define MANUFACTURER_ID         @"manufacturer_id"

#define PRODUCT_ID              @"product_id"

#define CONTENT_ID              @"content_id"
#define CONTENT_TYPE            @"content_type"
#define CONTENT_EXTRA           @"content_extra"
#define TEXT                    @"text"

#define PROMOTION_ID               @"promotion_id"

@interface GoHttpURL : NSObject
@end
