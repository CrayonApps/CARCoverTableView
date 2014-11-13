//
//  CARCoverScrollViewController.m
//  CARCoverTableViewDemo
//
//  Created by Yamazaki Mitsuyoshi on 8/11/14.
//  Copyright (c) 2014 CrayonApps Inc. All rights reserved.
//

#import "CARCoverScrollController.h"

@interface CARCoverScrollController ()

@property (nonatomic, strong) UIPanGestureRecognizer *horizontalPanGestureRecognizer;
@property (nonatomic, assign) NSInteger currentIndex;

- (void)showChildScrollViewControllerAtIndex:(NSInteger)index;
- (void)fixContentOffset:(UIScrollView *)toScrollView from:(CGPoint)fromOffset;

- (void)updateCoverScrollViewContentSize;

@end

@implementation CARCoverScrollController

@synthesize coverScrollView = _coverScrollView;
@synthesize viewControllers = _viewControllers;
@synthesize currentViewController = _currentViewController;
@synthesize horizontalScrollingEnabledOnContentView = _horizontalScrollingEnabledOnContentView;

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
	
	self.currentIndex = self.coverScrollView.currentIndex;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self updateCoverScrollViewContentSize];
}

- (void)updateCoverScrollViewContentSize {
	
	CGSize contentSize = self.coverScrollView.contentSize;
	contentSize.width = self.coverScrollView.bounds.size.width * self.viewControllers.count;
	
	self.coverScrollView.contentSize = contentSize;
	
	self.coverScrollView.currentIndex = self.currentIndex;
}

#pragma mark - Rotation
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
	self.currentIndex = self.coverScrollView.currentIndex;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
	[self updateCoverScrollViewContentSize];
}

#pragma mark - ContainerViewController Methods
- (void)showChildScrollViewControllerAtIndex:(NSInteger)index {
	
	UIViewController <CARScrollViewController> *childViewController = self.viewControllers[index];
	[self showChildScrollViewController:childViewController];
}

- (void)showChildScrollViewController:(UIViewController<CARScrollViewController> *)childController {
	
	if (childController == self.currentViewController) {
		return;
	}
	
	if ([self.viewControllers containsObject:childController] == NO) {
		// TODO: なにか投げたい
		NSAssert(NO, @"hoge");
		return;
	}

	CGPoint contentOffset = self.currentViewController.scrollView.contentOffset;
	
	[self hideChildScrollViewController];
	
	[super showChildScrollViewController:childController];
	
	_currentViewController = childController;
	
	[self fixContentOffset:childController.scrollView from:contentOffset];
		
	if ([self.delegate respondsToSelector:@selector(coverScrollController:didShowViewController:)]) {
		[self.delegate coverScrollController:self didShowViewController:self.currentViewController];
	}
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
- (void)setRootViewController:(UIViewController<CARScrollViewController> *)rootViewController {
	self.currentViewController = rootViewController;
}

- (UIViewController <CARScrollViewController> *)rootViewController {
	return self.currentViewController;
}

- (void)setCurrentViewController:(UIViewController<CARScrollViewController> *)currentViewController {
	[self showChildScrollViewController:currentViewController];
}

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
	
	if ([self.delegate respondsToSelector:@selector(coverScrollController:didChangeViewControllers:)]) {
		[self.delegate coverScrollController:self didChangeViewControllers:self.viewControllers];
	}
}

- (void)setHorizontalScrollingEnabledOnContentView:(BOOL)horizontalScrollingEnabledOnContentView {
	
	if (horizontalScrollingEnabledOnContentView == _horizontalScrollingEnabledOnContentView) {
		return;
	}
	
	_horizontalScrollingEnabledOnContentView = horizontalScrollingEnabledOnContentView;
	
	if (horizontalScrollingEnabledOnContentView) {
		
		self.horizontalPanGestureRecognizer = self.coverScrollView.panGestureRecognizer;
		[self.coverScrollView removeGestureRecognizer:self.horizontalPanGestureRecognizer];
		[self.view addGestureRecognizer:self.horizontalPanGestureRecognizer];
	}
	else {
		
		[self.view removeGestureRecognizer:self.horizontalPanGestureRecognizer];
		[self.coverScrollView addGestureRecognizer:self.horizontalPanGestureRecognizer];
	}
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
- (NSInteger)numberOfItemsInCoverScrollView:(CARCoverScrollView *)scrollView {
	return self.viewControllers.count;
}

- (CARCoverScrollViewCell *)coverScrollView:(CARCoverScrollView *)scrollView cellAtIndex:(NSInteger)index {
	// CoverScrollViewCellを設定するためにCARCoverScrollControllerはサブクラス化して使用する必要がある
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

#pragma mark - CARCoverScrollViewDelegate
- (void)coverScrollView:(CARCoverScrollView *)scrollView didUpdateCurrentIndex:(NSInteger)index {
//	NSLog(@"new scrollview index: %ld", (long)index);
	
	[self showChildScrollViewControllerAtIndex:index];
}

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