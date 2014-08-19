//
//  CARCoverViewController.m
//  CARCoverTableViewDemo
//
//  Created by Yamazaki Mitsuyoshi on 8/11/14.
//  Copyright (c) 2014 CrayonApps Inc. All rights reserved.
//

#import "CARCoverViewController.h"

@interface CARCoverViewController ()

@property (nonatomic, readonly) UIViewController *rootViewController;
@property (nonatomic, readonly) UIScrollView *rootScrollView;

- (void)initializeCoverView;
- (void)initializeContentView;

- (void)contentScrollViewDidScroll:(CGPoint)contentOffset;

@end

@implementation CARCoverViewController

@synthesize coverView = _coverView;
@synthesize contentView = _contentView;
@synthesize minimumCoverHeight = _minimumCoverHeight;
@synthesize maximumCoverHeight = _maximumCoverHeight;
@synthesize rootViewController = _rootViewController;
@synthesize rootScrollView = _rootScrollView;
@synthesize panGestureRecognizer = _panGestureRecognizer;

- (id)initWithRootViewController:(UIViewController *)rootViewController scrollView:(UIScrollView *)scrollView {

	if ((rootViewController == nil) || (scrollView == nil)) {
		[NSException raise:NSInvalidArgumentException format:@"missing arguments"];
	}
	
	self = [super init];
	if (self) {
		
		[self initializeCoverViewController];
		
		_rootViewController = rootViewController;
		_rootScrollView = scrollView;
		[self initializeChildScrollViewController:rootViewController];
	}
	return self;
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

	// サブクラスで上書きするとき、_rootViewControllerがnilなら実行されない
	if ((self.rootViewController != nil) && (self.rootScrollView != nil)) {
		[self showChildScrollViewController:self.rootViewController scrollView:self.rootScrollView];
	}
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
- (void)initializeChildScrollViewController:(UIViewController *)childController {

	[childController removeFromParentViewController];
	[childController willMoveToParentViewController:self];
	
	[self addChildViewController:childController];
	[childController didMoveToParentViewController:self];
}

- (void)showChildScrollViewController:(UIViewController *)childController scrollView:(UIScrollView *)scrollView {

	[childController view];
	
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

#pragma mark - Accessor
- (void)setMinimumCoverHeight:(CGFloat)minimumCoverHeight {
// TODO: 書く
	[self doesNotRecognizeSelector:_cmd];
}

- (void)setMaximumCoverHeight:(CGFloat)maximumCoverHeight {
	// TODO: 書く
	// TODO: scrollView.contentInset.topがこの値を参照しているので差分を調整する必要がある
	[self doesNotRecognizeSelector:_cmd];
}

#pragma mark - Subviews
- (void)initializeCoverView {
	
	CGRect frame = self.view.bounds;
	frame.size.height = self.minimumCoverHeight;
	
	_coverView = [[UIView alloc] initWithFrame:frame];
	_coverView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_coverView.clipsToBounds = YES;

	[self.view addSubview:_coverView];
}

- (void)initializeContentView {
	
	CGRect frame = self.view.bounds;
	frame.origin.y = self.minimumCoverHeight;
	frame.size.height -= frame.origin.y;
	
	_contentView = [[UIView alloc] initWithFrame:frame];
	_contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_contentView.clipsToBounds = YES;

	[self.view addSubview:_contentView];
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
