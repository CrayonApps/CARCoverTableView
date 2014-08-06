//
//  CARCoverCollectionView.h
//  CARCoverTableViewDemo
//
//  Created by Yamazaki Mitsuyoshi on 8/5/14.
//  Copyright (c) 2014 CrayonApps Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CARCoverCollectionView : UICollectionView

@property (nonatomic, weak) IBOutlet UIView *coverView;
@property (nonatomic, weak) IBOutlet UIView *borderView;

@property (nonatomic, readonly) CGFloat coverHeight;
@property (nonatomic, readonly) CGFloat borderHeight;
@property (nonatomic) CGFloat minimumCoverHeight;

- (void)setCoverHeight:(CGFloat)coverHeight borderHeight:(CGFloat)borderHeight;

@end
