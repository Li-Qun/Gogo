//
//  WishProductViewController.m
//  goshopping
//
//  Created by ss4346 on 13-11-15.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import "WishProductViewController.h"
#import "WishProductCell.h"

@interface WishProductViewController ()

@end

@implementation WishProductViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self addSubView];
    
    //数据初始化
    totalArray = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
//    [self createNavigationItem];
    [self getData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
    CGRect frame = self.view.frame;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        frame.origin.y = 20;
        frame.size.height = self.view.frame.size.height - 20;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        
    } else {
        
        frame.origin.x = 0;
        
    }
    
    self.view.frame = frame;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark custom method

- (void)backToPreviousView
{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil]; 
}

- (void)refresh
{
    [self getData];
}


- (void)delFav:(id)sender
{
    //判断当前是否有网络
    if ([GoUtilMethod existNetWork] == 0) {
        return;
    };
    
    UIButton *senderButton = (UIButton *)sender;
    
    [SVProgressHUD show];
    NSURL *url = [[NSURL alloc] initWithString:USER_FAVOVITE_DELETE];
    
    DataInfo *infor = [totalArray objectAtIndex:senderButton.tag];
    
    __weak  ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    
    NSLog(@"product id %@",infor.productId);
    
    [request setPostValue:[GoUtilMethod getTelephone]       forKey:TELEPHONE ];
    [request setPostValue:[GoUtilMethod getPassword]        forKey:PASSWORD];
    [request setPostValue:[GoUtilMethod getUserType]        forKey:ACCOUNT_TYPE];
    [request setPostValue:infor.productId                   forKey:CONTENT_ID];
    [request setPostValue:@"2"                              forKey:CONTENT_TYPE];
    [request setPostValue:nil                               forKey:CONTENT_EXTRA];
    
    [request setCompletionBlock:^{
        
        [SVProgressHUD dismiss];
        NSString *jsonString = [request responseString];
        SBJsonParser *parser =[[SBJsonParser alloc] init];
        
        NSDictionary *dictionary = [parser objectWithString:jsonString];
        
        int state = [[dictionary objectForKey:@"state"] intValue];
        NSString *text = [dictionary objectForKey:@"message"];
        
        if (state ==1) {
            [SVProgressHUD showSuccessWithStatus:text duration:3];
        }else{
            [SVProgressHUD showErrorWithStatus:text duration:3];
        }
        
        [self getData];
        NSLog(@" >>>  %@",jsonString);
        
    }];
    [request setFailedBlock:^{
        [SVProgressHUD dismiss];
        NSString *responseString = [request responseString];
        NSLog(@">>>>>>%@",responseString);
    }];
    
    [request startAsynchronous];
}

- (void)getData
{
    //判断当前是否有网络
    if ([GoUtilMethod existNetWork] == 0) {
        return;
    };
    
    [SVProgressHUD show];
    NSURL *url = [[NSURL alloc] initWithString:USER_FOLLOW_RETRIEVE_LIST];
    
    __weak  ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    
    [request setPostValue:[GoUtilMethod getTelephone]       forKey:TELEPHONE ];
    [request setPostValue:[GoUtilMethod getPassword]        forKey:PASSWORD];
    [request setPostValue:[GoUtilMethod getUserType]        forKey:ACCOUNT_TYPE];
    [request setPostValue:@"2"                              forKey:CONTENT_TYPE];
    
    [request setCompletionBlock:^{
        
        [SVProgressHUD dismiss];
        NSString *jsonString = [request responseString];
        SBJsonParser *parser =[[SBJsonParser alloc] init];
        NSArray *array = [parser objectWithString:jsonString];
        
        [totalArray removeAllObjects];
        for (int i = 0; i < array.count; i ++) {
            NSDictionary *data = array[i];
            DataInfo *infor = [[DataInfo alloc] init];
            infor.productId      = [data objectForKey:@"product_id"];
            infor.marketId       = [data objectForKey:@"market_id"];
            infor.manufacturerId = [data objectForKey:@"manufacturer_id"];
            infor.name           = [data objectForKey:@"name"];
            infor.description    = [data objectForKey:@"description"];
            infor.price          = [data objectForKey:@"price"];
            infor.image          = [data objectForKey:@"image"];
            infor.reviewCount    = [data objectForKey:@"review_count"];
            infor.favCount       = [data objectForKey:@"fav_count"];
            [totalArray addObject:infor];
            infor = nil;
        }
        
        [myTableView reloadData];
        NSLog(@" >>>  %@",jsonString);
        
        
        NSLog(@" >>>  %@",jsonString);
        
    }];
    [request setFailedBlock:^{
        [SVProgressHUD dismiss];
        NSString *responseString = [request responseString];
        NSLog(@">>>>>>%@",responseString);
    }];
    
    [request startAsynchronous];
}

#pragma -mark tableview datasource delgate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return totalArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"wishProductCell";
    
    WishProductCell *cell = (WishProductCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WishProductCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    DataInfo *infor = [totalArray objectAtIndex:indexPath.row];
    
    NSString *imageUrl = infor.image;
    if (![imageUrl isEqualToString:@""]) {
        NSURL *url = [NSURL URLWithString:BASE_IMAGE(imageUrl)];
        [cell.headImage setImageURL:url];
    }else{
        [cell.headImage setImage:[UIImage imageNamed:@"moren"]];
    }
    
    cell.titelLabel.text = infor.description;
    cell.userLabel.text = infor.name;
    [cell.delBtn setTitle:@"删除收藏" forState:UIControlStateNormal];
    [cell.delBtn addTarget:self action:@selector(delFav:) forControlEvents:UIControlEventTouchUpInside];
    cell.delBtn.tag = indexPath.row;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductDetailController *view = [[ProductDetailController alloc] init];
    view.infor = [totalArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:view animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    return indexPath;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 91;
}

#pragma -mark main view
- (void)addSubView
{
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"title_wish_product"]];
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, BOTTOM_BAR_HEIGHT+4)];
    myTableView.backgroundColor = [UIColor whiteColor];
    myTableView.dataSource = self;
    myTableView.delegate   = self;
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, BOTTOM_BAR_HEIGHT+4, 320, 45)];
    bottomView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"prodetail_bottom_bg"]];
    
    backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 9, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"back_bottom"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToPreviousView) forControlEvents:UIControlEventTouchUpInside];
    
    refreshBtn = [[UIButton alloc] initWithFrame:CGRectMake(280, 9, 30, 30)];
    [refreshBtn setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:titleView];
    [self.view addSubview:myTableView];
    [bottomView addSubview:backBtn];
    [bottomView addSubview:refreshBtn];
    [self.view addSubview:bottomView];
}

- (void)createNavigationItem
{
    self.navigationController.navigationBarHidden = NO;
}

@end
