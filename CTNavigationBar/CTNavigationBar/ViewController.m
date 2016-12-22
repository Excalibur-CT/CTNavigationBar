//
//  ViewController.m
//  CTNavigationBar
//
//  Created by Admin on 2016/12/18.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic, strong)NSArray * dataAry;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataAry = @[@{@"title":@"改变bar透明度",@"action":@"AlphaController"},
                     @{@"title":@"改变bar偏移量",@"action":@"TranslationController"},
                     @{@"title":@"编辑",@"action":@"EditController"}];
    [self.view addSubview:self.tableView];
    self.title = @"NavigationBar";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIndentifier = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
    }
    cell.textLabel.text = self.dataAry[indexPath.row][@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Class className = NSClassFromString(_dataAry[indexPath.row][@"action"]);
    [self.navigationController pushViewController:[[[className class] alloc] init] animated:YES];
    
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        CGSize size = [[UIScreen mainScreen] bounds].size;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
