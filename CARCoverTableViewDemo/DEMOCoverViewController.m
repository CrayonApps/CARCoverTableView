//
//  DEMOCoverViewController.m
//  CARCoverTableViewDemo
//
//  Created by Yamazaki Mitsuyoshi on 8/12/14.
//  Copyright (c) 2014 CrayonApps Inc. All rights reserved.
//

#import "DEMOCoverViewController.h"

@interface DEMOCoverViewController ()

@end

@implementation DEMOCoverViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.coverView.bounds];
	imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	imageView.image = [UIImage imageNamed:@"image001"];
	imageView.contentMode = UIViewContentModeScaleAspectFill;
	
	[self.coverView addSubview:imageView];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

@end
