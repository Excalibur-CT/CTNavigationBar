
//
//  EditController.m
//  CTNavigationBar
//
//  Created by Admin on 2016/12/19.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#import "EditController.h"
#import "CTNavigationBar.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface EditController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)CTNavigationBar * navigationBar;

@property (strong, nonatomic) UITableView *tableView;


@end

@implementation EditController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.fd_prefersNavigationBarHidden = YES;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.navigationBar];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIndentifier = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    return cell;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        CGSize size = [[UIScreen mainScreen] bounds].size;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, size.width, size.height-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (CTNavigationBar *)navigationBar
{
    if (_navigationBar == nil) {
        _navigationBar = [[CTNavigationBar alloc] initWithTitle:@"Translation"];
        __weak typeof(self) weakSelf = self;
        [_navigationBar ct_setLeftButtonImage:[UIImage imageNamed:@"nav_back"] actionBlock:^(CTNavigationBar * bar,UIBarButtonItem *item) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        
        [_navigationBar ct_setRightButtonTitle:@"编辑" actionBlock:^(CTNavigationBar * bar,UIBarButtonItem *item) {
            if ([item.title isEqualToString:@"编辑"])
            {
                item.title = @"完成";
                bar.leftBarButtonItem = nil;
            }
            else
            {
                item.title = @"编辑";
                [bar ct_setLeftButtonImage:[UIImage imageNamed:@"nav_back"] actionBlock:^(CTNavigationBar * bar,UIBarButtonItem *item) {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
            }
        }];

    }
    return _navigationBar;
}

@end
