//
//  ReProductViewController.h
//  gogou
//
//  Created by ss4346 on 13-12-15.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "AOTwoWaterView.h"
#import "GoBaseViewController.h"

@interface ProductListViewController : GoBaseViewController<EGORefreshTableDelegate,AOTwoWaterViewDelegate,UIScrollViewDelegate>{
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

//传递数据

@property(nonatomic,strong)NSString *filterCategoryId;

@property(nonatomic,strong)NSString *filterName;

@property(nonatomic,strong)NSString *filterMarketId;

@property(nonatomic,strong)NSString *filterManufacturerId;

@end
