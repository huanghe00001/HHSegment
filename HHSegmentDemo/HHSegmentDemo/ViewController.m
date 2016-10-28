//
//  ViewController.m
//  HHSegmentDemo
//
//  Created by huanghe on 16/10/27.
//  Copyright © 2016年 huanghe. All rights reserved.
//

#import "ViewController.h"

#import "HHSegementView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    
    HHSegementView *segementView = [[HHSegementView alloc] initWithFrame:CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, 44)];
    segementView.titleArray = @[@"选项一",@"选项二",@"选项三"];
    segementView.time = 1;
    [self.view addSubview:segementView];
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
