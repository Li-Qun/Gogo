//
//  RecommendCell.h
//  gogou
//
//  Created by ss4346 on 13-12-14.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface RecommendCell : UITableViewCell
{
    EGOImageView *imageView;
}

@property (retain,nonatomic) EGOImageView *imageView;

@end
