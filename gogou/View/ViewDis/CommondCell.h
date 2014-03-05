//
//  CommondCell.h
//  gogou
//
//  Created by ss4346 on 13-12-16.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface CommondCell : UITableViewCell

@property (strong,nonatomic) IBOutlet EGOImageView *headImage;

@property (strong,nonatomic) IBOutlet UILabel *titleLabel;

@property (strong,nonatomic) IBOutlet UILabel *commendLabel;

@property (strong,nonatomic) IBOutlet UILabel *shopLabel;

@end
