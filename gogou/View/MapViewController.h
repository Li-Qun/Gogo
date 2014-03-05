//
//  MapViewController.h
//  goshopping
//
//  Created by ss4346 on 13-11-13.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopViewController.h"
#import "BMKMapView.h"
#import "BMapKit.h"
#import "DataInfo.h"

@interface MapViewController : GoBaseViewController<BMKMapViewDelegate>{
    
    BMKMapView *_mapView;
    
    NSMutableArray *totalArray;
    
    BOOL _isSetMapSpan;
    
}

@end
