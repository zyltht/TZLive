//
//  ViewController.m
//  TZLive
//
//  Created by Xin Chen on 17/2/13.
//  Copyright © 2017年 重庆香樟树. All rights reserved.
//

#import "ViewController.h"

#import "TZPushLiveVC.h"
#import "TZPullLiveVC.h"




@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    self.title = @"TZLive";
}

#pragma mark 懒加载tableView
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, TZ_Screen_Width, TZ_Screen_Height - 64)];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        _tableView.rowHeight = 44.0f;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;
}
#pragma mark 懒加载dataSource
-(NSMutableArray *)dataSource{
    return (NSMutableArray *)@[@"推流直播",@"拉流直播"];
}

#pragma  mark <UITableViewDelegate, UITableViewDataSource>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataSource[indexPath.row];
    cell.textLabel.font = TZFont(13);
    cell.textLabel.numberOfLines = 0;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0://推流直播
        {
            TZPushLiveVC *psVC = [[TZPushLiveVC alloc]init];
            [self.navigationController presentViewController:psVC animated:YES completion:nil];
        }
            break;
        case 1://拉流直播
        {
            TZPullLiveVC *plVC = [[TZPullLiveVC alloc]init];
            [self.navigationController presentViewController:plVC animated:YES completion:nil];
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            
        }
            break;
            
        default:
            break;
    }
}


@end
