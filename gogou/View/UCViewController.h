//
//  UCViewController.h
//  goshopping
//
//  Created by ss4346 on 13-11-13.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface UCViewController : UIViewController
{
    EGOImageView *headImage;
    
    UIButton *wishProductBtn;
    UIButton *iLikedBtn;
    UIButton *wishShopBtn;
    UIButton *leaveMessage;
    UILabel *titleLabel;
}

@end
