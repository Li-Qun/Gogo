//
//  GoBaseViewController.h
//  goshopping
//
//  Created by ss4346 on 13-11-12.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GoHttpURL.h"
#import "GoUtilMethod.h"
#import "SBJsonParser.h"
#import "SVProgressHUD.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface GoBaseViewController : UIViewController

- (void)setNavigationBarTitleWithImage:(UIImage *)image;
- (void)setTabBarNavigationBarTitleWithImage:(UIImage *)image;
- (void)hideLeftBtn;

@end
