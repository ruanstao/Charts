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

#define Define_TitleHeight 48
#define Define_ChartsHeight 217
#define Define_CircleDiameter 30
#define Define_X_Y_LableWidth 45
#define Define_Interval 130
#define Define_X_PushOff 50

#define mChartsRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

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
 *  ChartData 数组
 */
@property (nonatomic,strong) NSMutableArray *chartDataArray;

/**
 *  线的颜色
 */
@property (nonatomic,strong)UIColor *priceLineColor;

@property (nonatomic,strong)UIColor *countLineColor;

/**
 *  线上文本框字体颜色
 */

@property (nonatomic,strong)UIColor *priceTextColor;

@property (nonatomic,strong)UIColor *countTextColor;

/**
 *  选择后回调block，注意循环引用，慎用
 */
@property (nonatomic,strong) SelectIndex selectIndexblock;

/**
 *  文字提示框背景图片
 */
@property (nonatomic,strong) UIImage *textViewBackgroundImage;

@end
