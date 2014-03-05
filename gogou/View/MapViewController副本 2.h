//
//  MapViewController.h
//  goshopping
//
//  Created by ss4346 on 13-11-13.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopViewController.h"
#import "KYBubbleView.h"
#import "BMKMapView.h"
#import "BMapKit.h"
#import "DataInfo.h"

@interface MapViewController : GoBaseViewController<BMKMapViewDelegate,BMKSearchDelegate>{

    
    NSMutableArray *totalArray;
    
    BOOL _isSetMapSpan;
    
    BMKMapView* _mapView;
    BMKSearch* _search;
    KYBubbleView *bubbleView;
    BMKAnnotationView *selectedAV;
    NSMutableArray *dataArray;
    
}

@end
