//
//  ChartsView.h
//  Charts
//
//  Created by JJS-iMac on 15/7/14.
//  Copyright (c) 2015年 JJS-iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineChartDataSet.h"
#import "ChartData.h"
#import "CircleView.h"
#import "LineLayer.h"
#import "TextView.h"

#define Define_TitleHeight 50
#define Define_ChartsHeight 340
#define Define_CircleDiameter 30
#define Define_X_Y_LableWidth 45
#define Define_Interval 130

typedef void(^SelectIndex)(NSInteger index,CircleView *circleView);

@interface ChartsView : UIView

@property (nonatomic,strong) UIScrollView *chartScrollView;

/**
 *  x方向间隔
 */
@property (nonatomic,assign) float interval;
/**
 *  x方向，最大间距 default is 200
 */
@property (nonatomic,assign) float maxInterval;
/**
 *  x方向，最小间距 default is 40
 */
@property (nonatomic,assign) float minInterval;


/**
 *  Y方向字体，X方向字体，价格字体，说明字体
 */
@property (nonatomic,strong) UIFont *yLabelFont, *xLabelFont, *valueLabelFont, *legendFont;

/**
 *  ChartData Array
 */
@property (nonatomic,strong) NSMutableArray *chartDataArray;

/**
 *  线的颜色
 */
@property (nonatomic,strong)UIColor *priceLineColor;

@property (nonatomic,strong)UIColor *countLineColor;

/**
 *  线上字体颜色
 */

@property (nonatomic,strong)UIColor *priceTextColor;

@property (nonatomic,strong)UIColor *countTextColor;

/**
 *  选择后回调block，注意循环引用，慎用
 */
@property (nonatomic,strong) SelectIndex selectIndexblock;

@end
