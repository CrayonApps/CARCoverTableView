//
//  DEMOImageViewController.m
//  CARCoverTableViewDemo
//
//  Created by Yamazaki Mitsuyoshi on 7/9/14.
//  Copyright (c) 2014 CrayonApps Inc. All rights reserved.
//

#import "DEMOImageViewController.h"

#import "CARCoverTableView.h"

@interface DEMOImageViewController ()

@property (nonatomic, readonly) CARCoverTableView *coverTableView;

@end

@implementation DEMOImageViewController

@dynamic coverTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.coverTableView.minimumCoverHeight = 100.0f;	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	// self.coverTableView.coverView が self.view の半分の大きさで表示される contentOffset。
	// 負数が掛けられているのは、section0-row0のセルの上端で contentOffset が指定されるため（self.coverTableView.coverView は contentInset.top の領域にある）。
	self.coverTableView.contentOffset = CGPointMake(0.0f, -(self.coverTableView.frame.size.height / 2.0f));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

#pragma mark - Accessor
- (CARCoverTableView *)coverTableView {
	return (CARCoverTableView *)self.tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	
	cell.textLabel.text = [NSString stringWithFormat:@"CELL %03d", indexPath.row];
	return cell;
}

@end
