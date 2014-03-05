//
//  UserInforViewController.h
//  goshopping
//
//  Created by ss4346 on 13-11-18.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoBaseViewController.h"

@interface UserInforViewController : GoBaseViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    UIImage *chosenImage;
    
    NSString *tempImagePath;
 
    UITextField *nickName;
    
    UITextField *password;
    
    UITextField *newPassword;
    
    UITextField *reNewPassword;
    
    UIImageView *headImage;
}

@end
