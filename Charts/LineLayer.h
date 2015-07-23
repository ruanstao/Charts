//
//  LineLayer.h
//  Charts
//
//  Created by RuanSTao on 15/7/17.
//  Copyright (c) 2015年 JJS-iMac. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LineChartDataSet.h"
@interface LineLayer : CAShapeLayer

@property (nonatomic,assign) float lineInterval;

- (void) initWithSet:(LineChartDataSet *)lineSet;

@property (nonatomic,assign) NSInteger tag;

@end
