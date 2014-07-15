//
//  CARCoverScrollViewController.m
//  CARCoverTableViewDemo
//
//  Created by Yamazaki Mitsuyoshi on 7/11/14.
//  Copyright (c) 2014 CrayonApps Inc. All rights reserved.
//

#import "CARCoverScrollViewController.h"

@interface CARCoverScrollViewController ()

@property (nonatomic, assign, getter = isScrolling) BOOL scrolling;

/**
 UIScrollView のページングと同じ効果
 */
- (void)fitCoverScrollViewPage;

@end

@implementation CARCoverScrollViewController

@synthesize roughPagingEnabled = _roughPagingEnabled;

@dynamic coverTableView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.roughPagingEnabled = YES;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self.coverScrollView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Accessor
- (CARCoverTableView *)coverTableView {
	NSAssert([self.tableView isKindOfClass:[CARCoverTableView class]], @"");
	return (CARCoverTableView *)self.tableView;
}

- (void)setRoughPagingEnabled:(BOOL)roughPagingEnabled {
	
	if (roughPagingEnabled) {
		[self fitCoverScrollViewPage];
	}
	
	_roughPagingEnabled = roughPagingEnabled;
}

#pragma mark - CARCoverScrollView
- (void)fitCoverScrollViewPage {
	
	CGFloat x = self.coverScrollView.contentOffset.x;
	CGFloat boundsWidth = self.coverScrollView.bounds.size.width;
	
	if (boundsWidth == 0.0f) {
		return;
	}
	
	NSInteger floorX = floorf(x);
	NSInteger floorBoundsWidth = floorf(boundsWidth);
	NSInteger index = floorX / floorBoundsWidth;
	
	if (index == (x / boundsWidth)) {
		// fitしている場合
		return;
	}
	
	CGFloat threshold = (boundsWidth * index) + (boundsWidth / 2.0f);
	CGPoint contentOffset = self.coverScrollView.contentOffset;
	
	if (x > threshold) {
		contentOffset.x = boundsWidth * (index + 1);
	}
	else {
		contentOffset.x = boundsWidth * index;
	}

	if (contentOffset.x < 0.0f) {
		contentOffset.x = 0.0f;
	}
	else if (contentOffset.x > (self.coverScrollView.contentSize.width - boundsWidth)) {
		contentOffset.x = self.coverScrollView.contentSize.width - boundsWidth;
	}
	
	[self.coverScrollView setContentOffset:contentOffset animated:YES];
}

#pragma mark - CARCoverScrollViewController
- (void)coverScrollViewDidFinishScrolling {
	
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	[self doesNotRecognizeSelector:_cmd];
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	[self doesNotRecognizeSelector:_cmd];
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	
	// スクロール終端のみ pagingEnabled = YES にするというのはおすすめできない。そうした場合、fitされるページはスクロール開始時のページだからだ
	
	if (scrollView == self.coverScrollView) {
		if (self.isRoughPagingEnabled == YES) {
			if (decelerate) {
				self.scrolling = YES;
			}
			else {
				self.scrolling = NO;
				[self fitCoverScrollViewPage];
			}
		}
	}
}

- (void)scrollView:(CARCoverScrollView *)scrollView didScrollWithVelocity:(CGFloat)velocity {
	
	if ((self.isRoughPagingEnabled == YES) && (self.isScrolling == YES)) {
		if (fabsf(velocity) < 160) {
			self.scrolling = NO;
			
			[self fitCoverScrollViewPage];
		}
	}
}

@end
