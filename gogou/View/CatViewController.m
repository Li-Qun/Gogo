//
//  CatViewController.m
//  goshopping
//
//  Created by ss4346 on 13-11-13.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import "CatViewController.h"
#import "CatCell.h"
#import "ProductListViewController.h"

#define anim_time 0.5
#define scroll_height 45

@interface CatViewController ()

@end

@implementation CatViewController

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

    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(upSwipeHandle:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionUp;
    
    //    recognizer
    [self.view addGestureRecognizer:recognizer];
    [self mainView];
    
    catList = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setTabBarNavigationBarTitleWithImage:[UIImage imageNamed:@"title_bg_logo"]];
    [self hideLeftBtn];
    [self getCatList];
}

- (void)viewDidAppear:(BOOL)animated
{
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma -mark
#pragma custom method
- (void)getCatList
{
    //清除数据
    [catList removeAllObjects];
    
    //判断当前是否有网络
    if ([GoUtilMethod existNetWork] == 0) {
        return;
    };
    
    [SVProgressHUD show];
    NSURL *url = [[NSURL alloc] initWithString:CATEGORY];
    __weak  ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    
    [request setCompletionBlock:^{
        [SVProgressHUD dismiss];
        SBJsonParser *parser =[[SBJsonParser alloc] init];
        NSArray *array = [parser objectWithString:[request responseString]];
        
        for (int i = 0; i < array.count; i++) {
            [catList addObject:array[i]];
        }
        [collectionView reloadData];
    }];
    
    [request setFailedBlock:^{
        [SVProgressHUD dismiss];
        NSString *responseString = [request responseString];
        NSLog(@">>>>>>%@",responseString);
    }];
    
    [request startAsynchronous];
}

- (void)searchAction
{
    
}

#pragma -mark
#pragma UICollectionView deleagte
- (CGFloat) gridView:(MyUIGridView *)grid widthForColumnAt:(int)columnIndex
{
	return 110;
}

- (CGFloat) gridView:(MyUIGridView *)grid heightForRowAt:(int)rowIndex
{
	return 145;
}

- (NSInteger) numberOfColumnsOfGridView:(MyUIGridView *) grid
{
	return 3;
}


- (NSInteger) numberOfCellsOfGridView:(MyUIGridView *) grid
{
	
    return catList.count;
}

- (MyUIGridViewCell *) gridView:(MyUIGridView *)grid cellForRowAt:(int)rowIndex AndColumnAt:(int)columnIndex
{
	CatCell *cell = (CatCell *)[grid dequeueReusableCell];
	
	if (cell == nil) {
		cell = [[CatCell alloc] init];
	}
    NSDictionary *dictionary = [catList objectAtIndex:rowIndex*3+columnIndex];
	
    NSURL *url = [[NSURL alloc] initWithString:BASE_IMAGE([dictionary objectForKey:@"image"])];
    
    [cell.thumbnail setImageURL:url];
    cell.label.text = [dictionary objectForKey:@"name"];
    
	return cell;
}

- (void) gridView:(MyUIGridView *)grid didSelectRowAt:(int)rowIndex AndColumnAt:(int)colIndex
{
    int index = rowIndex*3 +colIndex;
    NSLog(@"index >>>>   %d",index);
    ProductListViewController *view = [[ProductListViewController alloc] init];
    view.filterCategoryId = [NSString stringWithFormat:@"%d",rowIndex*3+colIndex+1];
    [self.navigationController pushViewController:view animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma -mark
#pragma main view
- (void)mainView
{
    mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, VIEW_HEIGHT)];
    mainView.delegate = self;
    mainView.showsVerticalScrollIndicator = NO;
    [mainView setContentSize:CGSizeMake(320, 500)];
    [mainView setBackgroundColor:GO_BACKGROUND];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"searchbar_bg"]];
    
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(7, 11, 38, 28)];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"searchbtn"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    
    searchField = [[UITextField alloc] initWithFrame:CGRectMake(45, 11, 268, 28)];
    searchField.contentVerticalAlignment =UIControlContentVerticalAlignmentCenter;
    searchField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"searchbar"]];
    searchField.placeholder = @"搜索";
    searchField.delegate = self;
    
    collectionView = [[MyUIGridView alloc] initWithFrame:CGRectMake(0, 50, 320, VIEW_HEIGHT-50)];
    collectionView.uiGridViewDelegate = self;
    collectionView.backgroundColor = [UIColor clearColor];
    
    [view addSubview:searchBtn];
    [view addSubview:searchField];
    [mainView addSubview:view];
    [mainView addSubview:collectionView];
    [self.view addSubview:mainView];
}


#pragma mark - 手势处理
-(void) upSwipeHandle:(UISwipeGestureRecognizer *) recognizer{
    
    if (recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        
        [mainView setContentOffset:CGPointMake(0, scroll_height) animated:YES];
        isAnimating = YES;
        [self performSelector:@selector(endAnimation:) withObject:nil afterDelay:anim_time];
        [self performSelector:@selector(delayContentInsets) withObject:nil afterDelay:anim_time];
    }
}

-(void) delayContentInsets{
    [mainView setContentInset:UIEdgeInsetsMake(-scroll_height, 0, 0, 0)];
    [mainView setScrollEnabled:YES];
}

#pragma mark - scroll
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat currentPosition = scrollView.contentOffset.y;
    
    //    CGFloat height = 100;//顶部区域高度
    CGFloat height_5 = scroll_height/2;//半高
    
    if (isAnimating) {
        return;
    }
    
    //收起
    if (currentPosition > height_5 && currentPosition < scroll_height) {
        //        if (!scrollView.isDragging) {
        //            [self hideView];
        //        }
    } else if (currentPosition >= scroll_height) {
        [scrollView setContentInset:UIEdgeInsetsMake(-scroll_height, 0, 0, 0)];
    } else if (currentPosition <= height_5){//放下
        if (!scrollView.isDragging) {
            [self showView];
        }
    }
    
    
}


-(void) showView{
    //    hidden = YES;
    
    isAnimating = YES;
    [self performSelector:@selector(endAnimation:) withObject:nil afterDelay:anim_time];
    [self performSelector:@selector(dalayScrollNot) withObject:nil afterDelay:anim_time];
    [mainView setContentOffset:CGPointMake(0, 0) animated:YES];
    [mainView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
}

-(void) dalayScrollNot{
    [mainView setScrollEnabled:NO];
}

-(void) hideView{
    //    hidden = NO;
    isAnimating = YES;
    [self performSelector:@selector(endAnimation:) withObject:nil afterDelay:anim_time];
    
    [mainView setContentOffset:CGPointMake(0, scroll_height) animated:YES];
    [UIView animateWithDuration:anim_time animations:^(void){
        
        
    } completion:^(BOOL finished){
        [mainView setContentInset:UIEdgeInsetsMake(-scroll_height, 0, 0, 0)];
    }];
    
    //    [_scrollView setContentOffset:CGPointMake(0, height) animated:YES];
    //    [_scrollView setContentInset:UIEdgeInsetsMake(-100, 0, 0, 0)];
    //    [self performSelector:@selector(contentSize11) withObject:nil afterDelay:anim_time];
    
    //    [self performSelector:@selector(seting:) withObject:[NSNumber numberWithFloat:-] afterDelay:anim_time];
    
}


-(void)endAnimation:(id)sender {
    
    @synchronized(self){
        isAnimating = NO;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

// It is important for you to hide kwyboard

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    ProductListViewController *view = [[ProductListViewController alloc] init];
    view.filterName = searchField.text;
    [self.navigationController pushViewController:view animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    return YES;
}


@end
