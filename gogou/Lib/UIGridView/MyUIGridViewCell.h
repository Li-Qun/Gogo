//
//  UIGridViewCell.h
//  foodling2
//
//  Created by Tanin Na Nakorn on 3/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyUIGridViewCell : UIButton {

}

@property int rowIndex;
@property int colIndex;
@property (nonatomic, retain) IBOutlet UIView *view;

@end
