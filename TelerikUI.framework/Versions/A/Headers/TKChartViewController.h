//
//  TKChartViewController.h
//  TelerikUI
//
//  Copyright (c) 2013 Telerik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKChart.h"

@interface TKChartViewController : UIViewController<TKChartDataSource, TKChartDelegate>

@property (nonatomic, retain) TKChart *chart;

@end
