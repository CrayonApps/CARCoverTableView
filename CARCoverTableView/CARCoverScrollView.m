//
//  CARCoverScrollView.m
//  CARCoverTableViewDemo
//
//  Created by Yamazaki Mitsuyoshi on 7/12/14.
//  Copyright (c) 2014 CrayonApps Inc. All rights reserved.
//

#import "CARCoverScrollView.h"

/**
 @brief view.gestureRecognizers から判別できるようにするためだけの空クラス
 */
@interface CARCoverScrollViewSelectionRecognizer : UITapGestureRecognizer
@end

@interface CARCoverScrollView ()

// 変更が一カ所のみのプロパティをreadonlyにしてみるテスト
@property (nonatomic, readonly) NSMutableDictionary *reusableCells;
@property (nonatomic, readonly) NSMutableDictionary *allCells;
@property (nonatomic, weak) NSArray *defaultSubviews;

@property (nonatomic, readonly) NSIndexSet *previousVisibleIndices;
@property (nonatomic, readonly) NSInteger itemCount;
@property (nonatomic, assign, getter = isReloadingData) BOOL reloadingData;
@property (nonatomic, readonly) NSDate *previousLayoutDate;
@property (nonatomic, readonly) CGPoint previousOffset;
@property (nonatomic, readonly) CGPoint velocity;
@property (nonatomic, assign, getter = isInertialScrolling) BOOL inertialScrolling;

- (void)initializeCoverScrollView;

- (void)reloadItemCount;

- (void)enqueueAllViews;
- (void)enqueueReuseableViewAtIndex:(NSInteger)index;
- (void)enqueueReusableCell:(CARCoverScrollViewCell *)cell;

- (void)getDatas;
- (void)prepareViews;

- (void)initializeView:(CARCoverScrollViewCell *)view;
- (void)viewDidSelect:(CARCoverScrollViewSelectionRecognizer *)gestureRecognizer;

- (void)updateCurrentIndex;
- (void)calculateVelocity;

- (void)resizeCells;

/**
 ページを中央に揃える
 */
- (void)fitCoverScrollViewPage;
- (void)didPan:(UIPanGestureRecognizer *)recognizer;

@end

@implementation CARCoverScrollView

@synthesize delegate = _coverScrollViewDelegate;
@synthesize currentIndex = _currentIndex;
@synthesize reusableCells = _reusableCells;
@synthesize allCells = _allCells;
@synthesize previousVisibleIndices = _previousVisibleIndices;
@synthesize itemCount = _itemCount;
@synthesize previousLayoutDate = _previousLayoutDate;
@synthesize previousOffset = _previousOffset;
@synthesize velocity = _velocity;
@synthesize roughPagingEnabled = _roughPagingEnabled;

@dynamic visibleIndices;

#pragma mark - Lifecycle
- (id)initWithFrame:(CGRect)frame {
	
	self = [super initWithFrame:frame];
	if (self) {
		[self initializeCoverScrollView];
	}
	return self;
}

- (void)awakeFromNib {
	[self initializeCoverScrollView];
	[super awakeFromNib];
}

- (void)initializeCoverScrollView {
	
	_itemCount = NSNotFound;
	_reusableCells = [[NSMutableDictionary alloc] init];
	_allCells = [[NSMutableDictionary alloc] init];
	self.defaultSubviews = self.subviews.copy;
	
	self.scrollsToTop = NO;
	
	NSAssert(self.panGestureRecognizer, @"");
	[self.panGestureRecognizer addTarget:self action:@selector(didPan:)];
}

#pragma mark - Accessor
- (void)setContentSize:(CGSize)contentSize {
		
	contentSize.height = 1.0f;
	
	[super setContentSize:contentSize];
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	[self resizeCells];
}

- (void)setDelegate:(id<CARCoverScrollViewDelegate>)delegate {
	
	_coverScrollViewDelegate = delegate;
	[super setDelegate:delegate];
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
	[self setCurrentIndex:currentIndex animated:NO];
}

- (void)setCurrentIndex:(NSInteger)currentIndex animated:(BOOL)animated {
	
	if (currentIndex >= self.itemCount) {
		[NSException raise:NSInvalidArgumentException format:@"currentIndex cannot be larger than dataSource.numberOfItemsInScrollView:"];
	}
	
	CGPoint contentOffset = self.contentOffset;
	contentOffset.x = currentIndex * self.bounds.size.width;
	
	[self setContentOffset:contentOffset animated:animated];
	
	BOOL callDelegate = _currentIndex != currentIndex;
	_currentIndex = currentIndex;
	
	if (callDelegate) {
		if ([self.delegate respondsToSelector:@selector(coverScrollView:didUpdateCurrentIndex:)]) {
			[self.delegate coverScrollView:self didUpdateCurrentIndex:currentIndex];
		}
	}
}

- (NSInteger)itemCount {
	
	if (_itemCount == NSNotFound) {
		[self reloadItemCount];
	}
	return _itemCount;
}

- (void)setRoughPagingEnabled:(BOOL)roughPagingEnabled {
	
	/**
	 self.roughPagingEnabled = YES で強制的に fitCoverScrollViewPage を呼べるようにしている
	if (_roughPagingEnabled == roughPagingEnabled) {
		return;
	}
	 */
	
	if (roughPagingEnabled) {
		self.inertialScrolling = YES;
		[self fitCoverScrollViewPage];
	}
	
	_roughPagingEnabled = roughPagingEnabled;
}

- (NSIndexSet *)visibleIndices {
		
	if (self.itemCount == 0) {
		return nil;
	}
	
	CGFloat x = self.contentOffset.x;
	CGFloat boundsWidth = self.bounds.size.width;
	
	if (boundsWidth == 0.0f) {
		return nil;
	}
	
	NSInteger floorX = floorf(x);
	NSInteger floorBoundsWidth = floorf(boundsWidth);
	NSInteger index = floorX / floorBoundsWidth;
	
	if (index >= self.itemCount) {
		// landscpeで右端のcellを表示した状態でportraitに戻すとindexがitemCountを超える。
		// setContentSizeやsetContentOffsetが呼ばれる以前にlayoutSubviewsが呼ばれるのでそれらでは解決できない。タイミング的にはViewControllerのwillRotateToInterfaceOrientation:duration:とwillAnimateRotationToInterfaceOrientation:duration:の間
		// 回転時にここに引っかかっても、回転終了時にもう一度layoutSubviewsが呼ばれるようなので問題ないはず
		return nil;
	}
	
	// 1px以下のスクロール時に正確な値が返せないと思われる
	// numberOfItemsを超えて1画面分スクロールするとout of boundsになると思われる（可能なのか？）
	if (floorX % floorBoundsWidth == 0.0f) {
		return [NSIndexSet indexSetWithIndex:index];
	}
	
	if (index >= self.itemCount - 1) {
		return [NSIndexSet indexSetWithIndex:index];
	}
	if (index < 0) {
		return [NSIndexSet indexSetWithIndex:0];
	}
	
	NSMutableIndexSet *indices = [NSMutableIndexSet indexSet];
	[indices addIndex:index + 1];
	[indices addIndex:index];
	
	return indices;
}

- (CARCoverScrollViewCell *)coverScrollViewCellAtIndex:(NSInteger)index {
	
	NSIndexSet *visibleIndices = self.visibleIndices;
	
	if ([visibleIndices containsIndex:index] == NO) {
		return nil;
	}
	
	return self.allCells[@(index)];
}

#pragma mark - Reusable Views
- (id)dequeReusableCellWithIdentifier:(NSString *)identifier {

	NSMutableArray *viewArray = self.reusableCells[identifier];
	CARCoverScrollViewCell *view = viewArray.lastObject;
	[viewArray removeLastObject];
	
	return view;
}

- (void)enqueueAllViews {
	
	NSArray *cellArray = [self.allCells allValues];
		
	for (CARCoverScrollViewCell *cell in cellArray) {
		[self enqueueReusableCell:cell];
	}
	[self.allCells removeAllObjects];
}

- (void)enqueueReuseableViewAtIndex:(NSInteger)index {
	
	CARCoverScrollViewCell *cell = self.allCells[@(index)];
	
	if (cell == nil) {
		return;
	}
	
	[self.allCells removeObjectForKey:@(index)];
	[self enqueueReusableCell:cell];
}

- (void)enqueueReusableCell:(CARCoverScrollViewCell *)cell {
	
	[cell removeFromSuperview];
	
	if (self.reusableCells[cell.reuseIdentifier] == nil) {
		self.reusableCells[cell.reuseIdentifier] = [[NSMutableArray alloc] init];
	}
	[self.reusableCells[cell.reuseIdentifier] addObject:cell];
}

#pragma mark - Reload
- (void)reloadData {
	
	self.reloadingData = YES;
	
	[self getDatas];
	[self setNeedsLayout];
}

- (void)reloadItemCount {
	NSAssert([self.dataSource respondsToSelector:@selector(numberOfItemsInCoverScrollView:)], @"");
	_itemCount = [self.dataSource numberOfItemsInCoverScrollView:self];
}

- (void)getDatas {
	
	[self reloadItemCount];

	CGSize contentSize = self.bounds.size;
	contentSize.width *= self.itemCount;
	
	self.contentSize = contentSize;
}

#pragma mark -
- (void)updateCurrentIndex {
	
	CGFloat x = self.contentOffset.x;
	CGFloat width = self.bounds.size.width;
	x += width / 2.0f;
	
	NSInteger newIndex = (NSInteger)(x / width);
	
	if (newIndex < 0) {
		newIndex = 0;
	}
	if (newIndex >= self.itemCount) {
		newIndex = self.itemCount - 1;
	}
	
	if (newIndex != self.currentIndex) {
		_currentIndex = newIndex;	// self.setCurrentIndexを呼ぶとcontentOffsetがアップデートされるので
		
		if ([self.delegate respondsToSelector:@selector(coverScrollView:didUpdateCurrentIndex:)]) {
			[self.delegate coverScrollView:self didUpdateCurrentIndex:newIndex];
		}
	}
}

- (void)calculateVelocity {
	
	// layoutSubviews 以外から呼ばれることは想定していない
	
	NSDate *now = [NSDate date];
	NSTimeInterval interval = [now timeIntervalSinceDate:self.previousLayoutDate];

	if (interval < 0.01) {
		// スクロールのないときに呼ばれることを防ぐため：スクロール時に layoutSubviews が呼ばれる間隔を測ったところ 0.01~0.03 だった
		return;
	}
	
	if (self.previousLayoutDate) {
		// 最後の _previousLayoutDate 代入があるので、if条件を逆にしてreturnができない
		
		CGPoint diff = CGPointZero;
		diff.x = self.contentOffset.x - self.previousOffset.x;
		diff.y = self.contentOffset.y - self.previousOffset.y;
		
		CGPoint currentVelocity = CGPointZero;
		currentVelocity.x = diff.x / interval;
		currentVelocity.y = diff.y / interval;
		
		_velocity = currentVelocity;
		
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fitCoverScrollViewPage) object:nil];
		
		if (fabsf(self.velocity.x) < 200.0f) {
			[self fitCoverScrollViewPage];
		}
	}

	_previousLayoutDate = now;
	_previousOffset = self.contentOffset;
}

#pragma mark - Layout
- (void)layoutSubviews {
	
	[super layoutSubviews];
	
	[self prepareViews];
	[self updateCurrentIndex];
	[self calculateVelocity];
}

- (void)prepareViews {
	
	NSIndexSet *addViewIndices = nil;
	NSIndexSet *visibleIndices = self.visibleIndices;

	if (self.isReloadingData) {
		[self enqueueAllViews];
		
		addViewIndices = self.visibleIndices;
	}
	else {
	
		NSMutableIndexSet *indices = [NSMutableIndexSet indexSet];
		
		[self.previousVisibleIndices enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
			
			if ([visibleIndices containsIndex:idx] == NO) {
				[self enqueueReuseableViewAtIndex:idx];
			}
		}];

		[visibleIndices enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
			
			if ([self.previousVisibleIndices containsIndex:idx] == NO) {
				[indices addIndex:idx];
			}
		}];

		addViewIndices = indices.copy;
	}
	
	CGFloat boundsWidth = self.bounds.size.width;
	
	[addViewIndices enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
		
		NSAssert([self.dataSource respondsToSelector:@selector(coverScrollView:cellAtIndex:)], @"");
		
		CARCoverScrollViewCell *cell = [self.dataSource coverScrollView:self cellAtIndex:idx];
		NSAssert(cell, @"");
		NSAssert(cell.reuseIdentifier, @"");
		
		[self initializeView:cell];
		
		CGRect frame = self.frame;
		frame.origin.y = 0.0f;
		frame.origin.x = boundsWidth * idx;
		
		cell.frame = frame;
		[self addSubview:cell];

		self.allCells[@(idx)] = cell;
	}];
	
	for (UIView *view in self.defaultSubviews) {
		[self bringSubviewToFront:view];
	}
	
	_previousVisibleIndices = visibleIndices.copy;
	
	self.reloadingData = NO;
}

#pragma mark Resizing
- (void)resizeCells {
	
	for (NSNumber *key in self.allCells.allKeys) {
	
		NSInteger index = key.integerValue;
		CGFloat width = self.frame.size.width;
		CARCoverScrollViewCell *cell = self.allCells[key];
		
		CGRect frame = CGRectZero;
		frame.origin.x = index * width;
		frame.size = self.frame.size;
		
		cell.frame = frame;
	}
}

#pragma mark - View Initialization
- (void)initializeView:(UIView *)view {
	
	BOOL hasSelectionRecognizer = NO;
	
	for (UIGestureRecognizer *recognizer in view.gestureRecognizers) {
		if ([recognizer isKindOfClass:[CARCoverScrollViewSelectionRecognizer class]]) {
			hasSelectionRecognizer = YES;
			break;
		}
	}
	
	if (hasSelectionRecognizer == NO) {
		CARCoverScrollViewSelectionRecognizer *gestureRecognizer = [[CARCoverScrollViewSelectionRecognizer alloc] initWithTarget:self action:@selector(viewDidSelect:)];
		gestureRecognizer.cancelsTouchesInView = NO;
		[view addGestureRecognizer:gestureRecognizer];
	}
	
	view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

#pragma mark - View Selection
- (void)viewDidSelect:(CARCoverScrollViewSelectionRecognizer *)gestureRecognizer {
	
	if ([self.delegate respondsToSelector:@selector(coverScrollView:didSelectItemAtIndex:)]) {
		UIView *view = gestureRecognizer.view;
		NSNumber *key = [_allCells allKeysForObject:view][0];
		NSInteger index = key.integerValue;
		
		[self.delegate coverScrollView:self didSelectItemAtIndex:index];
	}
}

#pragma mark - UIPanGestureRecognizer Receivers
- (void)didPan:(UIPanGestureRecognizer *)recognizer {
	
	switch (recognizer.state) {
		case UIGestureRecognizerStateChanged:
			self.inertialScrolling = NO;
			break;
			
		case UIGestureRecognizerStateEnded:
		case UIGestureRecognizerStateCancelled:
		case UIGestureRecognizerStateFailed: {
			
			CGPoint velocityInView = [recognizer velocityInView:self];
			self.inertialScrolling = YES;
			
			if (velocityInView.x == 0.0f) {
				[self fitCoverScrollViewPage];
			}
			else {
				// didPan より layoutSubviews の方が先に呼ばれるのでここであらかじめ呼んでおく。
				// スクロールが
				[self performSelector:@selector(fitCoverScrollViewPage) withObject:nil afterDelay:0.05];
			}
			break;
		}
		default:
			break;
	}
}

- (void)fitCoverScrollViewPage {

	if (self.inertialScrolling == NO) {
		return;
	}
	self.inertialScrolling = NO;
	
	if (self.isRoughPagingEnabled == NO) {
		return;
	}
	
	CGFloat x = self.contentOffset.x;
	CGFloat boundsWidth = self.bounds.size.width;
	
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
	CGPoint contentOffset = self.contentOffset;
	
	if (x > threshold) {
		contentOffset.x = boundsWidth * (index + 1);
	}
	else {
		contentOffset.x = boundsWidth * index;
	}
	
	CGFloat maxContentOffsetX = self.contentSize.width - boundsWidth;
	
	if (contentOffset.x < 0.0f) {
		contentOffset.x = 0.0f;
	}
	else if (contentOffset.x > maxContentOffsetX) {
		contentOffset.x = maxContentOffsetX;
	}
	
	[self setContentOffset:contentOffset animated:YES];
}

@end

@implementation CARCoverScrollViewCell
@end

@implementation CARCoverScrollViewSelectionRecognizer
@end