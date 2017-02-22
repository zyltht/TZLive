//
//  TZNavigation.m
//  TZLive
//
//  Created by Xin Chen on 17/2/14.
//  Copyright © 2017年 重庆香樟树. All rights reserved.
//

#import "TZNavigation.h"

@interface TZNavigation ()

@end

@implementation TZNavigation

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //拦截所有push进来的控制器
    viewController.automaticallyAdjustsScrollViewInsets = NO;
    viewController.view.backgroundColor = [UIColor whiteColor];
    self.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],NSForegroundColorAttributeName: [UIColor whiteColor]}];
    if (self.viewControllers.count > 0) { // 这时push进来的控制器viewController，不是第一个子控制器（不是根控制器）
//        viewController.hidesBottomBarWhenPushed = YES;
        
        
        //        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        
        
    }
    [super pushViewController:viewController animated:animated];
}



@end
