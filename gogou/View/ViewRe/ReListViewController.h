//
//  ReListViewController.h
//  gogou
//
//  Created by ss4346 on 13-12-18.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "AOTwoWaterView.h"
#import "GoBaseViewController.h"
#import "ProductDetailController.h"

@interface ReListViewController : GoBaseViewController<EGORefreshTableDelegate,AOTwoWaterViewDelegate,UIScrollViewDelegate>{
    
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

@property (strong,nonatomic) NSString *promotionId;

@property(nonatomic,strong)NSMutableArray *totalArray;

@end
