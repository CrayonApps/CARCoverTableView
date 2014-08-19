//
//  CARCoverScrollViewController.m
//  CARCoverTableViewDemo
//
//  Created by Yamazaki Mitsuyoshi on 8/11/14.
//  Copyright (c) 2014 CrayonApps Inc. All rights reserved.
//

#import "CARCoverScrollController.h"

@interface CARCoverScrollController ()

@property (nonatomic, readonly) NSMutableArray *childScrollViewControllers;
@property (nonatomic, readonly) NSMutableArray *childScrollViews;

- (UIScrollView *)scrollViewForViewController:(UIViewController *)viewController;

- (void)showChildScrollViewControllerAtIndex:(NSInteger)index;
- (void)hideChildScrollViewController;
- (void)fixContentOffset:(UIScrollView *)toScrollView from:(CGPoint)fromOffset;

@end

@implementation CARCoverScrollController

@synthesize coverScrollView = _coverScrollView;
@synthesize childScrollViewControllers = _childScrollViewControllers;
@synthesize childScrollViews = _childScrollViews;
@synthesize currentViewController = _currentViewController;
@dynamic viewControllers;

- (id)initWithRootViewController:(UIViewController *)rootViewController scrollView:(UIScrollView *)scrollView {
	
	self = [super init];
	if (self) {
		
		[self initializeCoverViewController];
		
		if (rootViewController) {
			NSAssert(scrollView, @"scrollView cannot be nil when rootViewController is not nil");
			[self insertChildScrollViewController:rootViewController scrollView:scrollView atIndex:0];
		}
	}
	return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	[self initializeCoverViewController];
}

- (void)initializeCoverViewController {
	[super initializeCoverViewController];
	
	_childScrollViewControllers = [[NSMutableArray alloc] init];
	_childScrollViews = [[NSMutableArray alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self initializeCoverScrollView];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self.coverScrollView reloadData];
	[self showChildScrollViewControllerAtIndex:self.coverScrollView.currentIndex];
}

#pragma mark - Rotation
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
		
	CGSize contentSize = self.coverScrollView.contentSize;
	contentSize.width = self.coverScrollView.bounds.size.width * self.viewControllers.count;
	
	self.coverScrollView.contentSize = contentSize;
}

#pragma mark - ContainerViewController Methods
- (void)showChildScrollViewControllerAtIndex:(NSInteger)index {
	
	UIViewController *childViewController = self.childScrollViewControllers[index];
	UIScrollView *scrollView = self.childScrollViews[index];

	[self showChildScrollViewController:childViewController scrollView:scrollView];
}

- (void)showChildScrollViewController:(UIViewController *)childController scrollView:(UIScrollView *)scrollView {
	
	if (childController == self.currentViewController) {
		return;
	}
	
	UIScrollView *currentScrollView = [self scrollViewForViewController:self.currentViewController];
	CGPoint contentOffset = currentScrollView.contentOffset;
	
	[self hideChildScrollViewController];
	
	[super showChildScrollViewController:childController scrollView:scrollView];
	
	[self fixContentOffset:scrollView from:contentOffset];
	
	_currentViewController = childController;
}

- (void)hideChildScrollViewController {

	if (self.currentViewController == nil) {
		return;
	}
	
	UIViewController *childViewController = self.currentViewController;
	UIScrollView *scrollView = [self scrollViewForViewController:childViewController];

	[self.view removeGestureRecognizer:self.panGestureRecognizer];
	[scrollView addGestureRecognizer:self.panGestureRecognizer];

	// TODO:
	UIEdgeInsets contentInset = scrollView.contentInset;
	contentInset.top -= self.maximumCoverHeight;
	scrollView.contentInset = contentInset;
	
	[childViewController.view removeFromSuperview];
}

#pragma mark - ScrollView Layout
- (void)fixContentOffset:(UIScrollView *)toScrollView from:(CGPoint)fromOffset {

	if (toScrollView == nil) {
		return;
	}
	
	CGFloat y = fromOffset.y;
	
	if (y < 0.0f) {
		toScrollView.contentOffset = fromOffset;
	}
}

#pragma mark - Accessor
- (NSArray *)viewControllers {
	return self.childScrollViewControllers.copy;
}

- (UIScrollView *)scrollViewForViewController:(UIViewController *)viewController {
	
	if (viewController == nil) {
		return nil;
	}
	
	if ([self.childScrollViewControllers containsObject:viewController] == NO) {
		[NSException raise:NSInvalidArgumentException format:@""];
	}
	
	NSInteger index = [self.childScrollViewControllers indexOfObject:viewController];
	return self.childScrollViews[index];
}

#pragma mark - Subviews
- (void)initializeCoverScrollView {
	
	CGRect frame = self.coverView.bounds;
	
	_coverScrollView = [[CARCoverScrollView alloc] initWithFrame:frame];
	_coverScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_coverScrollView.dataSource = self;
	_coverScrollView.delegate = self;
	
	_coverScrollView.backgroundColor = [UIColor whiteColor];
	_coverScrollView.roughPagingEnabled = YES;

	[self.coverView addSubview:_coverScrollView];
}

#pragma mark - ContainerViewController Methods
- (void)addChildScrollViewController:(UIViewController *)childController scrollView:(UIScrollView *)scrollView {
	[self insertChildScrollViewController:childController scrollView:scrollView atIndex:self.childScrollViewControllers.count];
}

- (void)insertChildScrollViewController:(UIViewController *)childController scrollView:(UIScrollView *)scrollView atIndex:(NSInteger)index {
		
	[self.childScrollViewControllers insertObject:childController atIndex:index];
	[self.childScrollViews insertObject:scrollView atIndex:index];

	[self initializeChildScrollViewController:childController];
	
	[self.coverScrollView reloadData];
}

#pragma mark - CARCoverScrollViewDataSource
- (NSInteger)numberOfItemsInScrollView:(CARCoverScrollView *)scrollView {
	return self.childScrollViewControllers.count;
}

- (UIView *)scrollView:(CARCoverScrollView *)scrollView viewAtIndex:(NSInteger)index {
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

#pragma mark - CARCoverScrollViewDelegate
- (void)scrollView:(CARCoverScrollView *)scrollView didUpdateCurrentIndex:(NSInteger)index {
//	NSLog(@"new scrollview index: %ld", (long)index);
	
	[self showChildScrollViewControllerAtIndex:index];
}

/*
- (void)scrollView:(CARCoverScrollView *)scrollView didSelectItemAtIndex:(NSInteger)index {
	NSLog(@"CARCoverScrollView did select item at index: %ld", (long)index);
}
*/

@end
