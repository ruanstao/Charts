//
//  ChartData.h
//  Charts
//
//  Created by JJS-iMac on 15/7/14.
//  Copyright (c) 2015年 JJS-iMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChartData : NSObject

@property (nonatomic,assign) NSInteger cjAvgPrice;

@property (nonatomic,assign) NSInteger cjCount;

@property (nonatomic,strong) NSString *cjMonth;

@property (nonatomic,strong) NSString *lpId;
@end
//{
//    "lpId": 2193,
//    "cjMonth": "2014-10",
//    "cjCount": 3,
//    "cjAvgPrice": 4900.54
//},