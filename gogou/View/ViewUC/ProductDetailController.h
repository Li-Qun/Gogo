//
//  ProductDetailController.h
//  goshopping
//
//  Created by ss4346 on 13-11-18.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StrikeThroughLabel.h"
#import "DataInfo.h"
#import "EGOImageView.h"

@interface ProductDetailController : GoBaseViewController{
    
    EGOImageView *headBg;
    
    UILabel *favors;
    
    UITextView *contentText;
    
    StrikeThroughLabel *productPrice;
    
    UILabel *lowerPrice;
    
    UIButton *addComments;
    
    UIButton *detail;
    
    UIButton *addfavorite;
    
    UIButton *share;
    
    UIButton *addAttenion;
    
    UIButton *toShop;
}

@property (strong,nonatomic) DataInfo *infor;

@end
