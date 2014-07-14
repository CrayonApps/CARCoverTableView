//
//  CARCoverScrollViewController.h
//  CARCoverTableViewDemo
//
//  Created by Yamazaki Mitsuyoshi on 7/11/14.
//  Copyright (c) 2014 CrayonApps Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CARCoverTableView.h"
#import "CARCoverScrollView.h"

@interface CARCoverScrollViewController : UITableViewController

@property (nonatomic, weak) IBOutlet CARCoverScrollView *coverScrollView;
@property (nonatomic, readonly) CARCoverTableView *coverTableView;

- (void)coverScrollViewDidFinishScrolling;

@end
