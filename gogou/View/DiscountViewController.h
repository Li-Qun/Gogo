//
//  DiscountViewController.h
//  goshopping
//
//  Created by ss4346 on 13-11-13.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "AOTwoWaterView.h"
#import "GoBaseViewController.h"
#import "ProductDetailController.h"

@interface DiscountViewController : GoBaseViewController<AOTwoWaterViewDelegate,EGORefreshTableDelegate,UIScrollViewDelegate>{
    
    //EGOHeader
    EGORefreshTableHeaderView *_refreshHeaderView;
    //EGOFoot
    EGORefreshTableFooterView *_refreshFooterView;
    //
    BOOL _reloading;
    
    int totalPage;
    
    int currentPage;
    
}

@property(nonatomic,strong)AOTwoWaterView *aoView;

@property(nonatomic,strong)NSMutableArray *totalArray;

@end
