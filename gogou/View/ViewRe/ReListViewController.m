//
//  ReListViewController.m
//  gogou
//
//  Created by ss4346 on 13-12-18.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import "ReListViewController.h"

@interface ReListViewController ()

@end

@implementation ReListViewController

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
	
    //初始化数据
    totalPage = 0;
    currentPage = 1;
    self.totalArray = [[NSMutableArray alloc] init];
    
    self.aoView = [[AOTwoWaterView alloc]initWithDataArray:self.totalArray];
    self.aoView.delegate=self;
    self.aoView.adelegate = self;
    [self.view addSubview:self.aoView];
    [self createHeaderView];
    
    [self refreshView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self createNavigationItem];
    [self setNavigationBarTitleWithImage:[UIImage imageNamed:@"title_bg_logo"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark
#pragma custom method

-(void)refreshList
{
    //判断当前是否有网络
    if ([GoUtilMethod existNetWork] == 0) {
        return;
    };
    
    [self.totalArray removeAllObjects];
    
    [SVProgressHUD show];
    NSURL *url = [[NSURL alloc] initWithString:PROMOTION_RETRIEVE_DETAIL];
    
    __weak  ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:self.promotionId              forKey:PROMOTION_ID];
    [request setPostValue:@"1"                          forKey:PAGE];
    
    [request setCompletionBlock:^{
        [SVProgressHUD dismiss];
        
        NSString *jsonString = [request responseString];
        SBJsonParser *parser =[[SBJsonParser alloc] init];
        NSDictionary *dictionary = [parser objectWithString:jsonString];
        NSMutableArray *array = [dictionary objectForKey:@"res"];
        totalPage = [[dictionary objectForKey:@"total_page"] intValue];
        [self.totalArray removeAllObjects];
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
            
            NSURL *imageUrl  =[NSURL URLWithString:BASE_IMAGE(infor.image)];
            NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
            UIImage *test = [[UIImage alloc] initWithData:imageData];
            
            
            infor.height = test.size.height;
            infor.width  = test.size.width;
            [self.totalArray addObject:infor];
            infor = nil;
            test = nil;
            
        }
        
        if (self.totalArray.count == 0) {
            [SVProgressHUD showErrorWithStatus:@"没有结果"];
        }
        
        [self.aoView refreshView:self.totalArray];
        [self testFinishedLoadData];
        
    }];
    [request setFailedBlock:^{
        [SVProgressHUD dismiss];
    }];
    
    [request startAsynchronous];
}

-(void)getNextPageWithPage:(NSString *)page
{
    //判断当前是否有网络
    if ([GoUtilMethod existNetWork] == 0) {
        return;
    };
    
    [self.totalArray removeAllObjects];
    
    [SVProgressHUD show];
    
    NSURL *url = [[NSURL alloc] initWithString:PROMOTION_RETRIEVE_DETAIL];
    
    __weak  ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:self.promotionId              forKey:PROMOTION_ID];
    [request setPostValue:@"1"                          forKey:PAGE];
    
    [request setCompletionBlock:^{
        [SVProgressHUD dismiss];
        
        NSString *jsonString = [request responseString];
        SBJsonParser *parser =[[SBJsonParser alloc] init];
        NSDictionary *dictionary = [parser objectWithString:jsonString];
        NSMutableArray *array = [dictionary objectForKey:@"res"];
        totalPage = [[dictionary objectForKey:@"total_page"] intValue];
        [self.totalArray removeAllObjects];
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
            
            NSURL *imageUrl  =[NSURL URLWithString:BASE_IMAGE(infor.image)];
            NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
            UIImage *test = [[UIImage alloc] initWithData:imageData];
            
            
            infor.height = test.size.height;
            infor.width  = test.size.width;
            [self.totalArray addObject:infor];
            infor = nil;
            test = nil;
            
        }
        
        if (self.totalArray.count == 0) {
            [SVProgressHUD showErrorWithStatus:@"没有结果"];
        }
        
        [self.aoView getNextPage:self.totalArray];
        [self testFinishedLoadData];
        
    }];
    [request setFailedBlock:^{
        [SVProgressHUD dismiss];
    }];
    
    [request startAsynchronous];
}



-(void)aowClick:(DataInfo *)data
{
    NSLog(@"...testing...  ...testing...");
    NSLog(@" >>>  %@",data.name);
    
    ProductDetailController *view = [[ProductDetailController alloc] init];
    view.infor =data;
    [self.navigationController pushViewController:view animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma -mark
#pragma navigation
- (void)createNavigationItem
{
    self.navigationController.navigationBarHidden = NO;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 50, 25);
    [leftButton setImage:[UIImage imageNamed:@"back_top"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] init];
    [leftItem setCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}


- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma -mark
#pragma methods for imageDelegate


//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
//初始化刷新视图
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#pragma mark
#pragma methods for creating and removing the header view

-(void)createHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
	_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
	[self.aoView addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
}

-(void)removeHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = nil;
}

-(void)setFooterView{
    //    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(self.aoView.contentSize.height, self.aoView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview]) {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              self.aoView.frame.size.width,
                                              self.view.bounds.size.height);
    }else {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self.aoView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [self.aoView addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView refreshLastUpdatedDate];
    }
}

-(void)removeFooterView{
    if (_refreshFooterView && [_refreshFooterView superview]) {
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark-
#pragma mark force to show the refresh headerView
-(void)showRefreshHeader:(BOOL)animated{
	if (animated)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		self.aoView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        // scroll the table view to the top region
        [self.aoView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
        [UIView commitAnimations];
	}
	else
	{
        self.aoView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[self.aoView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
	}
    
    [_refreshHeaderView setState:EGOOPullRefreshLoading];
}
//===============
//刷新delegate
#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass

-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
	
	//  should be calling your tableviews data source model to reload
	_reloading = YES;
    
    if (aRefreshPos == EGORefreshHeader) {
        // pull down to refresh data
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:2.0];
    }else if(aRefreshPos == EGORefreshFooter){
        // pull up to load more data
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:2.0];
    }
    
	// overide, the actual loading data operation is done in the subclass
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
	
	//  model should call this when its done loading
	_reloading = NO;
    
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.aoView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.aoView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
	
	if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
	
	if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}


#pragma mark -
#pragma mark EGORefreshTableDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos{
	
	[self beginToReloadData:aRefreshPos];
	
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}


// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

//刷新调用的方法
-(void)refreshView{
    currentPage = 1;
    [self.totalArray removeAllObjects];
    [self refreshList];
    
}

//加载调用的方法
-(void)getNextPageView{
    [self removeFooterView];
    currentPage++;
    
    if (currentPage <= totalPage) {
        
        [self getNextPageWithPage:[NSString stringWithFormat:@"%d",currentPage]];
        
    }else if(currentPage > totalPage){
        NSLog(@"到底了");
    }
    
}

-(void)testFinishedLoadData{
    
    [self finishReloadingData];
    [self setFooterView];
}

@end

