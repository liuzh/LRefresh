//
//  ViewController.m
//  LRefresh
//
//  Created by mac on 15/8/25.
//  Copyright (c) 2015年 com.liu. All rights reserved.
//

#import "ViewController.h"
#import "LRefresh.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,LRefreshDelegate>

@property (nonatomic, strong) LRefresh *refresh;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    
    _refresh = [[LRefresh alloc] initWithContentView:tableView];
    _refresh.delegate = self;
    [_refresh addRefreshView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"你好＝%@",@(indexPath.row)];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (NSDictionary *)paramsForRefresh:(LRefresh *)refresh
{
    http://v5.pc.duomi.com/search-ajaxsearch-searchall?kw=“爱情”&pz=10
    return @{@"kw":@"爱情",@"pz":@(20)};
}

- (void)refreshDidSuccess:(id)success
{
    NSDictionary *dic = (NSDictionary *)success;
    NSArray *arr = dic[@"albums"];
    for (NSInteger i = 0; i < arr.count; i++) {
        [self.refresh.arrData addObject:@(i)];
    }
}
@end
