//
//  CARCoverScrollViewController.m
//  CARCoverTableViewDemo
//
//  Created by Yamazaki Mitsuyoshi on 8/11/14.
//  Copyright (c) 2014 CrayonApps Inc. All rights reserved.
//

#import "CARCoverScrollController.h"

@interface CARCoverScrollController ()

- (void)showChildScrollViewControllerAtIndex:(NSInteger)index;
- (void)hideChildScrollViewController;
- (void)fixContentOffset:(UIScrollView *)toScrollView from:(CGPoint)fromOffset;

@end

@implementation CARCoverScrollController

@synthesize coverScrollView = _coverScrollView;
@synthesize currentViewController = _currentViewController;
@synthesize viewControllers = _viewControllers;

- (id)initWithRootViewController:(UIViewController *)rootViewController scrollView:(UIScrollView *)scrollView {
	/**
	 CARCoverScrollController *controller = [[CARCoverScrollController alloc] init];
	 controller.viewControllers = viewControllers
	 */
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	[self initializeCoverViewController];
}

- (void)initializeCoverViewController {
	[super initializeCoverViewController];
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
	
	UIViewController <CARScrollViewController> *childViewController = self.viewControllers[index];
	UIScrollView *scrollView = childViewController.scrollView;

	[self showChildScrollViewController:childViewController scrollView:scrollView];
}

- (void)showChildScrollViewController:(UIViewController *)childController scrollView:(UIScrollView *)scrollView {
	
	if (childController == self.currentViewController) {
		return;
	}
	
	CGPoint contentOffset = self.currentViewController.scrollView.contentOffset;
	
	[self hideChildScrollViewController];
	
	[super showChildScrollViewController:childController scrollView:scrollView];
	
	[self fixContentOffset:scrollView from:contentOffset];
	
	_currentViewController = (UIViewController <CARScrollViewController> *)childController;
}

- (void)hideChildScrollViewController {

	if (self.currentViewController == nil) {
		return;
	}
	
	UIViewController <CARScrollViewController> *childViewController = self.currentViewController;
	UIScrollView *scrollView = childViewController.scrollView;

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
- (void)setViewControllers:(NSArray *)viewControllers {
	
	for (UIViewController <CARScrollViewController> * childViewController in viewControllers) {
		if ([childViewController conformsToProtocol:@protocol(CARScrollViewController)] == NO) {
			[NSException raise:NSInvalidArgumentException format:@"childViewController object must conform to protocol CARScrollViewController"];
		}
		
		if ([_viewControllers containsObject:childViewController] == NO) {
			[self initializeChildScrollViewController:childViewController];
		}
	}
	
	_viewControllers = viewControllers.copy;
	
	[self.coverScrollView reloadData];
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

#pragma mark - CARCoverScrollViewDataSource
- (NSInteger)numberOfItemsInScrollView:(CARCoverScrollView *)scrollView {
	return self.viewControllers.count;
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

@implementation UIViewController (CARCoverScrollController)

- (CARCoverScrollController *)coverScrollController {
	
	for (UIViewController *viewController = self.parentViewController; viewController != nil; viewController = viewController.parentViewController) {
		if ([viewController isKindOfClass:[CARCoverScrollController class]]) {
			return (CARCoverScrollController *)viewController;
		}
	}
	
	return nil;
}

@end