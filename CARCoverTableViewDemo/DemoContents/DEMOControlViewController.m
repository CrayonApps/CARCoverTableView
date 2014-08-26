//
//  DEMOControlViewController.m
//  CARCoverTableViewDemo
//
//  Created by Yamazaki Mitsuyoshi on 8/26/14.
//  Copyright (c) 2014 CrayonApps Inc. All rights reserved.
//

#import "DEMOControlViewController.h"

#import "CARCoverScrollController.h"

@interface DEMOControlViewController () <CARScrollViewController>

@property (nonatomic, weak) IBOutlet UILabel *minimumHeightLabel;
@property (nonatomic, weak) IBOutlet UILabel *maximumHeightLabel;

- (void)reloadLabels;

@end

@implementation DEMOControlViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self reloadLabels];
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

#pragma mark - 
- (void)reloadLabels {
	
	self.minimumHeightLabel.text = [NSString stringWithFormat:@"%.1f", self.coverViewController.minimumCoverHeight];
	self.maximumHeightLabel.text = [NSString stringWithFormat:@"%.1f", self.coverViewController.maximumCoverHeight];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	switch (indexPath.row) {
		case 0:	{ // minimum cover height
			static NSInteger i = 0;
			self.coverViewController.minimumCoverHeight = [@[@100, @64][i % 2] floatValue];
			
			i++;
			break;
		}
			
		case 1: {	// maximum cover height
			static NSInteger i = 0;
			self.coverViewController.maximumCoverHeight = [@[@(self.view.frame.size.height * 0.6f), @(self.view.frame.size.height * 0.3f)][i % 2] floatValue];

			i++;
			break;
		}
			
		default:
			break;
	}
	
	[self reloadLabels];
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
