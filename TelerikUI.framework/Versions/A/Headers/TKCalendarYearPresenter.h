//
//  TKCalendarYearPresenter.h
//  Telerik UI
//
//  Copyright (c) 2014 Telerik. All rights reserved.
//

#import "TKCalendar.h"

@class TKCalendarYearPresenterStyle;

/**
 @discussion A calendar presenter responsible for rendering TKCalendar in year view mode.
 */
@interface TKCalendarYearPresenter : UIView <TKCalendarPresenter>

/**
 Defines the number of columns.
 */
@property (nonatomic) NSInteger columns;

/**
 Returns the presenter style. Use the style properties to customize the visual appearance of TKCalendar in year view mode.
 */
- (TKCalendarYearPresenterStyle*)style;

/**
 Returns the collection view used by this presenter.
 */
- (UICollectionView*)collectionView;

@end
