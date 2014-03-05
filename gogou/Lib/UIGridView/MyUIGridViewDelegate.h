//
//  UIGridViewDelegate.h
//  foodling2
//
//  Created by Tanin Na Nakorn on 3/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyUIGridViewDelegate


@optional
- (void) gridView:(MyUIGridView *)grid didSelectRowAt:(int)rowIndex AndColumnAt:(int)columnIndex;


@required
- (CGFloat) gridView:(MyUIGridView *)grid widthForColumnAt:(int)columnIndex;
- (CGFloat) gridView:(MyUIGridView *)grid heightForRowAt:(int)rowIndex;

- (NSInteger) numberOfColumnsOfGridView:(MyUIGridView *) grid;
- (NSInteger) numberOfCellsOfGridView:(MyUIGridView *) grid;

- (MyUIGridViewCell *) gridView:(MyUIGridView *)grid cellForRowAt:(int)rowIndex AndColumnAt:(int)columnIndex;

@end

