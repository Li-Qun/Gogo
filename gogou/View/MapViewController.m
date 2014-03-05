//
//  MapViewController.m
//  goshopping
//
//  Created by ss4346 on 13-11-13.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import "MapViewController.h"
#import "KYPointAnnotation.h"

@interface MapViewController ()
{
    
    BMKAnnotationView* newAnnotation;
}

@end

@implementation MapViewController

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
	// Do any additional setup after loading the view.
    
    [self createMainView];
    
    //获取数据
    _isSetMapSpan = NO;
    totalArray = [[NSMutableArray alloc] init];

    [self getMarkets];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setTabBarNavigationBarTitleWithImage:[UIImage imageNamed:@"title_bg_logo"]];
    [self hideLeftBtn];
    
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)getMarkets
{
    NSString *jsonString = [GoUtilMethod getMarkets];
    SBJsonParser *parser =[[SBJsonParser alloc] init];
    NSMutableArray *array = [parser objectWithString:jsonString];
    
    for (int i=0; i<array.count; i++) {
        NSDictionary *dictionary = [array objectAtIndex:i];
        [totalArray addObject:dictionary];
    
        NSString *str = [dictionary objectForKey:@"geo_point"];
        NSArray *array = [str componentsSeparatedByString:@":"];
        NSLog(@"array >> %@",array);
        
        double latitude = [array[0] doubleValue];
        double longtitude = [array[1] doubleValue];
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude,longtitude);
        
        KYPointAnnotation *pointAnnotation = [[KYPointAnnotation alloc]init];
        pointAnnotation.coordinate = coordinate;

        pointAnnotation.title = [dictionary objectForKey:@"name"];
        pointAnnotation.tag = [[dictionary objectForKey:@"market_id"] intValue];
        [_mapView addAnnotation:pointAnnotation];
        [self setMapRegionWithCoordinate:coordinate];
        
    }
}


#pragma -mark
#pragma custom method
-(void)startLocation
{
    NSLog(@"进入普通定位态");
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层

}


- (void)setMapRegionWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    BMKCoordinateRegion region;
    if (!_isSetMapSpan)//这里用一个变量判断一下,只在第一次锁定显示区域时 设置一下显示范围 Map Region
    {
        region = BMKCoordinateRegionMake(coordinate, BMKCoordinateSpanMake(0.05, 0.05));//越小地图显示越详细
        _isSetMapSpan = YES;
        [_mapView setRegion:region animated:YES];//执行设定显示范围
    }

    [_mapView setCenterCoordinate:coordinate animated:YES];//根据提供的经纬度为中心原点 以动画的形式移动到该区域
}

#pragma -mark
-(void)createMainView
{
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, VIEW_HEIGHT)];
    _mapView.compassPosition = CGPointMake(10,10);
    _mapView.showMapScaleBar = true;
    _mapView.mapScaleBarPosition = CGPointMake(240,280);
//    _mapView.delegate = self;
    
    [self.view addSubview:_mapView];
}


#pragma mark -
#pragma mark implement BMKMapViewDelegate
// 根据 anntation 生成对应的 View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"renameMark";
 
    if (newAnnotation == nil) {
        KYPointAnnotation *ann;
        newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];

        if ([annotation isKindOfClass:[KYPointAnnotation class]]) {
            ann = annotation;
        }
    
        newAnnotation.tag = ann.tag;

    }
    return newAnnotation;
}


- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    NSString *marketId = [NSString stringWithFormat:@"%d",view.tag];
    ShopViewController *shopView = [[ShopViewController alloc] init];
    DataInfo *infor = [[DataInfo alloc] init];
    infor.manufacturerId = marketId;
    infor.marketId = marketId;
    shopView.infor = infor;
    [self.navigationController pushViewController:shopView animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
  
}

@end
