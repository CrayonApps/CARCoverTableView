//
//  CARCoverViewController.m
//  CARCoverTableViewDemo
//
//  Created by Yamazaki Mitsuyoshi on 8/11/14.
//  Copyright (c) 2014 CrayonApps Inc. All rights reserved.
//

#import "CARCoverViewController.h"

@interface CARCoverViewController ()

- (void)initializeCoverView;
- (void)initializeContentView;
- (CGRect)contentViewFrame;
- (void)resetContentViewFrame;

- (void)contentScrollViewDidScroll:(CGPoint)contentOffset;

@end

@implementation CARCoverViewController

@synthesize coverView = _coverView;
@synthesize contentView = _contentView;
@synthesize minimumCoverHeight = _minimumCoverHeight;
@synthesize maximumCoverHeight = _maximumCoverHeight;
@synthesize rootViewController = _rootViewController;
@synthesize panGestureRecognizer = _panGestureRecognizer;

- (id)init {
	
	self = [super init];
	if (self) {
		[self initializeCoverViewController];
	}
	return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	[self initializeCoverViewController];
}

- (void)initializeCoverViewController {
	
	CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
	_minimumCoverHeight = 64.0f;
	_maximumCoverHeight = screenHeight * 0.3f;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self initializeCoverView];
	[self initializeContentView];
	
	[self.view bringSubviewToFront:self.coverView];
}

#pragma mark - ContainerViewController Methods
#pragma mark UIKit
- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
	return YES;
}

- (BOOL)shouldAutomaticallyForwardRotationMethods {
	return YES;
}

#pragma mark Custom
- (void)initializeChildScrollViewController:(UIViewController <CARScrollViewController> *)childController {

	[childController removeFromParentViewController];
	[childController willMoveToParentViewController:self];
	
	[self addChildViewController:childController];
	[childController didMoveToParentViewController:self];
}

- (void)showChildScrollViewController:(UIViewController <CARScrollViewController> *)childController {

	[self view];
	[childController view];
	
	UIScrollView *scrollView = childController.scrollView;
	
	// scrollView
	self.panGestureRecognizer = scrollView.panGestureRecognizer;
	[scrollView removeGestureRecognizer:self.panGestureRecognizer];
	[self.view addGestureRecognizer:self.panGestureRecognizer];
	
	UIEdgeInsets contentInset = scrollView.contentInset;
	contentInset.top += self.maximumCoverHeight;	// contentInset.topで複雑な処理をしている場合は考慮していない
	scrollView.contentInset = contentInset;
	
	[scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];

	// view
	childController.view.frame = self.contentView.bounds;
	childController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.contentView addSubview:childController.view];
}

- (void)hideChildScrollViewController {
	
	if (self.rootViewController == nil) {
		return;
	}
	
	UIViewController <CARScrollViewController> *childViewController = self.rootViewController;
	UIScrollView *scrollView = childViewController.scrollView;
	
	[scrollView removeObserver:self forKeyPath:@"contentOffset" context:NULL];
	
	[self.view removeGestureRecognizer:self.panGestureRecognizer];
	[scrollView addGestureRecognizer:self.panGestureRecognizer];
	
	UIEdgeInsets contentInset = scrollView.contentInset;
	contentInset.top -= self.maximumCoverHeight;	// contentInset.topで複雑な処理をしている場合は考慮していない
	scrollView.contentInset = contentInset;
	
	[childViewController.view removeFromSuperview];
}

#pragma mark - Accessor
- (void)setRootViewController:(UIViewController<CARScrollViewController> *)rootViewController {
	
	if (rootViewController == _rootViewController) {
		return;
	}
	
	[self view];

	[self hideChildScrollViewController];
	
	_rootViewController = rootViewController;

	[self initializeChildScrollViewController:rootViewController];
	[self showChildScrollViewController:rootViewController];
}

- (void)setMinimumCoverHeight:(CGFloat)minimumCoverHeight {

	_minimumCoverHeight = minimumCoverHeight;
	[self resetContentViewFrame];
	[self contentScrollViewDidScroll:self.rootViewController.scrollView.contentOffset];
}

- (void)setMaximumCoverHeight:(CGFloat)maximumCoverHeight {
	
	UIScrollView *scrollView = self.rootViewController.scrollView;
	UIEdgeInsets contentInset = scrollView.contentInset;
	
	contentInset.top -= self.maximumCoverHeight;
	contentInset.top += maximumCoverHeight;
	
	scrollView.contentInset = contentInset;
	_maximumCoverHeight = maximumCoverHeight;
}

#pragma mark - Subviews
- (void)initializeCoverView {
	
	CGRect frame = self.view.bounds;
	frame.size.height = self.minimumCoverHeight;
	
	_coverView = [[UIView alloc] initWithFrame:frame];
	_coverView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
	_coverView.clipsToBounds = YES;

	[self.view addSubview:_coverView];
}

- (void)initializeContentView {
	
	_contentView = [[UIView alloc] initWithFrame:self.contentViewFrame];
	_contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_contentView.clipsToBounds = YES;

	[self.view addSubview:_contentView];
}

- (CGRect)contentViewFrame {
		
	CGRect frame = self.view.bounds;
	frame.origin.y = self.minimumCoverHeight;
	frame.size.height -= frame.origin.y;
	
	return frame;
}

- (void)resetContentViewFrame {
	self.contentView.frame = self.contentViewFrame;
}

#pragma mark -
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	
	if ([keyPath isEqualToString:@"contentOffset"]) {
		NSValue *contentOffsetValue = change[@"new"];
		[self contentScrollViewDidScroll:contentOffsetValue.CGPointValue];
	}
}

#pragma mark - Zooming
- (void)contentScrollViewDidScroll:(CGPoint)contentOffset {
	
	CGFloat y = contentOffset.y;
	
	CGRect coverFrame = self.coverView.frame;
			
	if (y >= 0.0f) {
		coverFrame.size.height = self.minimumCoverHeight;
	}
	else {
		coverFrame.size.height = self.minimumCoverHeight - y;
	}
	
//	NSLog(@"%.3f, %@", y, [NSValue valueWithCGRect:coverFrame]);
	
	self.coverView.frame = coverFrame;
}

@end

@implementation UIViewController (CARCoverViewController)

- (CARCoverViewController *)coverViewController {
	
	for (UIViewController *viewController = self.parentViewController; viewController != nil; viewController = viewController.parentViewController) {
		if ([viewController isKindOfClass:[CARCoverViewController class]]) {
			return (CARCoverViewController *)viewController;
		}
	}
	
	return nil;
}

@end