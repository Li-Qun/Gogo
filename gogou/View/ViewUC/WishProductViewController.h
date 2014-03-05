//
//  WishProductViewController.h
//  goshopping
//
//  Created by ss4346 on 13-11-15.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataInfo.h"
#import "DXAlertView.h"
#import "ProductDetailController.h"


@interface WishProductViewController : GoBaseViewController <UITableViewDataSource,UITableViewDelegate>
{
    UIButton *backBtn;
    
    UIButton *refreshBtn;
    
    UITableView *myTableView;
    
    NSMutableArray *totalArray;
}
@end
