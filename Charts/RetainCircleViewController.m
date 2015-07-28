//
//  RetainCircleViewController.m
//  Charts
//
//  Created by RuanSTao on 15/7/23.
//  Copyright (c) 2015年 JJS-iMac. All rights reserved.
//

#import "RetainCircleViewController.h"
#import "ChartsView.h"
@interface RetainCircleViewController ()
@property (strong, nonatomic) IBOutlet ChartsView *chartsView;

@end

@implementation RetainCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
     self.automaticallyAdjustsScrollViewInsets = NO;
    self.chartsView = [[ChartsView alloc] initWithFrame:CGRectMake(0, 60, 320, 500)];
    [self getData];
    [self.view addSubview:self.chartsView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

- (void) getData
{
    NSMutableArray * arr = [NSMutableArray array];
    for (int i = 0; i < 12; i++) {
        
        ChartData * data = [[ChartData alloc] init];
        data.cjAvgPrice = random() % 10000 +(random()%10)*10000;
        data.cjCount = random() % 50;
        data.cjMonth = [NSString stringWithFormat:@"%d/%d",((i + 8)>12)?15:14, ((i + 8)%12)?:12];
        [arr addObject:data];
    }
    self.chartsView.chartDataArray = arr;
    
}

- (void)dealloc
{
    NSLog(@"dealloc");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
