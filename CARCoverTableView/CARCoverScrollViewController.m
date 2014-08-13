//
//  CARCoverScrollViewController.m
//  CARCoverTableViewDemo
//
//  Created by Yamazaki Mitsuyoshi on 8/11/14.
//  Copyright (c) 2014 CrayonApps Inc. All rights reserved.
//

#import "CARCoverScrollViewController.h"

@interface CARCoverScrollViewController ()

@property (nonatomic, readonly) NSMutableArray *childViewControllers;
@property (nonatomic, readonly) NSMutableArray *scrollViews;

@end

@implementation CARCoverScrollViewController

@synthesize childViewControllers = _childViewControllers;
@synthesize scrollViews = _scrollViews;
@dynamic viewControllers;

- (id)initWithRootViewController:(UIViewController *)rootViewController scrollView:(UIScrollView *)scrollView {
	
	self = [super init];
	if (self) {

		// TODO: rootViewController
		
		_childViewControllers = [[NSMutableArray alloc] init];
		_scrollViews = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

#pragma mark - Accessor
- (NSArray *)viewControllers {
	return self.childViewControllers.copy;
}

#pragma mark - ContainerViewController Methods
- (void)addChildScrollViewController:(UIViewController *)childController scrollView:(UIScrollView *)scrollView {
	[self insertChildScrollViewController:childController scrollView:scrollView atIndex:self.viewControllers.count];
}

- (void)insertChildScrollViewController:(UIViewController *)childController scrollView:(UIScrollView *)scrollView atIndex:(NSInteger)index {
	
	[self.childViewControllers insertObject:childController atIndex:index];
	[self initializeChildScrollViewController:childController scrollView:scrollView];
}

#pragma mark - CARCoverScrollViewDataSource
- (NSInteger)numberOfItemsInScrollView:(CARCoverScrollView *)scrollView {
	[self doesNotRecognizeSelector:_cmd];
	return 0;
}

- (UIView *)scrollView:(CARCoverScrollView *)scrollView viewAtIndex:(NSInteger)index {
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

#pragma mark - CARCoverScrollViewDelegate
/*
- (void)scrollView:(CARCoverScrollView *)scrollView didSelectItemAtIndex:(NSInteger)index {
	NSLog(@"CARCoverScrollView did select item at index: %ld", (long)index);
}
*/

@end
