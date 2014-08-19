//
//  DEMOCollectionViewController.m
//  CARCoverTableViewDemo
//
//  Created by Yamazaki Mitsuyoshi on 8/13/14.
//  Copyright (c) 2014 CrayonApps Inc. All rights reserved.
//

#import "DEMOCollectionViewController.h"

#import "DEMOCoverLabelCell.h"

@interface DEMOCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *textLabel;

@end

@interface DEMOCollectionViewController ()

@end

@implementation DEMOCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

#pragma mark - CARScrollViewController
- (UIScrollView *)scrollView {
	return self.collectionView;
}

- (CARCoverScrollViewCell *)coverScrollView:(CARCoverScrollView *)coverScrollView cellAtIndex:(NSInteger)index {
	
	NSString *identifier = @"DEMOCoverLabelCell";
	DEMOCoverLabelCell *cell = [coverScrollView dequeReusableCellWithIdentifier:identifier];
	if (cell == nil) {
		cell = [DEMOCoverLabelCell coverLabelCell];
	}
	
	cell.titleLabel.text = @"CollectionView";
	
	return cell;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	DEMOCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
	
	cell.textLabel.text = [NSString stringWithFormat:@"Cell %02d-%02d", indexPath.section, indexPath.row];

	return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"%@ selected", indexPath);
}

@end

@implementation DEMOCollectionViewCell

@end