//
//  RecommendViewController.h
//  goshopping
//
//  Created by ss4346 on 13-11-13.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReListViewController.h"

@interface RecommendViewController : GoBaseViewController<UITableViewDataSource,UITableViewDelegate>{

    UITableView *mainTable;
    
    NSMutableArray *titleArray;
    
    NSMutableArray *totalArray;
}

@property (strong,nonatomic) NSString *jsonString;

@end
