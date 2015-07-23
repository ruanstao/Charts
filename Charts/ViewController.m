//
//  ViewController.m
//  Charts
//
//  Created by JJS-iMac on 15/7/14.
//  Copyright (c) 2015年 JJS-iMac. All rights reserved.
//

#import "ViewController.h"
#import "ChartsView.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet ChartsView *chartsView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.chartsView = [[ChartsView alloc] initWithFrame:CGRectMake(0, 100, 320, 500)];
//     [self.view addSubview:self.chartsView];
    self.chartsView.backgroundColor = [UIColor whiteColor];
    [self getData];
//    _chartsView.frame =
   
}

- (void) getData
{
    NSMutableArray * arr = [NSMutableArray array];
    for (int i = 0; i < 12; i++) {
        
        ChartData * data = [[ChartData alloc] init];
        data.salePrice = random() % 10000 +(random()%10)*10000;
        data.saleCount = random() % 50;
        data.saleMonth = [NSString stringWithFormat:@"%d/%d",((i + 8)>12)?15:14, ((i + 8)%12)?:12];
        [arr addObject:data];
    }
//    LineChartDataSet * lineSet = [[LineChartDataSet alloc] init];
//    lineSet.chartDataArray = arr;
//    lineSet.lineColor = [UIColor blueColor];
//    [self.chartsView addLineChartDataSet:lineSet];
    self.chartsView.chartDataArray = arr;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if (indexPath.row == 10) {
        _chartsView.frame = CGRectMake(0, 0, 320, 400);
        [cell.contentView addSubview:_chartsView];
//        cell.setNeedsDisplay;
        cell.selected = NO;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    return cell;
}
@end
