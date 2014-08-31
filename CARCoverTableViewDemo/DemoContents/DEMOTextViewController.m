//
//  DEMOTextViewController.m
//  CARCoverTableViewDemo
//
//  Created by Yamazaki Mitsuyoshi on 8/29/14.
//  Copyright (c) 2014 CrayonApps Inc. All rights reserved.
//

#import "DEMOTextViewController.h"

#import "CARCoverScrollController.h"

@interface DEMOTextViewController () <CARScrollViewController>

@end

@implementation DEMOTextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CARScrollViewController
- (UIScrollView *)scrollView {
	return self.textView;
}

@end
