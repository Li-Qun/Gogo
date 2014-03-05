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

static CGFloat kTransitionDuration = 0.45f;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rect = self.view.bounds;
    rect.size.height -= (self.navigationController.navigationBar.frame.size.height +
                         self.tabBarController.tabBar.frame.size.height);
    _mapView = [[BMKMapView alloc] initWithFrame:rect];
    _mapView.zoomLevel = 16;
    [self.view addSubview:_mapView];
    _mapView.delegate = self;
    
    _search = [[BMKSearch alloc] init];
	_search.delegate = self;
	
	bubbleView = [[KYBubbleView alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
    //bubbleView.center = _mapView.center;
    //[_mapView addSubview:bubbleView];
    bubbleView.hidden = YES;
	
    dataArray = [[NSMutableArray alloc] initWithCapacity:10];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    _mapView.showsUserLocation = YES;
    selectedAV = nil;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self cleanMap];
	[dataArray removeAllObjects];
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)changeBubblePosition {
    if (selectedAV) {
        CGRect rect = selectedAV.frame;
        CGPoint center;
        center.x = rect.origin.x + rect.size.width/2;
        center.y = rect.origin.y - bubbleView.frame.size.height/2 + 8;
        bubbleView.center = center;
    }
}

#ifdef Debug

#	define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else

#	define DLog(...)

#endif

-(void)cleanMap
{
    [_mapView removeOverlays:_mapView.overlays];
    //[_mapView removeAnnotations:_mapView.annotations];
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
}

#pragma mark - 百度地图

#pragma mark-
#pragma mark 定位委托
//开始定位
- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView{
    
    DLog(@"开始定位");
    
}

//更新坐标

-(void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation{
    
    DLog(@"更新坐标");
    
    //给view中心定位
    BMKCoordinateRegion region;
    region.center.latitude  = userLocation.location.coordinate.latitude;
    region.center.longitude = userLocation.location.coordinate.longitude;
    region.span.latitudeDelta  = 0.02;
    region.span.longitudeDelta = 0.02;
    _mapView.region   = region;
    
    //加个当前坐标的小气泡
    //[_search reverseGeocode:userLocation.location.coordinate];
    _mapView.showsUserLocation = NO;
}

//定位失败

-(void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    
    DLog(@"定位错误%@",error);
    
    [mapView setShowsUserLocation:NO];
    
}

//定位停止
-(void)mapViewDidStopLocatingUser:(BMKMapView *)mapView{
    
    DLog(@"定位停止");
    //添加圆形覆盖
	//BMKCircle* circle = [BMKCircle circleWithCenterCoordinate:mapView.centerCoordinate radius:1000];
	//[mapView addOverlay:circle];
    
    /*
	 BMKPointAnnotation* item = [[BMKPointAnnotation alloc] init];
	 item.coordinate = mapView.centerCoordinate;
	 item.title=@"我的位置";
	 [_mapView addAnnotation:item];
	 [item release];
	 */
    //标记我的位置
    BMKUserLocation *userLocation = mapView.userLocation;
    userLocation.title = @"我的位置";
    [_mapView addAnnotation:userLocation];
	
    //poi检索
    [_search poiSearchNearBy:@"超市" center:_mapView.centerCoordinate radius:1000 pageIndex:0];
}

/*
 //Circle Overlay
 - (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
 {
 if ([overlay isKindOfClass:[BMKCircle class]])
 {
 BMKCircleView* circleView = [[[BMKCircleView alloc] initWithOverlay:overlay] autorelease];
 circleView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:0.4];
 circleView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.4];
 circleView.lineWidth = 2.0;
 return circleView;
 }
 return nil;
 }
 */
#pragma mark POI检索委托
- (void)onGetPoiResult:(NSArray*)poiResultList searchType:(int)type errorCode:(int)error
{
	if (error == BMKErrorOk) {
		BMKPoiResult* result = [poiResultList objectAtIndex:0];
		for (int i = 0; i < result.poiInfoList.count; i++) {
			BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:3];
            [dict setObject:(poi.name == nil) ? @"" : poi.name forKey:@"Name"];
            [dict setObject:(poi.address == nil) ? @"" : poi.address forKey:@"Address"];
            NSString *phone;
            NSString *model = [[UIDevice currentDevice] model];
            if ([model hasPrefix:@"iPhone"] && poi.phone != nil) {
                phone = poi.phone;
            }
            else {
                phone = @"";
            }
            [dict setObject:phone forKey:@"Phone"];
            //[dict setObject:(poi.phone == nil) ? @"" : poi.phone forKey:@"Phone"];
            [dataArray addObject:dict];
            
			KYPointAnnotation* item = [[KYPointAnnotation alloc]init];
            item.tag = i;
			item.coordinate = poi.pt;
			item.title = poi.name;
			[_mapView addAnnotation:item];
            
            
		}
	}
}


#pragma mark 标注
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    DLog(@"生成标注");
    //if ([annotation isKindOfClass:[BMKUserLocation class]]) {
    //    return nil;
    //}
    
    //BMKAnnotationView *annotationView = [mapView viewForAnnotation:annotation];
    BMKPinAnnotationView *annotationView = (BMKPinAnnotationView*)[mapView viewForAnnotation:annotation];
    
    if (annotationView == nil)
    {
        KYPointAnnotation *ann;
        if ([annotation isKindOfClass:[KYPointAnnotation class]]) {
            ann = annotation;
        }
        NSUInteger tag = ann.tag;
        NSString *AnnotationViewID = [NSString stringWithFormat:@"AnnotationView-%i", tag];
        
        /*
		 if ([[annotation title] isEqualToString:@"我的位置"])
		 {
		 annotationView = [[[BMKPinAnnotationView alloc] initWithAnnotation:annotation
		 reuseIdentifier:AnnotationViewID] autorelease];
		 ((BMKPinAnnotationView*) annotationView).pinColor = BMKPinAnnotationColorPurple;
		 annotationView.canShowCallout = TRUE;
		 }
		 else
		 {*/
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation
                                                           reuseIdentifier:AnnotationViewID] ;
        ((BMKPinAnnotationView*) annotationView).pinColor = BMKPinAnnotationColorRed;
        annotationView.canShowCallout = NO;//使用自定义bubble
        //}
        
		((BMKPinAnnotationView*)annotationView).animatesDrop = YES;// 设置该标注点动画显示
        
        
        annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
        annotationView.annotation = annotation;
	}
	return annotationView ;
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    DLog(@"选中标注");
    //CGPoint point = [mapView convertCoordinate:view.annotation.coordinate toPointToView:mapView];
    if ([view isKindOfClass:[BMKPinAnnotationView class]]) {
#ifdef Debug
        CGPoint point = [mapView convertCoordinate:selectedAV.annotation.coordinate toPointToView:selectedAV.superview];
        //CGRect rect = selectedAV.frame;
        DLog(@"annotationPoint:x=%.1f, y=%.1f", point.x, point.y);
#endif
        selectedAV = view;
        if (bubbleView.superview == nil) {
			//bubbleView加在BMKAnnotationView的superview(UIScrollView)上,且令zPosition为1
            [view.superview addSubview:bubbleView];
            bubbleView.layer.zPosition = 1;
        }
        bubbleView.infoDict = [dataArray objectAtIndex:[(KYPointAnnotation*)view.annotation tag]];
        //[self showBubble:YES];先移动地图，完成后再显示气泡
    }
    else {
        selectedAV = nil;
    }
    [mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
}

- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view
{
    DLog(@"取消选中标注");
    if ([view isKindOfClass:[BMKPinAnnotationView class]]) {
        [self showBubble:NO];
    }
}

#pragma mark 区域改变
- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    if (selectedAV) {
#ifdef Debug
        CGPoint point = [mapView convertCoordinate:selectedAV.annotation.coordinate toPointToView:selectedAV.superview];
        //CGRect rect = selectedAV.frame;
        DLog(@"x=%.1f, y= %.1f", point.x, point.y);
#endif
    }
    DLog(@"地图区域即将改变");
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (selectedAV) {
        [self showBubble:YES];
        [self changeBubblePosition];
#ifdef Debug
        CGPoint point = [mapView convertCoordinate:selectedAV.annotation.coordinate toPointToView:selectedAV.superview];
        DLog(@"x=%.1f, y= %.1f", point.x, point.y);
#endif
    }
    DLog(@"地图区域改变完成");
}


#pragma mark show bubble animation
- (void)bounce4AnimationStopped{
    //CGPoint point = [_mapView convertCoordinate:selectedAV.annotation.coordinate toPointToView:selectedAV.superview];
    //DLog(@"annotationPoint4:x=%.1f, y= %.1f", point.x, point.y);
    //[self changeBubblePosition];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kTransitionDuration/6];
	//[UIView setAnimationDelegate:self];
    //[UIView setAnimationDidStopSelector:@selector(bounce5AnimationStopped)];
	bubbleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
	[UIView commitAnimations];
}

- (void)bounce3AnimationStopped{
    //CGPoint point = [_mapView convertCoordinate:selectedAV.annotation.coordinate toPointToView:selectedAV.superview];
    //DLog(@"annotationPoint3:x=%.1f, y= %.1f", point.x, point.y);
    //[self changeBubblePosition];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kTransitionDuration/6];
	[UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce4AnimationStopped)];
	bubbleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.95, 0.95);
	[UIView commitAnimations];
}

- (void)bounce2AnimationStopped{
    //CGPoint point = [_mapView convertCoordinate:selectedAV.annotation.coordinate toPointToView:selectedAV.superview];
    //DLog(@"annotationPoint2:x=%.1f, y= %.1f", point.x, point.y);
    //[self changeBubblePosition];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kTransitionDuration/6];
	[UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce3AnimationStopped)];
	bubbleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.05, 1.05);
	[UIView commitAnimations];
}

- (void)bounce1AnimationStopped{
    //CGPoint point = [_mapView convertCoordinate:selectedAV.annotation.coordinate toPointToView:selectedAV.superview];
    //DLog(@"annotationPoint1:x=%.1f, y= %.1f", point.x, point.y);
    //[self changeBubblePosition];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kTransitionDuration/6];
	[UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
	bubbleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
	[UIView commitAnimations];
}

- (void)showBubble:(BOOL)show {
    if (show) {
        [bubbleView showFromRect:selectedAV.frame];
        /*
		 CGRect rect = bubbleView.frame;
		 CGPoint point = [_mapView convertCoordinate:selectedAV.annotation.coordinate toPointToView:selectedAV.superview];
		 DLog(@"annotationPoint0:x=%.1f, y=%.1f", point.x, point.y);
		 rect.origin.x = point.x;
		 rect.origin.y = point.y - rect.size.height/2;
		 //bubbleView.frame = rect;
		 
		 CGPoint newPosition = [_mapView convertCoordinate:_mapView.centerCoordinate toPointToView:selectedAV.superview];
		 DLog(@"newPosition:x=%.1f, y=%.1f", newPosition.x, newPosition.y);
		 CGPoint center;
		 center.x = newPosition.x;
		 center.y = newPosition.y - selectedAV.frame.size.height - bubbleView.frame.size.height/2 + 8;
		 //bubbleView.center = center;
		 */
        
        bubbleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:kTransitionDuration/3];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
        bubbleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        bubbleView.hidden = NO;
        //bubbleView.center = center;
        [UIView commitAnimations];
        
    }
    else {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:kTransitionDuration/3];
        //[UIView setAnimationDelegate:self];
        //[UIView setAnimationDidStopSelector:@selector(bubbleViewIsRemoved)];
        bubbleView.hidden = YES;
        [UIView commitAnimations];
    }
}

@end
