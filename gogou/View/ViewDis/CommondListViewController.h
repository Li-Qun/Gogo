//
//  CommondListViewController.h
//  gogou
//
//  Created by ss4346 on 13-12-16.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommondCell.h"
#import "GoBaseViewController.h"
#import "PullingRefreshTableView.h"

@interface CommondListViewController : GoBaseViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,PullingRefreshTableViewDelegate>{
    
    PullingRefreshTableView *mainView;
    
    NSMutableArray *commendArray;
    
    int currentPage;
    
    int totalPage;
}

@property (strong,nonatomic) NSString *productID;

@end
