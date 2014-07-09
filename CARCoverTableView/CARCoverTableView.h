//
//  CARCoverTableView.h
//  kcrwradio
//
//  Created by Yamazaki Mitsuyoshi on 1/21/14.
//  Copyright (c) 2014 CrayonApps inc. All rights reserved.
//

#import <UIKit/UIKit.h>

// Use of this class with constrants is discouraged. When following logs appear and the application terminates, try to not use auto layout.
// Assertion failure in -[CARCoverTableView layoutSublayersOfLayer:]
// Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'Auto Layout still required after executing -layoutSubviews. CARCoverTableView's implementation of -layoutSubviews needs to call super.'

@interface CARCoverTableView : UITableView

@property (nonatomic, weak) IBOutlet UIView *coverView;
@property (nonatomic, weak) IBOutlet UIView *borderView;

@property (nonatomic, readonly) CGFloat coverHeight;
@property (nonatomic, readonly) CGFloat borderHeight;
@property (nonatomic) CGFloat minimumCoverHeight;

- (void)setCoverHeight:(CGFloat)coverHeight borderHeight:(CGFloat)borderHeight;

@end
