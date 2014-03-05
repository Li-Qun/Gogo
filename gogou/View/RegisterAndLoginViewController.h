//
//  RegisterAndLoginViewController.h
//  goshopping
//
//  Created by ss4346 on 13-11-11.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <Parse/Parse.h>

#import "GoBaseViewController.h"

@interface RegisterAndLoginViewController : GoBaseViewController
{
    
    UIButton *registerSelected;
    UIButton *loginSelected;
    
    //login
    UIView *registerView;
    UITextField *lPhone;
    UITextField *lPassword;
    UIButton *login;
    
    UIButton *tecentBtn;
    UIButton *sinaBtn;

    //register
    UIView *loginView;
    UITextField *rPhone;
    UITextField *rPassword;
    UIButton *registerBtn;
}

@end
