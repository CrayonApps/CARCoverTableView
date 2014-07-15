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

@interface DEMOCoverScrollViewController () <CARCoverScrollViewDataSource, CARCoverScrollViewDelegate>

@property (nonatomic, copy) NSNumber *currentIndex;

- (void)changeItemsToIndex:(NSNumber *)index animated:(BOOL)animated;

@end

@implementation DEMOCoverScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self changeItemsToIndex:@(self.coverScrollView.currentIndex) animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

#pragma mark - Item
- (void)changeItemsToIndex:(NSNumber *)index animated:(BOOL)animated {
	
	if ((index == nil) && (self.currentIndex == nil)) {
		return;
	}
	
	if (self.currentIndex && [index isEqualToNumber:self.currentIndex]) {
		return;
	}
		
	self.currentIndex = index;

	if (animated == NO) {
		[self.coverTableView reloadData];
		return;
	}
	
	[self.coverTableView beginUpdates];
	
	NSMutableArray *indexPaths = [NSMutableArray array];
	
	for (NSInteger i = 0; i < 20; i++) {
		[indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
	}

	if (self.currentIndex) {
		[self.coverTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
	}
	else {
		[self.coverTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
	}

	[self.coverTableView endUpdates];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.currentIndex ? 20 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	
	cell.textLabel.text = [NSString stringWithFormat:@"CELL %02d-%03ld", self.currentIndex.integerValue, (long)indexPath.row];
	return cell;
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

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
	if (scrollView == self.coverScrollView) {
		if (self.currentIndex && (self.currentIndex.integerValue != self.coverScrollView.currentIndex)) {
			[self changeItemsToIndex:nil animated:YES];
		}
	}
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
	
	if (scrollView == self.coverScrollView) {
		NSInteger index = self.coverScrollView.currentIndex;
		[self changeItemsToIndex:@(index) animated:YES];
	}
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