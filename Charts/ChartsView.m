//
//  ChartsView.m
//  Charts
//
//  Created by JJS-iMac on 15/7/14.
//  Copyright (c) 2015年 JJS-iMac. All rights reserved.
//

#import "ChartsView.h"

#define Tag_LineTag 800
#define Tag_CircleTag 100
#define Tag_TextViewTag 300
#define Tag_PriceLabelTag 400
#define Tag_CountLabelTag 500
#define Tag_DateLabeltag 600
#define Tag_LegendLabelTag 700

@interface ChartsView()
{
    NSInteger _displayPriceList;
    NSInteger _displayCountList;
    NSInteger _oldSelectIndex;
    CAShapeLayer *_matrixLayer;
    CAShapeLayer *_matrixSubLayer;
    CAShapeLayer *_dushLayer;
}
@property (nonatomic,strong) NSMutableArray *lineSetArray;

@end
@implementation ChartsView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeData];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initializeData];
    }
    return self;
}

- (void) initializeData
{
//    self.frame = [[UIScreen mainScreen] applicationFrame];
    self.backgroundColor = [UIColor whiteColor];
    _interval = Define_Interval;
    _minInterval = 40;
    _maxInterval = 200;
    _yLabelFont = [UIFont systemFontOfSize:14];
    _xLabelFont = [UIFont systemFontOfSize:15];
    _valueLabelFont = [UIFont systemFontOfSize:22];
    _legendFont = [UIFont systemFontOfSize:16];
    self.priceLineColor = [UIColor blueColor];
    self.priceTextColor = [UIColor redColor];
    self.countLineColor = [UIColor greenColor];
    self.countTextColor = [UIColor greenColor];
    self.lineSetArray = [[NSMutableArray alloc] init];
    self.chartScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.chartScrollView.showsHorizontalScrollIndicator = NO;
    self.chartScrollView.showsVerticalScrollIndicator = NO;
    NSInteger count = 12;
    self.chartScrollView.contentSize = CGSizeMake(_interval * count, Define_ChartsHeight);
    [self addSubview:self.chartScrollView];
    [self addTitleView];
    
    UIPinchGestureRecognizer * pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
    [self.chartScrollView addGestureRecognizer:pinch];
}

#pragma mark - 捏合手势

- (void)pinchGesture:(UIPinchGestureRecognizer *)recognizer
{
    NSLog(@"%f,%f",recognizer.scale,recognizer.velocity);

    _interval *= recognizer.scale;
    recognizer.scale = 1;
    if (_interval < self.minInterval) {
        _interval = self.minInterval;
    }
    if (_interval > self.maxInterval) {
        _interval = self.maxInterval;
    }
    self.chartScrollView.contentSize = CGSizeMake(_interval * self.chartDataArray.count, Define_ChartsHeight);
    
    [self setNeedsDisplay];
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void) setChartDataArray:(NSMutableArray *)chartDataArray
{
    _chartDataArray = chartDataArray;
    self.chartScrollView.contentSize = CGSizeMake(_interval * chartDataArray.count, Define_ChartsHeight);
    NSMutableArray *pricePointArr = [NSMutableArray array];
    NSMutableArray *countPointArr = [NSMutableArray array];
    NSInteger maxSalePrice = [self maxSalePrice:chartDataArray];
    NSInteger maxSaleCount = [self maxSaleCount:chartDataArray];
    _displayPriceList = [self displayPriceListNumber:maxSalePrice /10000 andDivisor:4];
    _displayCountList = [self displayPriceListNumber:maxSaleCount andDivisor:40];
    [chartDataArray enumerateObjectsUsingBlock:^(ChartData *data, NSUInteger idx, BOOL *stop) {
        NSLog(@"ChartData -- %ld -- %ld %@", data.salePrice,data.saleCount,data.saleMonth);
        CGPoint pricePoint = CGPointMake([[NSNumber numberWithUnsignedInteger:idx] integerValue],1 - (CGFloat)data.salePrice / 10000.0 / (CGFloat)_displayPriceList);
        CGPoint countPoint = CGPointMake(idx,1 - (CGFloat)data.saleCount/ (CGFloat)_displayCountList);
        [pricePointArr addObject:[NSValue valueWithCGPoint:pricePoint]];
        [countPointArr addObject:[NSValue valueWithCGPoint:countPoint]];
    }];
    
    LineChartDataSet *priceLine = [[LineChartDataSet alloc] init];
    priceLine.pointArray = pricePointArr;
    priceLine.lineColor = self.priceLineColor;
    priceLine.circleColor = self.priceLineColor;
    priceLine.circleHoleColor = self.priceLineColor;
    priceLine.textColor = self.priceTextColor;
    priceLine.drawCurveEnabled = YES;
    priceLine.lineType = Line_Price;
    priceLine.isDrawFilledEnabled = NO;
    LineChartDataSet *countLine = [[LineChartDataSet alloc] init];
    countLine.pointArray = countPointArr;
    countLine.lineColor = self.countLineColor;
    countLine.circleColor = self.countLineColor;
    countLine.circleHoleColor = self.countLineColor;
    countLine.textColor = self.countTextColor;
    countLine.drawCurveEnabled = YES;
    countLine.lineType = Line_Count;
    countLine.isDrawFilledEnabled = YES;
    [self.lineSetArray addObject:priceLine];
    [self.lineSetArray addObject:countLine];
}

- (NSInteger)displayPriceListNumber:(NSInteger) maxNumber andDivisor:(NSInteger) divisor
{
    NSInteger minDivisor = divisor;
    while (minDivisor < maxNumber) {
        minDivisor += divisor;
    }
    return minDivisor;
}

#pragma mark 价格最大值

- (NSInteger)maxSalePrice:(NSArray *) dataArr
{
    __block NSInteger maxSalePrice = 0;
    [dataArr enumerateObjectsUsingBlock:^(ChartData * obj, NSUInteger idx, BOOL *stop) {
        if (obj.salePrice > maxSalePrice) {
            maxSalePrice = obj.salePrice;
        }
    }];
    return maxSalePrice;
}

#pragma mark 销售量最大值

- (NSInteger) maxSaleCount:(NSArray *) dataArr
{
    __block NSInteger maxSaleCount = 0;
    [dataArr enumerateObjectsUsingBlock:^(ChartData * obj, NSUInteger idx, BOOL *stop) {
        if (obj.saleCount > maxSaleCount) {
            maxSaleCount = obj.saleCount;
        }
    }];
    return maxSaleCount;
}

#pragma mark 线框
- (void)addTitleView
{
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), Define_TitleHeight)];
    titleView.text = @"价格趋势";
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.adjustsFontSizeToFitWidth = YES;
    [self addSubview:titleView];
}

- (void)addLegendTextLabel
{
    CGFloat y = Define_TitleHeight + Define_ChartsHeight + 35;
    CGFloat x = 25;
    CGFloat lineWidth = 30 , textWidth = 50;
    CGFloat height = 35;
    CGRect salePriceColorFrame = CGRectMake(x, y + height / 2, lineWidth, 2);
    CGRect salePriceLabelFrame = CGRectMake(x + lineWidth + 10, y, textWidth, height);
    CGRect saleCountColorFrame = CGRectMake(CGRectGetMaxX(salePriceLabelFrame) + 30, y + height / 2, lineWidth, 2);
    CGRect saleCountLabelFrame = CGRectMake(CGRectGetMaxX(saleCountColorFrame) + 10, y, textWidth, height);
    UIView *salePriceColor = (UIView *)[self viewWithTag:Tag_LegendLabelTag + 1];
    UILabel *salePriceLabel = (UILabel *)[self viewWithTag:Tag_LegendLabelTag + 2];
    UIView *saleCountColor =  (UIView *)[self viewWithTag:Tag_LegendLabelTag + 3];
    UILabel *saleCountLabel = (UILabel *)[self viewWithTag:Tag_LegendLabelTag + 4];
    if (nil == salePriceColor) {
        salePriceColor = [[UIView alloc] init];
        salePriceColor.tag = Tag_LegendLabelTag +1;
        [self addSubview:salePriceColor];
    }
    if (nil == salePriceLabel) {
        salePriceLabel = [[UILabel alloc] init];
        salePriceLabel.tag = Tag_LegendLabelTag +2;
        [self addSubview:salePriceLabel];
    }
    if (nil == saleCountColor) {
        saleCountColor = [[UIView alloc] init];
        saleCountColor.tag = Tag_LegendLabelTag +3;
        [self addSubview:saleCountColor];
    }
    if (nil == saleCountLabel) {
        saleCountLabel = [[UILabel alloc] init];
        saleCountLabel.tag = Tag_LegendLabelTag +4;
        [self addSubview:saleCountLabel];
    }
    salePriceColor.frame = salePriceColorFrame;
    salePriceLabel.frame = salePriceLabelFrame;
    saleCountColor.frame = saleCountColorFrame;
    saleCountLabel.frame = saleCountLabelFrame;
    
    salePriceColor.layer.cornerRadius = 1;
    saleCountColor.layer.cornerRadius = 1;
    salePriceLabel.font = self.legendFont;
    saleCountLabel.font = self.legendFont;
    salePriceColor.backgroundColor = self.priceLineColor;
    salePriceLabel.text = @"成交价";
    saleCountColor.backgroundColor = self.countLineColor;
    saleCountLabel.text = @"成交量";
}

- (void) addMatrix
{
    [self addMatrixWithYInterval:5 andSubYInterval:4];
    [self addSubMatrixWithYInterval:5 andSubYInterval:4];
    [self addDushWithYInterval:5 andSubYInterval:4];
    [self addTextLabelWithYInterval:5 andSubYInterval:4];
}

- (void) addTextLabelWithYInterval:(NSInteger)y andSubYInterval:(NSInteger)subY
{
    //两侧 Y 方向
    NSInteger incrementY = Define_ChartsHeight / y;
    NSInteger labelHeight = incrementY / subY;
    for (int i = 1; i< y ; i++) {
        CGRect priceFrame = CGRectMake(0,Define_TitleHeight + Define_ChartsHeight - incrementY * i - labelHeight, Define_X_Y_LableWidth,labelHeight);
        UILabel *priceLabel = (UILabel *)[self viewWithTag:Tag_PriceLabelTag + i];
        if (nil == priceLabel){
            priceLabel = [[UILabel alloc] init];
            priceLabel.tag = Tag_PriceLabelTag + i;
            [self addSubview:priceLabel];
        }
        priceLabel.frame = priceFrame;
        priceLabel.font = self.yLabelFont;
        priceLabel.textColor = self.priceLineColor;
        priceLabel.textAlignment = NSTextAlignmentCenter;
        priceLabel.text = [NSString stringWithFormat:@"%ldW",_displayPriceList / subY * i ];

        CGRect countFrame =CGRectMake(CGRectGetWidth(self.bounds) - Define_X_Y_LableWidth,Define_TitleHeight + Define_ChartsHeight - incrementY * i - labelHeight, Define_X_Y_LableWidth, labelHeight);
        UILabel *countLabel  = (UILabel *)[self viewWithTag:Tag_CountLabelTag + i];
        if (nil == countLabel) {
            countLabel = [[UILabel alloc] init];
            countLabel.tag = Tag_CountLabelTag + i;
            [self addSubview:countLabel];
        }
        countLabel.frame = countFrame;
        countLabel.font = self.yLabelFont;
        countLabel.textColor = self.countLineColor;
        countLabel.textAlignment = NSTextAlignmentCenter;
        countLabel.text = [NSString stringWithFormat:@"%ld",_displayCountList / subY * i ];
    }
    //X 方向
    CGFloat dateLabelHeight = 30;
    [self.chartDataArray enumerateObjectsUsingBlock:^(ChartData *data, NSUInteger idx, BOOL *stop) {
        NSInteger index = [[NSNumber numberWithUnsignedInteger:idx] integerValue];
        CGRect dateFrame = CGRectMake(_interval * index  - Define_X_Y_LableWidth / 2,
                                      Define_TitleHeight + Define_ChartsHeight - dateLabelHeight / 2,
                                      Define_X_Y_LableWidth,
                                      dateLabelHeight);
        UILabel *dateLabel = (UILabel *)[self.chartScrollView viewWithTag:Tag_DateLabeltag + idx];
        if (nil == dateLabel) {
            dateLabel = [[UILabel alloc] init];
            dateLabel.tag = Tag_DateLabeltag + idx;
            [self.chartScrollView addSubview:dateLabel];
        }
        dateLabel.frame = dateFrame;
        dateLabel.font = self.xLabelFont;
        dateLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel.text = data.saleMonth;
    }];

}


- (void) addMatrixWithYInterval:(NSInteger)y andSubYInterval:(NSInteger)subY
{
    NSInteger incrementY = Define_ChartsHeight / y;
//    CGContextSetRGBStrokeColor(context, 0.2f, 0.2f, 0.2f, 0.5f);
    if (_matrixLayer == nil) {
        _matrixLayer = [[CAShapeLayer alloc] init];
        [self.chartScrollView.layer addSublayer:_matrixLayer];
    }
    UIBezierPath *path = [UIBezierPath bezierPath];
    _matrixLayer.fillColor = [UIColor clearColor].CGColor;
    _matrixLayer.lineWidth = 0.5;
    _matrixLayer.strokeColor = [UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.7].CGColor;
    for (int i = 1; i< y ; i++) {
        [path moveToPoint:CGPointMake(0, Define_TitleHeight + incrementY * i)];
        [path addLineToPoint:CGPointMake(self.chartScrollView.contentSize.width, Define_TitleHeight + incrementY * i)];
    }
    _matrixLayer.path = path.CGPath;
}

- (void) addSubMatrixWithYInterval:(NSInteger)y andSubYInterval:(NSInteger)subY
{
    NSInteger incrementY = Define_ChartsHeight / y;
    if (nil == _matrixSubLayer) {
        _matrixSubLayer = [[CAShapeLayer alloc] init];
        [self.chartScrollView.layer addSublayer:_matrixSubLayer];
    }
    UIBezierPath *path = [UIBezierPath bezierPath];
    _matrixSubLayer.fillColor = [UIColor clearColor].CGColor;
    _matrixSubLayer.strokeColor = [UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.3].CGColor;
    _matrixSubLayer.lineWidth = 0.5;
    for (int i = 0; i< y ; i++) {
        [path moveToPoint:CGPointMake(0, Define_TitleHeight + incrementY * i)];
//        [path addLineToPoint:CGPointMake(self.chartScrollView.contentSize.width, Define_TitleHeight + incrementY * i)];
        NSInteger subIncrement = incrementY / subY;
        for (int sub = 1; sub  < subY; sub++) {
            if (i == 0 && sub ==1) {
                continue;
            }
            [path moveToPoint:CGPointMake(0, Define_TitleHeight + incrementY * i + subIncrement * sub)];
            [path addLineToPoint:CGPointMake(self.chartScrollView.contentSize.width, Define_TitleHeight + incrementY * i + subIncrement * sub)];
        }
    }
    _matrixSubLayer.path = path.CGPath;
}

- (void)addDushWithYInterval:(NSInteger)y andSubYInterval:(NSInteger)subY
{
    if (nil == _dushLayer) {
        _dushLayer = [[CAShapeLayer alloc] init];
        [self.chartScrollView.layer addSublayer:_dushLayer];
    }
    UIBezierPath *path = [UIBezierPath bezierPath];
    _dushLayer.fillColor = [UIColor clearColor].CGColor;
    _dushLayer.strokeColor = [UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.3].CGColor;
    _dushLayer.lineWidth = 0.5;
    _dushLayer.lineDashPhase = 0;
    _dushLayer.lineDashPattern = @[@6,@3];
    CGFloat startY =  Define_TitleHeight + Define_ChartsHeight / y / subY;
    NSInteger count = self.chartScrollView.contentSize.width / _interval;
    for (int i = 0 ; i< count ; i++) {
        [path moveToPoint:CGPointMake(_interval * i,startY)];
        [path addLineToPoint:CGPointMake(_interval * i, Define_TitleHeight + Define_ChartsHeight)];
    }
    _dushLayer.path = path.CGPath;
}


#pragma mark 画线

- (void) addLineSetLayer:(LineChartDataSet *)lineSet
{
    NSLog(@"sublayers %@", self.chartScrollView.layer.sublayers);
    NSLog(@"presentationLayer  %@",self.chartScrollView.layer.presentationLayer);
    NSLog(@"modelLayer  %@",self.chartScrollView.layer.modelLayer);
    __block LineLayer *lineLayer;
    [self.chartScrollView.layer.sublayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[LineLayer class]]) {
            LineLayer *layer = (LineLayer *)obj;
            if (layer.tag == Tag_LineTag + lineSet.lineType) {
                lineLayer = layer;
            }
        }
    }];
    if (nil == lineLayer) {
        lineLayer = [[LineLayer alloc] init];
        [self.chartScrollView.layer addSublayer:lineLayer];
    }
    lineLayer.lineInterval = _interval;
    lineLayer.tag = Tag_LineTag + lineSet.lineType;
    [lineLayer initWithSet:lineSet];
    NSLog(@"sublayers %@", self.chartScrollView.layer.sublayers);
    NSLog(@"presentationLayer  %@",self.chartScrollView.layer.presentationLayer);
    NSLog(@"modelLayer  %@",self.chartScrollView.layer.modelLayer);
}

- (CGPoint) transformPoint:(CGPoint) unTransformPoint
{
    CGFloat y = Define_ChartsHeight * 4.0f / 5.0f * unTransformPoint.y + Define_ChartsHeight / 5.0f + Define_TitleHeight;
    return CGPointMake(unTransformPoint.x * _interval , y);
}

- (void) addCircle:(LineChartDataSet *)lineSet
{
    [lineSet.pointArray enumerateObjectsUsingBlock:^(NSValue *value, NSUInteger idx, BOOL *stop) {
        CGPoint unTransformPoint = [value CGPointValue];
        CGPoint point = [self transformPoint:unTransformPoint];
        CGRect rect = CGRectMake(point.x - Define_CircleDiameter / 2, point.y - Define_CircleDiameter / 2, Define_CircleDiameter, Define_CircleDiameter);
        CircleView *circle = (CircleView *)[self.chartScrollView viewWithTag:lineSet.lineType * Tag_CircleTag + idx];
        if (nil == circle) {
            circle = [[CircleView alloc] init];//WithFrame:rect];
            circle.tag = lineSet.lineType * Tag_CircleTag + idx;
            [self.chartScrollView addSubview:circle];
        }
        circle.frame = rect;
        circle.borderColor = lineSet.circleColor;
        circle.borderWidth = 1;
        circle.holeColor = lineSet.circleHoleColor;
        circle.isAnimationEnabled = YES;
        __weak ChartsView *weakSelf = self;
        circle.circleClickBlock = ^(CircleView *circleView){
            __strong ChartsView *strongSelf = weakSelf;
            [strongSelf selectCircleIndex:idx];
        };
    }];
}

- (void) selectCircleIndex:(NSInteger) index
{
    [self.lineSetArray enumerateObjectsUsingBlock:^(LineChartDataSet *lineSet, NSUInteger idx, BOOL *stop) {
        if (_oldSelectIndex !=index) {
            CircleView *oldCircle = (CircleView *)[self.chartScrollView viewWithTag:lineSet.lineType * Tag_CircleTag + _oldSelectIndex];
            oldCircle.isSelected = NO;
        }
        CircleView *circle = (CircleView *)[self.chartScrollView viewWithTag:lineSet.lineType * Tag_CircleTag + index];
        circle.isSelected = !circle.isSelected;
        if (circle.isSelected) {
            [self addTextView:[self.chartDataArray objectAtIndex:index] andLineSet:lineSet andUpFrame:circle.frame animation:YES];
        }else{
            [self removeTextViewWithLineSet:lineSet];
        }
        
        if (self.selectIndexblock) {
            self.selectIndexblock(idx,circle);
        }
    }];
    _oldSelectIndex = index;
}

- (void) addTextView:(ChartData *)data andLineSet:(LineChartDataSet *)lineSet andUpFrame:(CGRect)rect animation:(BOOL) animation
{
    CGFloat width = 100;
    CGFloat height = 60;
    
    TextView *textView = (TextView *)[self.chartScrollView viewWithTag:Tag_TextViewTag + lineSet.lineType];
    if (textView == nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"TextView"owner:self options:nil];
        textView = [nib firstObject];
        textView.tag = Tag_TextViewTag + lineSet.lineType;
        textView.textLabel.font = self.valueLabelFont;
        textView.textLabel.textColor = lineSet.textColor;
        [self.chartScrollView addSubview:textView];
    }else{
        textView.alpha = 0;
    }
    NSLog(@"%f,%f,%f,%f",CGRectGetMidX(rect) - width / 2,CGRectGetMinY(rect) - height, width, height);
    textView.frame = CGRectMake(CGRectGetMidX(rect) - width / 2,CGRectGetMinY(rect) - height, width, height);
    if (lineSet.lineType == Line_Price) {
        textView.textLabel.text = [NSString stringWithFormat:@"%ld元",data.salePrice];
    }else if (lineSet.lineType == Line_Count){
        textView.textLabel.text = [NSString stringWithFormat:@"成交%ld套",data.saleCount];
    }
    [textView showWithAnimation:animation];
}

- (void) resetTextViewWithLineSet:(LineChartDataSet *)lineSet
{
    [lineSet.pointArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CircleView *circle = (CircleView *)[self.chartScrollView viewWithTag:lineSet.lineType * Tag_CircleTag + idx];
        if (circle.isSelected) {
            [self addTextView:[self.chartDataArray objectAtIndex:idx] andLineSet:lineSet andUpFrame:circle.frame animation:NO];
            *stop = YES;
        }
    }];

}

- (void) removeTextViewWithLineSet:(LineChartDataSet *)lineSet
{
    TextView *textView = (TextView *)[self.chartScrollView viewWithTag:Tag_TextViewTag + lineSet.lineType];
    if (nil != textView) {
        [textView hide];
    }
}

#pragma mark 绘制

- (void)drawRect:(CGRect)rect
{
        [self addMatrix];
        [self addLegendTextLabel];
        [self.lineSetArray enumerateObjectsUsingBlock:^(LineChartDataSet *lineSet, NSUInteger idx, BOOL *stop) {
            NSLog(@"Line Set index: %ld",idx);
            
            [self addLineSetLayer:lineSet];
            
            [self addCircle:lineSet];
            
            [self resetTextViewWithLineSet:lineSet];

        }];
}

@end
