//
//  DEMOSampleViewController.m
//  CARCoverTableViewDemo
//
//  Created by Yamazaki Mitsuyoshi on 7/20/14.
//  Copyright (c) 2014 CrayonApps Inc. All rights reserved.
//

#import "DEMOSampleViewController.h"

#import "CARCoverScrollViewController.h"

@interface DEMOSampleViewController ()

@end

@implementation DEMOSampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	switch (indexPath.section) {
		case 0:
			// InterfaceBuilderを使わずに生成するサンプル
			
			switch (indexPath.row) {
				case 0:
					// CoverTableView
					
					
					
					
					break;
					
				case 1: {
					// CoverScrollViewController
					
					CARCoverScrollViewController *scrollViewController = [[CARCoverScrollViewController alloc] init];
					
					
					break;
				}
				default:
					break;
			}

			break;
			
		default:
			break;
	}
}

#pragma mark - UIStoryboardSegue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
}

@end
