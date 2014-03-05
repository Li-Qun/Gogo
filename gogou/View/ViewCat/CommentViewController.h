//
//  CommentViewController.h
//  goshopping
//
//  Created by ss4346 on 13-12-6.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewController : UIViewController{
    
    UIButton *backBtn;
    
    UIButton *confirmBtn;
    
    UITextView *message;
}

@property (strong,nonatomic) NSString *productId;

@end
