//
//  CARCoverCollectionView.m
//  CARCoverTableViewDemo
//
//  Created by Yamazaki Mitsuyoshi on 8/5/14.
//  Copyright (c) 2014 CrayonApps Inc. All rights reserved.
//

#import "CARCoverCollectionView.h"

@interface CARCoverCollectionView ()

- (void)createSubviews;
- (void)initializeCoverCollectionView;

@end

@implementation CARCoverCollectionView

@synthesize coverHeight = _coverHeight;
@synthesize borderHeight = _borderHeight;

#pragma mark - Accessor
- (void)setCoverHeight:(CGFloat)coverHeight borderHeight:(CGFloat)borderHeight {
	
	// スクロール中にセットするとバグると思う
	_coverHeight = coverHeight;
	_borderHeight = borderHeight;
	
	CGRect coverFrame = self.bounds;
	coverFrame.origin.y = -(self.coverHeight + self.borderHeight);
	coverFrame.size.height = self.coverHeight + self.borderHeight;
	self.coverView.frame = coverFrame;
	
	CGRect borderFrame = self.bounds;
	borderFrame.origin.y = -(self.borderHeight);
	borderFrame.size.height = self.borderHeight;
	self.borderView.frame = borderFrame;
	
	UIEdgeInsets contentInset = self.contentInset;
	contentInset.top = self.coverHeight + self.borderHeight;
	
	self.contentInset = contentInset;
	[self setNeedsLayout];
}

#pragma mark - Lifecycle
- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
	
	self = [super initWithFrame:frame collectionViewLayout:layout];
	if (self) {
		[self createSubviews];
		[self initializeCoverCollectionView];
	}
	return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	
	// InterfaceBuilder doesn't allow UICollectionView to addsubview so set coverView & borderView as backgroundView or somewhere
	NSAssert(self.coverView, @"coverView must be set");
	NSAssert(self.borderView, @"borderView must be set");
	
	UIView *cover = self.coverView;	// prevents release
	UIView *border = self.borderView;
	NSArray *views = @[self.coverView, self.borderView];
	
	if ([views containsObject:self.backgroundView]) {
		self.backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
		self.backgroundView = nil;
	}
		
	[cover removeFromSuperview];
	[self addSubview:cover];
	
	[border removeFromSuperview];
	[self addSubview:border];
	
	[self setCoverHeight:cover.frame.size.height borderHeight:border.frame.size.height];
	[self initializeCoverCollectionView];
}

- (void)createSubviews {
	
	self.showsHorizontalScrollIndicator = NO;
	self.showsVerticalScrollIndicator = YES;
	self.alwaysBounceVertical = YES;
	self.alwaysBounceHorizontal = NO;
	self.backgroundColor = [UIColor clearColor];
	self.clipsToBounds = YES;
	
	_coverHeight = 300.0f;
	_borderHeight = 80.0f;
	
	CGRect coverFrame = self.bounds;
	coverFrame.origin.y = -(self.coverHeight + self.borderHeight);
	coverFrame.size.height = self.coverHeight;
	
	UIView *cover = [[UIView alloc] initWithFrame:coverFrame];
	self.coverView = cover;
	self.coverView.backgroundColor = [UIColor whiteColor];
	self.coverView.autoresizingMask = UIViewAutoresizingNone;//UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.coverView.clipsToBounds = YES;
	
	[self addSubview:self.coverView];
	
	CGRect borderFrame = self.bounds;
	borderFrame.origin.y = -self.borderHeight;
	borderFrame.size.height = self.borderHeight;
	
	UIView *border = [[UIView alloc] initWithFrame:borderFrame];
	self.borderView = border;
	self.borderView.backgroundColor = self.backgroundColor;
	self.borderView.autoresizingMask = UIViewAutoresizingNone;//UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.borderView.clipsToBounds = YES;
	
	[self addSubview:self.borderView];
	
	[self setCoverHeight:self.coverHeight borderHeight:self.borderHeight];
}

- (void)initializeCoverCollectionView {

	self.minimumCoverHeight = 200.0f;
	self.coverView.clipsToBounds = YES;
	self.borderView.clipsToBounds = YES;
}

- (void)layoutSubviews {
	
	[super layoutSubviews];
	
	CGFloat y = self.contentOffset.y;
	
	CGRect coverFrame = self.coverView.frame;
	CGRect borderFrame = self.borderView.frame;
	CGFloat diff = -self.contentInset.top - y;
	
	if (y <= -self.contentInset.top) {
		
		borderFrame.origin.y = -(self.borderHeight);
		
		coverFrame.size.height = self.coverHeight + self.borderHeight + diff;
	}
	else {
		
		borderFrame.origin.y = -(self.borderHeight);
		
		if (y < -self.minimumCoverHeight) {
			// 途中
			coverFrame.size.height = self.coverHeight + self.borderHeight + diff;
		}
		else {
			// 上
			coverFrame.size.height = self.coverHeight + self.borderHeight + (-self.contentInset.top + self.minimumCoverHeight);
			borderFrame.origin.y = y + self.coverHeight - self.contentInset.top + self.minimumCoverHeight;
		}
	}
	
	coverFrame.origin.y = y;
	
	self.coverView.frame = coverFrame;
	self.borderView.frame = borderFrame;
}

- (void)didAddSubview:(UIView *)subview {
	[super didAddSubview:subview];
	
	[self bringSubviewToFront:self.coverView];
	[self bringSubviewToFront:self.borderView];
}

@end
