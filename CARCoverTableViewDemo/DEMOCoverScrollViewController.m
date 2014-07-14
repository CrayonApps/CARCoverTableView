//
//  DEMOCoverScrollViewController.m
//  CARCoverTableViewDemo
//
//  Created by Yamazaki Mitsuyoshi on 7/11/14.
//  Copyright (c) 2014 CrayonApps Inc. All rights reserved.
//

#import "DEMOCoverScrollViewController.h"

@interface DEMOCoverScrollCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@end

@interface DEMOCoverScrollView : UIView
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@end

@interface DEMOCoverScrollViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CARCoverScrollViewDataSource, CARCoverScrollViewDelegate>

@end

@implementation DEMOCoverScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
	
	cell.textLabel.text = [NSString stringWithFormat:@"CELL %02d-%03ld", 0, (long)indexPath.row];
	return cell;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	DEMOCoverScrollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
	
	cell.titleLabel.text = [NSString stringWithFormat:@"CELL %02ld", (long)indexPath.item];
	
	return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	return [(UICollectionViewFlowLayout *)collectionViewLayout itemSize];
}

#pragma mark - CARCoverScrollViewDataSource
- (NSInteger)numberOfItemsInScrollView:(CARCoverScrollView *)scrollView {
	return 10;
}

- (UIView *)scrollView:(CARCoverScrollView *)scrollView viewAtIndex:(NSInteger)index {
	
	DEMOCoverScrollView *view = [scrollView dequeReusableView];
	if (view == nil) {
		view = [[DEMOCoverScrollView alloc] init];
	}
	
	view.titleLabel.text = [NSString stringWithFormat:@"VIEW %02d", index];
	
	return view;
}

- (void)scrollView:(CARCoverScrollView *)scrollView didSelectItemAtIndex:(NSInteger)index {
	NSLog(@"%d view selected", index);
}

@end

@implementation DEMOCoverScrollCell

@end

@implementation DEMOCoverScrollView

@synthesize titleLabel = _titleLabel;

- (UILabel *)titleLabel {
	
	if (_titleLabel == nil) {
		
		_titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
		_titleLabel.font = [UIFont boldSystemFontOfSize:30.0f];
		_titleLabel.textAlignment = NSTextAlignmentCenter;
		_titleLabel.backgroundColor = [UIColor redColor];
		_titleLabel.textColor = [UIColor whiteColor];
		_titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		
		[self addSubview:_titleLabel];
	}
	return _titleLabel;
}

@end