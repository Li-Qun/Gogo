//
//  RecommendCell.m
//  gogou
//
//  Created by ss4346 on 13-12-14.
//  Copyright (c) 2013年 huiztech. All rights reserved.
//

#import "RecommendCell.h"

@implementation RecommendCell

@synthesize imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:@"recommendCell"];
    self.frame = CGRectMake(0, 0, 290, 145);
    if (self) {
        // Initialization code
        
        imageView = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 5, self.frame.size.width -10, self.frame.size.height-10)];
        
        [self addSubview:imageView];
        
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_selected_color.png"]];
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
