//
//  DEMOCoverScrollController.m
//  CARCoverTableViewDemo
//
//  Created by Yamazaki Mitsuyoshi on 8/26/14.
//  Copyright (c) 2014 CrayonApps Inc. All rights reserved.
//

#import "DEMOCoverScrollController.h"

#import "DEMOCoverImageCell.h"

@interface DEMOCoverScrollController ()

@end

@implementation DEMOCoverScrollController

- (void)viewDidLoad
{
    [super viewDidLoad];

//	self.horizontalScrollingEnabledOnContentView = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CARCoverScrollViewCell *)coverScrollView:(CARCoverScrollView *)coverScrollView cellAtIndex:(NSInteger)index {
	
	NSString *identifier = @"DEMOCoverImageCell";
	DEMOCoverImageCell *cell = [coverScrollView dequeReusableCellWithIdentifier:identifier];
	if (cell == nil) {
		cell = [DEMOCoverImageCell coverImageCell];
	}
	
	UIViewController <CARScrollViewController> *childViewController = self.viewControllers[index];
	
	cell.titleLabel.text = childViewController.title;
	cell.imageView.image = [UIImage imageNamed:@"image001"];
	
	return cell;
}

@end
