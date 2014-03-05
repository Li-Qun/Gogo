//
//  ShopViewController.h
//  goshopping
//
//  Created by ss4346 on 13-12-2.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoBaseViewController.h"
#import "DataInfo.h"
#import "EGOImageView.h"
#import "ProductListViewController.h"

@interface ShopViewController : GoBaseViewController{

    UIScrollView *mainScrollView;
    UILabel *titleLabel;
    UILabel *typeLabel;
    EGOImageView *imageHead;
    UIView *viewMap;
    UIView *viewTel;
    UITextView *contentTextView;
    
    UIButton *addFav;
    UIButton *btnViewAll;
    UIButton *btnViewNew;
    
    NSDictionary *commonDictionary;
    
}

@property (strong,nonatomic) DataInfo *infor;


@end
