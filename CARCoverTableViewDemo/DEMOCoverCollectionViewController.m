//
//  DEMOCoverCollectionViewController.m
//  CARCoverTableViewDemo
//
//  Created by Yamazaki Mitsuyoshi on 8/5/14.
//  Copyright (c) 2014 CrayonApps Inc. All rights reserved.
//

#import "DEMOCoverCollectionViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface DEMOCoverCollectionViewController ()

@property (nonatomic, readonly) CARCoverCollectionView *coverCollectionView;

@end

@implementation DEMOCoverCollectionViewController

@dynamic coverCollectionView;

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.coverCollectionView.minimumCoverHeight = 120.0f;
	[self.coverCollectionView setCoverHeight:300.0f borderHeight:0.0f];
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
- (CARCoverCollectionView *)coverCollectionView {
	return (CARCoverCollectionView *)self.collectionView;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
	
	cell.contentView.layer.borderWidth = 1.0f;
	cell.contentView.layer.borderColor = [UIColor darkGrayColor].CGColor;
	
	return cell;
}

#pragma mark - UICollectionViewDelegate

@end
