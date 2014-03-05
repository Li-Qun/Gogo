//
//  UIGridView.h
//  foodling2
//
//  Created by Tanin Na Nakorn on 3/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyUIGridViewDelegate;
@class MyUIGridViewCell;

@interface MyUIGridView : UITableView<UITableViewDelegate, UITableViewDataSource> {
	MyUIGridViewCell *tempCell;
}

@property (nonatomic, retain) IBOutlet id<MyUIGridViewDelegate> uiGridViewDelegate;

- (void) setUp;
- (MyUIGridViewCell *) dequeueReusableCell;

- (IBAction) cellPressed:(id) sender;

@end
