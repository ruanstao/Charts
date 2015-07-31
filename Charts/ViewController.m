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
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.chartsView = [[ChartsView alloc] initWithFrame:CGRectMake(0, 100, 320, 500)];
//     [self.view addSubview:self.chartsView];
    self.chartsView.priceLineColor = mChartsRGB(0x4A90E2);
    self.chartsView.priceTextColor = mChartsRGB(0xEF7482);
    self.chartsView.countLineColor = mChartsRGB(0x7ED321);
    self.chartsView.countTextColor = mChartsRGB(0x7ED321);
    self.chartsView.yLabelFont = [UIFont systemFontOfSize:14];
    self.chartsView.xLabelFont = [UIFont systemFontOfSize:14];
    self.chartsView.valueLabelFont = [UIFont systemFontOfSize:21];
    self.chartsView.legendFont = [UIFont systemFontOfSize:16];
    [self getData];
//    _chartsView.frame =
   
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RetainCircleViewController * rc = [[RetainCircleViewController alloc] init];
    [self.navigationController pushViewController:rc animated:YES];
}
@end
