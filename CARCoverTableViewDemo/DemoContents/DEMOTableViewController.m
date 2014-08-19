//
//  DEMOTableViewController.m
//  CARCoverTableViewDemo
//
//  Created by Yamazaki Mitsuyoshi on 8/13/14.
//  Copyright (c) 2014 CrayonApps Inc. All rights reserved.
//

#import "DEMOTableViewController.h"

#import "DEMOCoverImageCell.h"

@interface DEMOTableViewController ()

@end

@implementation DEMOTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CARScrollViewController
- (UIScrollView *)scrollView {
	return self.tableView;
}

- (CARCoverScrollViewCell *)coverScrollView:(CARCoverScrollView *)coverScrollView cellAtIndex:(NSInteger)index {
	
	NSString *identifier = @"DEMOCoverImageCell";
	DEMOCoverImageCell *cell = [coverScrollView dequeReusableCellWithIdentifier:identifier];
	if (cell == nil) {
		cell = [DEMOCoverImageCell coverImageCell];
	}
	
	cell.titleLabel.text = [NSString stringWithFormat:@"Table%02d", index];
	cell.imageView.image = [UIImage imageNamed:@"image001"];
	
	return cell;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
	cell.textLabel.text = [NSString stringWithFormat:@"Cell %02d-%02d", indexPath.section, indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"%@ selected", indexPath);
}

@end
