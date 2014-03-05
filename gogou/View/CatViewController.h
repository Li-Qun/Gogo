//
//  CatViewController.h
//  goshopping
//
//  Created by ss4346 on 13-11-13.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyUIGridView.h"
#import "GoColorValue.h"
#import "MyUIGridViewDelegate.h"

@interface CatViewController : GoBaseViewController<MyUIGridViewDelegate,UIScrollViewDelegate,UITextFieldDelegate>
{
    UIScrollView *mainView;
    
    UITextField *searchField;
    
    MyUIGridView *collectionView;
    
    NSMutableArray *catList;
    
    BOOL isAnimating;

}

@end
